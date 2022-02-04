# OpenShift Plus PolicySet

## Installation

The OpenShift Plus PolicySet contains two `PolicySets` that will be deployed.  The OpenShift Plus PolicySet installs everything onto the Advanced Cluster Management hub cluster.  The Advanced Cluster Security Secured Cluster Services and the Compliance Operator are deployed onto all OpenShift managed clusters.

You must perform the steps below to complete the installation of OpenShift Plus after the PolicySets have been
applied and the policies have all become compliant except the policies:

- policy-advanced-managed-cluster-security
- policy-acs-central-ca-bundle

**Perform these steps**
Run the scripts located in the [scripts](scripts) directory.

1. Create the certificate bundle for securely communicating with the Advanced Cluster Security Central server.  Run the command: `./scripts/acs-bundle-secret.sh -i acs-bundle.yaml | oc apply -n policies -f -`  **NOTE** The bundle is saved locally since it cannot be obtained again.  Since this file contains private keys for secure communications to Advanced Cluster Security, you must keep this file securely.

2. Setup the default administrative user for Quay. The administrative username is set to `quayadmin`.  See the
script for the default password which should be changed.  The script does not require any parameters so simply
run: `./scripts/init-quay.sh`
