# OpenShift Plus PolicySet

**Note**: Currently this has only been tested successfully for a connected deployment on AWS. Some of the steps you see below will be specific to a connected AWS deployment.

## Prerequisites
 To install OpenShift Plus using this PolicySet, you must first have:
 - A supported Red Hat OpenShift Container Platform version
   - Follow the document [1.4 Prepare your hub cluster for installation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.0/html/install/installing#preparing-your-hub-cluster-for-installation)
 - A supported Red Hat Advanced Cluster Management for Kubernetes version
   - Follow the document [1.5 Installing while connected online](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.0/html/install/installing#installing-while-connected-online)
  

## Installation

The OpenShift Plus PolicySet contains two `PolicySets` that will be deployed.  The OpenShift Plus PolicySet installs everything onto the Advanced Cluster Management hub cluster.  The Advanced Cluster Security Secured Cluster Services and the Compliance Operator are deployed onto all OpenShift managed clusters.

Prior to applying the `PolicySet`, perform these steps:

1. Create the namespace `policies`: `oc create ns policies`
2. Prepare for Red Hat OpenShift Data Foundation by adding worker nodes for storage described [here](https://red-hat-storage.github.io/ocs-training/training/ocs4/ocs.html#_scale_ocp_cluster_and_add_new_worker_nodes)
3. Create the namespace `openshift-storage`: `oc create ns openshift-storage`
4. Label the storage namespace: `oc label namespace openshift-storage "openshift.io/cluster-monitoring=true"`
5. To allow for subscriptions to be applied below you must apply and set to enforce the policy [policy-configure-subscription-admin-hub.yaml](https://github.com/stolostron/policy-collection/blob/main/community/CM-Configuration-Management/policy-configure-subscription-admin-hub.yaml) in the policies namespace.
6. Policies are installed to the `policies` namespace.  Make sure the placement bindings match this namespace for the hub and other managed clusters.
   Example yaml to apply a ManagedClusterSetBinding for the policies namespace.
    ```apiVersion: cluster.open-cluster-management.io/v1beta1
    kind: ManagedClusterSetBinding
    metadata:
        name: default
        namespace: policies
    spec:
        clusterSet: default
    ```

Apply the policies using the kustomize command or subscribing to a fork of the repository and pointing to this directory.  See 
the details for using the Policy Generator for more information.  The command to run is `kustomize build --enable-alpha-plugins  | oc apply -f -`

**Note**: For any components of OpenShift Plus that you do not wish to install, edit the `policyGenerator.yaml` file and remove or comment out the policies for those components.
