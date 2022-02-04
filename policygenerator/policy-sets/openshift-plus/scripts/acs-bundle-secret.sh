#!/bin/bash

set -e
set -o pipefail


CMDNAME=`basename $0`

# Display help information
help () {
  echo "Deploy ACS certificate bundles to all OpenShift managed clusters."
  echo ""
  echo "Prerequisites:"
  echo " - kubectl CLI must be pointing to the cluster where ACS Central server is installed"
  echo " - roxctl and yq commands must be installed"
  echo " - ROX_API_TOKEN must be defined as an environment variable"
  echo " - The init bundles and SecuredClusters must be in the stackrox namespace"
  echo ""
  echo "Usage:"
  echo "  $CMDNAME [-i bundle-file] [-c central-namespace]"
  echo ""
  echo "  -h|--help                   Display this menu"
  echo "  -i|--init <bundle-file>     The central init-bundles file name to save certs to."
  echo "                                (Default name is cluster-init-bundle.yaml"
  echo "  -c|--central <namespace>    The central server namespace"
  echo "                                (Default namespace is stackrox"
  echo ""
} >&2

NAMESPACE=stackrox
CENTRALNS=stackrox

# Parse arguments
while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            -h|--help)
            help
            exit 0
            ;;
            -i|--init)
            shift
            BUNDLE_FILE=${1}
            shift
            ;;
            -c|--central)
            shift
            CENTRALNS=${1}
            shift
            ;;
            *)    # default
            echo "Invalid input: ${1}" >&2
            exit 1
            shift
            ;;
        esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

ACS_HOST="$(oc get route -n $CENTRALNS central -o custom-columns=HOST:.spec.host --no-headers):443"
if [[ -z "$ACS_HOST" ]]; then
	echo "The ACS route has not been created yet. Deploy Central first." >&2
	exit 1
fi

if [[ -z $BUNDLE_FILE ]]; then
	echo "The '-i|--init <init-bundle>' parameter is required." >&2
	exit 1
fi

if [[ -z "$NAMESPACE" ]]; then
  NAMESPACE=stackrox
fi


if ! [ -x "$(command -v kubectl)" ]; then
    echo 'Error: kubectl is not installed.' >&2
    exit 1
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    BASE='base64 -w 0'
elif [[ "$OSTYPE" == "darwin"* ]]; then
    BASE='base64'
fi

if [ -f "${BUNDLE_FILE}" ]; then
	echo "# Using existing bundle file." >&2
else
	echo "# Creating new bundle file." >&2
	PASSWORD=$(oc get secret -n $CENTRALNS central-htpasswd -o jsonpath="{.data.password}" | $BASE -d)
	DATA={\"name\":\"local-cluster\"}
	curl -k -o "${BUNDLE_FILE}" -X POST -u "admin:$PASSWORD" -H "Content-Type: application/json" --data $DATA https://$ACS_HOST/v1/cluster-init/init-bundles

	if [ $? -ne 0 ]; then
		echo "Failed to create the init-bundles required for Secured Cluster services" >&2
		exit 1
	fi
fi

parsebundle() {
	value="$1"
	cat ${BUNDLE_FILE} | jq .helmValuesBundle | sed 's/\"//g' | $BASE -d | yq eval $value - | $BASE
}

cat <<EOF
---
apiVersion: v1
data:
  admission-control-cert.pem: `parsebundle '.admissionControl.serviceTLS.cert'`
  admission-control-key.pem: `parsebundle '.admissionControl.serviceTLS.key'`
  ca.pem: `parsebundle '.ca.cert'`
kind: Secret
metadata:
  annotations:
    apps.open-cluster-management.io/deployables: "true"
  name: admission-control-tls
type: Opaque
---
apiVersion: v1
data:
  collector-cert.pem: `parsebundle '.collector.serviceTLS.cert'`
  collector-key.pem: `parsebundle '.collector.serviceTLS.key'`
  ca.pem: `parsebundle '.ca.cert'`
kind: Secret
metadata:
  annotations:
    apps.open-cluster-management.io/deployables: "true"
  name: collector-tls
type: Opaque
---
apiVersion: v1
data:
  sensor-cert.pem: `parsebundle '.sensor.serviceTLS.cert'`
  sensor-key.pem: `parsebundle '.sensor.serviceTLS.key'`
  ca.pem: `parsebundle '.ca.cert'`
  acs-host: `echo ${ACS_HOST} | ${BASE}`
kind: Secret
metadata:
  annotations:
    apps.open-cluster-management.io/deployables: "true"
  name: sensor-tls
type: Opaque
---
EOF
