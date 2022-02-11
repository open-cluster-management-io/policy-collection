# OpenShift Plus PolicySet

## Installation

The OpenShift Plus PolicySet contains two `PolicySets` that will be deployed.  The OpenShift Plus PolicySet installs everything onto the Advanced Cluster Management hub cluster.  The Advanced Cluster Security Secured Cluster Services and the Compliance Operator are deployed onto all OpenShift managed clusters.

To apply this policy set make sure you have this repository and follow the policy generator instructions located (here)[../..] but making sure to point to this path instead of the default generator sample.

You must also perform the steps below to complete the installation of OpenShift Plus after the PolicySets have been
applied and the policies have all become compliant except the policies:

- policy-advanced-managed-cluster-security
- policy-acs-central-ca-bundle

**Perform these steps**
Run the scripts located in the [scripts](scripts) directory.

1. Create the certificate bundle for securely communicating with the Advanced Cluster Security Central server.  Run the command: `./scripts/acs-bundle-secret.sh -i acs-bundle.yaml | oc apply -n policies -f -`  **NOTE** The bundle is saved locally since it cannot be obtained again.  Since this file contains private keys for secure communications to Advanced Cluster Security, you must keep this file securely.

2. Setup the default administrative user for Quay. The administrative username is set to `quayadmin`.  
A password is generated and stored in the `quayadmin` secret in the `local-quay` namespace.
Run the script with this command: `./scripts/init-quay.sh`
