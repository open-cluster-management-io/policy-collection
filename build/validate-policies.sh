#!/bin/bash

KUBECONFORM=kubeconform
KC_VERSION=v0.5.0
KUSTOMIZE_VERSION=v4.5.7
GENERATOR_PATH=policy.open-cluster-management.io/v1/policygenerator

# Validate the policy resource file under the directory provided
validatePolicies() {
	find $1 -name "*.yaml" | xargs kubeconform -schema-location 'schemas/{{ .ResourceKind }}_{{ .ResourceAPIVersion }}.json' -summary
}

# Validate the generator based policyset projects under the directory provided
validatePolicySets() {
	KPATH=`pwd`
	SETPATH=policygenerator/policy-sets/$1
	cd $SETPATH
	for project in `find . -name "kustomization.y*ml" | sed 's,/kustomization.*,,g'`; do
	        cd $project
		echo "Generating PolicySet $project"
	        OUTPUT=`kustomize build --enable-alpha-plugins`
	        cd $KPATH/$SETPATH
	done
	cd $KPATH
}

# Setup 

# Go Setup
export GOBIN=${PWD}/bin
export PATH=${GOBIN}:${PATH}
mkdir -p ${GOBIN}

# Configure org for manual validation runs
if [ -z "${GITHUB_REPOSITORY_OWNER}" ]; then
	echo "Set GITHUB_REPOSITORY_OWNER=[github org], using open-cluster-management-io by default"
	GITHUB_REPOSITORY_OWNER=open-cluster-management-io
fi

set -euo pipefail  # exit on errors and unset vars, and stop on the first error in a "pipeline"

# Install kubeconform
echo "Installing kubeconform"
go install github.com/yannh/kubeconform/cmd/kubeconform@$KC_VERSION

# Get the CRDs needed for policy validation
if [ ! -d schemas ]; then
	echo "Getting Schema conversion tool"
	mkdir schemas
	cd schemas
	curl -s -o crd-schema.py https://raw.githubusercontent.com/yannh/$KUBECONFORM/$KC_VERSION/scripts/openapi2jsonschema.py
	chmod a+x crd-schema.py

	echo "Converting CRDs to Schemas"
	./crd-schema.py https://raw.githubusercontent.com/${GITHUB_REPOSITORY_OWNER}/multicloud-operators-subscription/main/deploy/common/apps.open-cluster-management.io_placementrules_crd.yaml
	./crd-schema.py https://raw.githubusercontent.com/${GITHUB_REPOSITORY_OWNER}/governance-policy-propagator/main/deploy/crds/policy.open-cluster-management.io_placementbindings.yaml
	./crd-schema.py https://raw.githubusercontent.com/${GITHUB_REPOSITORY_OWNER}/governance-policy-propagator/main/deploy/crds/policy.open-cluster-management.io_policies.yaml
	./crd-schema.py https://raw.githubusercontent.com/${GITHUB_REPOSITORY_OWNER}/governance-policy-propagator/main/deploy/crds/policy.open-cluster-management.io_policysets.yaml
	./crd-schema.py https://raw.githubusercontent.com/${GITHUB_REPOSITORY_OWNER}/governance-policy-propagator/main/deploy/crds/policy.open-cluster-management.io_policyautomations.yaml
	./crd-schema.py https://raw.githubusercontent.com/${GITHUB_REPOSITORY_OWNER}/placement/main/deploy/hub/0000_02_clusters.open-cluster-management.io_placements.crd.yaml

	cd ..
fi

# Validate the policies

echo "Checking stable policies"
validatePolicies stable

echo "Checking community policies"
validatePolicies community

# Switching to check generator projects now

# Install kustomize
echo "Installing kustomize"
GO111MODULE=on go install sigs.k8s.io/kustomize/kustomize/v4@$KUSTOMIZE_VERSION

# Install the Policy Generator kustomize plugin
export KUSTOMIZE_PLUGIN_HOME=${GOBIN}
echo "Downloading the generator"
PLATFORM=`uname | tr '[:upper:]' '[:lower:]'`
curl -Ls -o generator https://github.com/${GITHUB_REPOSITORY_OWNER}/policy-generator-plugin/releases/latest/download/${PLATFORM}-amd64-PolicyGenerator
chmod a+x generator
mkdir -p ${KUSTOMIZE_PLUGIN_HOME}/${GENERATOR_PATH}
mv generator ${KUSTOMIZE_PLUGIN_HOME}/${GENERATOR_PATH}/PolicyGenerator

# Validate the generator projects

echo "Checking stable policy sets"
validatePolicySets stable

echo "Checking community policy sets"
validatePolicySets community

# Cleanup
rm -rf schemas

# Done
