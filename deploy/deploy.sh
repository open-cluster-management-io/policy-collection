#!/bin/bash

set -e
set -o pipefail

# Display help information
help () {
  echo "Deploy policies to Red Hat Advanced Cluster Management via GitOps"
  echo ""
  echo "Prerequisites:"
  echo " - oc or kubectl CLI must be pointing to the cluster to which to deploy policies"
  echo " - The desired cluster namespace should already exist"
  echo ""
  echo "Usage:"
  echo "  ./deploy.sh [-u <url>] [-b <branch>] [-p <path/to/dir>] [-n <namespace>] [-a|--name <resource-name>]"
  echo ""
  echo "  -h|--help                   Display this menu"
  echo "  -u|--url <url>              URL to the Git repository"
  echo '                                (Default URL: "https://github.com/open-cluster-management/policy-collection.git")'
  echo "  -b|--branch <branch>        Branch of the Git repository to point to"
  echo '                                (Default branch: "master")'
  echo "  -p|--path <path/to/dir>     Path to the desired subdirectory of the Git repository"
  echo "                                (Default path: stable)"
  echo "  -n|--namespace <namespace>  Namespace on the cluster to deploy policies to (must exist already)"
  echo '                                (Default namespace: "policies")'
  echo "  -a|--name <resource-name>   Prefix for the Channel and Subscription resources"
  echo '                                (Default name: "demo-stable-policies")'
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
echo "Git URL:            ${GH_URL:=https://github.com/open-cluster-management/policy-collection.git}"
echo "Git Branch:         ${GH_BRANCH:=master}"
echo "Git Path:           ${GH_PATH:=stable}"
echo "====================================================="

while read -r -p "Would you like to proceed (y/n)? " response; do
  case "$response" in
    Y|y|Yes|yes ) break
                  ;;
    N|n|No|no )   exit 1
                  ;;
  esac
done

# Populate the Channel template
CHAN_CFG=$(cat "channel_template.json" |
  sed "s/##NAME##/${NAME}/g" |
  sed "s%##GH_URL##%${GH_URL}%g")
echo "$CHAN_CFG" > channel_patch.json

# Populate the Subscription template
SUBSCRIPTION_CFG=$(cat "subscription_template.json" |
  sed "s%##GH_PATH##%${GH_PATH}%g" |
  sed "s/##GH_BRANCH##/${GH_BRANCH}/g" |
  sed "s/##NAME##/${NAME}/g" |
  sed "s/##NAMESPACE##/${NAMESPACE}/g")
echo "$SUBSCRIPTION_CFG" > subscription_patch.json

# Populate the Kustomize template
KUST_CFG=$(cat "kustomization_template.yaml" |
  sed "s/##NAME##/${NAME}/g" |
  sed "s/##NAMESPACE##/${NAMESPACE}/g")
echo "$KUST_CFG" > kustomization.yaml

# Deploy the resources to the cluster
kubectl kustomize . > resources.yaml
kubectl apply -f resources.yaml

# Remove artifacts
rm channel_patch.json
rm subscription_patch.json
rm kustomization.yaml
rm resources.yaml
