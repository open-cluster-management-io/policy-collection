#!/bin/bash

KUBECONFORM=kubeconform
KC_VERSION=v0.7.0
KUSTOMIZE_VERSION=v5.8.1
GENERATOR_PATH=policy.open-cluster-management.io/v1/policygenerator

# Validate the policy resource file under the directory provided
validatePolicies() {
	find "${1}" -name "*.yaml" -exec kubeconform -schema-location 'schemas/{{ .ResourceKind }}_{{ .ResourceAPIVersion }}.json' -summary {} +
}

# Validate the generator based policyset projects under the directory provided
validatePolicySets() {
	find "./policygenerator/policy-sets/${1}" -name "kustomization.y*ml" -exec dirname {} \; | while read -r set; do
		echo "Generating PolicySet ${set}"
		kustomize build --enable-alpha-plugins "${set}" 1>/dev/null
	done
}

# Setup

# Go Setup
export GOBIN=${PWD}/bin
export PATH=${GOBIN}:${PATH}
mkdir -p "${GOBIN}"

# Configure org for manual validation runs
if [ -z "${GITHUB_REPOSITORY_OWNER}" ]; then
	echo "Set GITHUB_REPOSITORY_OWNER=[github org], using open-cluster-management-io by default"
	GITHUB_REPOSITORY_OWNER=open-cluster-management-io
fi

set -euo pipefail # exit on errors and unset vars, and stop on the first error in a "pipeline"

# Install kubeconform
echo "::group::Installing kubeconform"
go install github.com/yannh/kubeconform/cmd/kubeconform@${KC_VERSION}
echo "::endgroup::"

# Get the CRDs needed for policy validation
if [ ! -d schemas ]; then
	echo "Getting Schema conversion tool"
	mkdir schemas
	cd schemas
	curl -s -o crd-schema.py https://raw.githubusercontent.com/yannh/${KUBECONFORM}/${KC_VERSION}/scripts/openapi2jsonschema.py
	chmod a+x crd-schema.py

	echo "Converting CRDs to Schemas"
	./crd-schema.py "https://raw.githubusercontent.com/${GITHUB_REPOSITORY_OWNER}/multicloud-operators-subscription/main/deploy/common/apps.open-cluster-management.io_placementrules_crd.yaml"
	./crd-schema.py "https://raw.githubusercontent.com/${GITHUB_REPOSITORY_OWNER}/governance-policy-propagator/main/deploy/crds/policy.open-cluster-management.io_placementbindings.yaml"
	./crd-schema.py "https://raw.githubusercontent.com/${GITHUB_REPOSITORY_OWNER}/governance-policy-propagator/main/deploy/crds/policy.open-cluster-management.io_policies.yaml"
	./crd-schema.py "https://raw.githubusercontent.com/${GITHUB_REPOSITORY_OWNER}/governance-policy-propagator/main/deploy/crds/policy.open-cluster-management.io_policysets.yaml"
	./crd-schema.py "https://raw.githubusercontent.com/${GITHUB_REPOSITORY_OWNER}/governance-policy-propagator/main/deploy/crds/policy.open-cluster-management.io_policyautomations.yaml"
	./crd-schema.py "https://raw.githubusercontent.com/${GITHUB_REPOSITORY_OWNER}/placement/main/deploy/hub/0000_02_clusters.open-cluster-management.io_placements.crd.yaml"

	cd ..
fi

# Validate the policies

echo "Checking stable policies"
validatePolicies stable

echo "Checking community policies"
validatePolicies community

# Switching to check generator projects now

# Install kustomize
echo "::group::Installing kustomize"
GO111MODULE=on go install sigs.k8s.io/kustomize/kustomize/v5@${KUSTOMIZE_VERSION}
echo "::endgroup::"

# Install the Policy Generator kustomize plugin
export KUSTOMIZE_PLUGIN_HOME=${GOBIN}
echo "::group::Downloading the generator"
GOBIN=${KUSTOMIZE_PLUGIN_HOME}/${GENERATOR_PATH} go install open-cluster-management.io/policy-generator-plugin/cmd/PolicyGenerator@latest
echo "::endgroup::"

# Validate the generator projects

echo "Checking stable policy sets"
validatePolicySets stable

echo "Checking community policy sets"
validatePolicySets community

# Cleanup
rm -rf schemas

# Done
