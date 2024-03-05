#!/bin/bash

set -e
set -o pipefail

# Display help information
help () {
  echo "Deploy policies to Open Cluster Management via OpenShift GitOps"
  echo ""
  echo "Prerequisites:"
  echo " - oc or kubectl CLI must be pointing to the cluster to which to deploy policies"
  echo " - OpenShift Gitops must be installed and functional"
  echo ""
  echo "Usage:"
  echo "  ./deploy.sh [-u <url>] [-b <branch>] [-p <path/to/dir>] [-n <namespace>]"
  echo "              [-a|--name <application-name>] [--dry-run]"
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
  echo "  -a|--name <resource-name>   The name of the OpenShift Gitops Application"
  echo '                                (Default name: "demo-stable-policies")'
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

if ! kubectl get deployment openshift-gitops-server -n openshift-gitops &>/dev/null; then
  echo "The OpenShift Gitops server is required, but is not installed."
  exit 1
fi

# Display configuration and set default values if needed
echo "Deploying policies using the following configuration:"
echo "====================================================="
echo "kubectl config:     $(kubectl config get-contexts | awk '/^\052/ {print $4"/"$3}')"
echo "Cluster Namespace:  ${NAMESPACE:=policies}"
echo "Application name:   ${NAME:=demo-stable-policies}"
echo "Git URL:            ${GH_URL:=https://github.com/open-cluster-management-io/policy-collection.git}"
echo "Git Branch:         ${GH_BRANCH:=main}"
echo "Git Path:           ${GH_PATH:=stable}"
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

APPLICATION="apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: $NAME
  namespace: openshift-gitops
spec:
  destination:
    namespace: $NAMESPACE
    server: https://kubernetes.default.svc
  project: default
  source:
    path: $GH_PATH
    repoURL: $GH_URL
    targetRevision: $GH_BRANCH
  syncPolicy:
    automated: {}
    syncOptions:
    - CreateNamespace=true"

# Deploy the resources to the cluster
echo "$APPLICATION" > manifests.yaml
echo "* Application manifests saved to 'manifests.yaml'"
if [ "$DRY_RUN" = "true" ]; then
  echo "* Dry-run is enabled. Not creating resources on cluster."
  echo "---"
  echo "$APPLICATION"
else
  printf ""
  echo "$APPLICATION" | kubectl apply -f -
fi

