#! /bin/bash

# Display help information
help () {
  echo "# Remove resources from Red Hat Advanced Cluster Management created via deploy.sh"
  echo '```'
  echo "Prerequisites:"
  echo " - oc CLI should be pointing to the cluster to remove from"
  echo " - Channel and Subscription should have been deployed using the deploy.sh script"
  echo "   (or match the pattern <prefix>-chan and <prefix>-sub)"
  echo ""
  echo "Usage:"
  echo "  ./remove.sh [-n <namespace>] [-a|--name <resource-name>]"
  echo ""
  echo "  -h|--help                   Display this menu"
  echo "  -n|--namespace <namespace>  Namespace on the cluster that resources are located"
  echo "  -a|--name <resource-name>   Prefix for the Channel and Subscription resources"
  echo '```'
}

# Parse through resources to find matching Subscription and Channel
collectResources () {
  subprefix=($(oc -n ${ns} get appsub --no-headers -o custom-columns=NAME:.metadata.name | awk '/'${NAME}'-sub$/ {print "'${ns}'/"$1}' | sed "s/-sub\$//"))
  chanprefix=($(oc -n ${ns} get channels --no-headers -o custom-columns=NAME:.metadata.name | awk '/'${NAME}'-chan$/ {print "'${ns}'/"$1}' | sed "s/-chan\$//"))
  matchprefix=("${matchprefix[@]}" $(comm -1 -2 <(printf '%s\n' ${subprefix[@]}) <(printf '%s\n' ${chanprefix[@]})))
}

# Parse arguments
while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            -h|--help)
            help
            exit 0
            ;;
            -a|--name)
            shift
            NAME=${1}
            shift
            ;;
            -n|--namespace)
            shift
            NAMESPACE=${1}
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

# Determine namespace (or ask if user wants to search all namespaces)
SEARCH_ALL="(Search-all-available-namespaces)"

if [ -z "${NAMESPACE}" ]; then
  PS3='Enter the namespace of the resources to remove (Option 1 searches all namespaces): '
  options=($(echo ${SEARCH_ALL}))
  namespaces=($(oc get projects --no-headers -o custom-columns=NAME:.metadata.name))
  options=("${options[@]}" "${namespaces[@]}")
  echo 'NAMESPACES:'
  select opt in "${options[@]}"; do
      if [[ ! -z $opt ]]; then
          NAMESPACE=${opt}
          break
      else
          echo "Invalid selection"
      fi
  done
fi

echo "====="
echo "Using namespace: ${NAMESPACE}"
if [ -n "${NAME}" ]; then
  echo "Using prefix: ${NAME}"
fi
echo "====="

# Find matching Subscriptions and Channels with '-sub' and '-chan' suffix
# See if user wants to check all namespaces
if [[ "${NAMESPACE}" == "${SEARCH_ALL}" ]]; then
  # Determine whether user has clusterwide access
  if oc get appsub --all-namespaces &>/dev/null && oc get channels --all-namespaces &>/dev/null; then
    subprefix=$(oc get appsub --all-namespaces --no-headers -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name 2>/dev/null | awk '/'${NAME}'-sub$/ {print $1"/"$2}' | sed "s/-sub\$//")
    chanprefix=$(oc get channels --all-namespaces --no-headers -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name 2>/dev/null | awk '/'${NAME}'-chan$/  {print $1"/"$2}' | sed "s/-chan\$//")
    matchprefix=($(comm -1 -2 <(printf '%s\n' ${subprefix[@]}) <(printf '%s\n' ${chanprefix[@]})))
  else
    # No clusterwide access--iterate through each namespace individually
    for ns in "${namespaces[@]}"; do
      echo "Searching namespace: ${ns}..."
      collectResources
    done
  fi
else
  # Check specific namespace
  ns=${NAMESPACE}
  collectResources
fi

# Check for matches and have user choose match to remove
if [ "${#matchprefix[@]}" -ne 0 ]; then
  PS3='Enter the resources to remove from the list of namespace/prefix pairs: '
  echo 'NAMESPACE / RESOURCE-PREFIX:'
  select opt in "${matchprefix[@]}"; do
      if [[ ! -z $opt ]]; then
          RESOURCE=${opt}
          break
      else
          echo "Invalid selection"
      fi
  done
  echo "====="

  # Parse matches and double check that Subscription still points to Channel
  NAMESPACE=$(echo "${opt}" | awk -F/ '{print $1}')
  PREFIX=$(echo "${opt}" | awk -F/ '{print $2}')
  CHANREF=$(oc get appsub -n ${NAMESPACE} ${PREFIX}-sub -o jsonpath='{.spec.channel}')
  if [[ "${opt}-chan" != "${CHANREF}" ]]; then
    echo 'WARNING: The Subscription "'${PREFIX}'-sub" points to an unexpected Channel, "'${CHANREF}'".'
    echo "Please verify this resource pair and then you can use these commands if you would like to proceed with removing them:"
    echo "oc delete appsub -n ${NAMESPACE} ${PREFIX}-sub"
    echo "oc delete channels -n ${NAMESPACE} ${PREFIX}-chan"
    exit 1
  fi

  # Delete Subscription and Channel resources
  oc delete appsub -n ${NAMESPACE} ${PREFIX}-sub
  oc delete channels -n ${NAMESPACE} ${PREFIX}-chan
else
  echo "No deploy.sh Subscription and Channel resource pairs found."
fi
