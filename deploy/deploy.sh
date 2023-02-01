#!/bin/bash

set -e
set -o pipefail

# Display help information
help () {
  echo "Deploy policies to Open Cluster Management via GitOps"
  echo ""
  echo "Prerequisites:"
  echo " - oc or kubectl CLI must be pointing to the cluster to which to deploy policies"
  echo ""
  echo "Usage:"
  echo "  ./deploy.sh [-u <url>] [-b <branch>] [-p <path/to/dir>] [-n <namespace>]"
  echo "              [-a|--name <resource-name>] [--deploy-app] [--dry-run]"
  echo ""
  echo "  -h|--help                   Display this menu"
  echo "  -u|--url <url>              URL to the Git repository"
  echo '                                (Default URL: "https://github.com/open-cluster-management-io/policy-collection.git")'
  echo "  -b|--branch <branch>        Branch of the Git repository to point to"
  echo '                                (Default branch: "main")'
  echo "  -p|--path <path/to/dir>     Path to the desired subdirectory of the Git repository"
  echo "                                (Default path: stable)"
  echo "  -n|--namespace <namespace>  Namespace on the cluster to deploy policies to (must exist already)"
  echo '                                (Default namespace: "policies")'
  echo "  -a|--name <resource-name>   Prefix for the Channel and Subscription resources"
  echo '                                (Default name: "demo-stable-policies")'
  echo "  -s|--sync <rate>            How frequently the github resources are compared to the hub resources"
  echo '                                (Default rate: "medium") Rates: "high", "medium", "low", "off"'
  echo "  --deploy-app                Create an Application manifest for additional visibility in the UI"
  echo "                                (Search should also be enabled in the Hub cluster)"
  echo "  --dry-run                   Print the YAML to stdout without applying them to the cluster"
  echo ""
}

# Parse arguments
while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            -h|--help)
            help
            exit 0
            ;;
            -u|--url)
            shift
            GH_URL=${1}
            shift
            ;;
            -b|--branch)
            shift
            GH_BRANCH=${1}
            shift
            ;;
            -p|--path)
            shift
            GH_PATH=${1}
            shift
            ;;
            -n|--namespace)
            shift
            NAMESPACE=${1}
            shift
            ;;
            -a|--name)
            shift
            NAME=${1}
            shift
            ;;
            -s|--sync)
            shift
            RATE=${1}
            shift
            ;;
            --deploy-app)
            shift
            DEPLOY_APP="true"
            ;;
            --dry-run)
            shift
            DRY_RUN="true"
            ;;
            *)    # default
            echo "Invalid input: ${1}"
            exit 1
            shift
            ;;
        esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# Display configuration and set default values if needed
echo "Deploying policies using the following configuration:"
echo "====================================================="
echo "kubectl config:     $(kubectl config get-contexts | awk '/^\052/ {print $4"/"$3}')"
echo "Cluster Namespace:  ${NAMESPACE:=policies}"
echo "Resource Prefix:    ${NAME:=demo-stable-policies}"
echo "Git URL:            ${GH_URL:=https://github.com/open-cluster-management-io/policy-collection.git}"
echo "Git Branch:         ${GH_BRANCH:=main}"
echo "Git Path:           ${GH_PATH:=stable}"
echo "Sync Rate:          ${RATE:=medium}"
echo "Create Application: ${DEPLOY_APP:=false}"
echo "Dry run:            ${DRY_RUN:=false}"
echo "====================================================="

while read -r -p "Would you like to proceed (y/n)? " response; do
  case "$response" in
    Y|y|Yes|yes ) break
                  ;;
    N|n|No|no )   exit 1
                  ;;
  esac
done

if [ "$DRY_RUN" != "true" ]; then
  # Check for the namespace
  echo "* Checking for namespace ${NAMESPACE}"
  if ! kubectl get ns ${NAMESPACE} &>/dev/null; then
    while read -r -p "Namespace '${NAMESPACE}' not found. Would you like to create it (y/n)? " response; do
      case "$response" in
        Y|y|Yes|yes ) kubectl create ns "${NAMESPACE}"
                      break
                      ;;
        N|n|No|no )   exit 1
                      ;;
      esac
    done
  fi
fi

# Populate the Channel template
CHAN_CFG=$(cat "channel_template.json" |
  sed "s/##NAME##/${NAME}/g" |
  sed "s%##GH_URL##%${GH_URL}%g" |
  sed "s%##RATE##%${RATE}%g")
echo "$CHAN_CFG" > channel_patch.json

# Populate the Subscription template
SUBSCRIPTION_CFG=$(cat "subscription_template.json" |
  sed "s%##GH_PATH##%${GH_PATH}%g" |
  sed "s/##GH_BRANCH##/${GH_BRANCH}/g" |
  sed "s/##NAME##/${NAME}/g" |
  sed "s/##NAMESPACE##/${NAMESPACE}/g")
echo "$SUBSCRIPTION_CFG" > subscription_patch.json

# The Application and Placement are only needed for `--deploy-app`
if [ "${DEPLOY_APP}" = "true" ]; then
  # Populate the Application template
  APPLICATION_CFG=$(cat "application_template.json" |
    sed "s/##NAME##/${NAME}/g")
  echo "$APPLICATION_CFG" > application_patch.json

  # Populate the Placement templates
  PLACEMENT_CFG=$(cat "placement_template.json" |
    sed "s/##NAME##/${NAME}/g")
  echo "$PLACEMENT_CFG" > placement_patch.json
  SUB_PLACEMENT_CFG=$(cat "subscription_placement_template.json" |
    sed "s/##NAME##/${NAME}/g")
  echo "$SUB_PLACEMENT_CFG" > subscription_placement_patch.json
fi

# Populate the Kustomize template
KUST_CFG=$(cat "kustomization_template.yaml" |
  sed "s/##NAME##/${NAME}/g" |
  sed "s/##NAMESPACE##/${NAMESPACE}/g")
# Uncomment Application manifests to generate them
if [ "${DEPLOY_APP}" = "true" ]; then
  KUST_CFG=$(echo "$KUST_CFG" | sed "s/##//g")
fi
echo "$KUST_CFG" > kustomization.yaml

# Deploy the resources to the cluster
kubectl kustomize . > manifests.yaml
echo "* Subscription manifests saved to 'manifests.yaml'"
if [ "$DRY_RUN" = "true" ]; then
  echo "* Dry-run is enabled. Not creating resources on cluster."
  echo "* Displaying manifests from manifests.yaml:"
  echo "---"
  cat manifests.yaml
else
  printf ""
  kubectl apply -f manifests.yaml
fi

# Remove artifacts
rm *_patch.json
rm kustomization.yaml
