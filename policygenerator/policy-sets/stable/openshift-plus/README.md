# OpenShift Plus PolicySet

## Prerequisites
 To install OpenShift Plus using this PolicySet, you must first have:
 - Currently this PolicySet is tested for AWS only. Extending the PolicySet to other environments should be straightforward.
 - A supported version of Red Hat OpenShift Container Platform 
 - An install of Red Hat Advanced Cluster Management for Kubernetes version 2.7 or newer.
   - Follow the document [Requirements and Recommendations] for Red Hat Advanced Cluster Management for Kubernetes(https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.7/html/install/installing#requirements-and-recommendations)
  

## Installation

The OpenShift Plus PolicySet contains two `PolicySets` that will be deployed.  The OpenShift Plus PolicySet installs everything onto the Open Cluster Management hub cluster.  The Advanced Cluster Security Secured Cluster Services and the Compliance Operator are deployed onto all OpenShift managed clusters.

Prior to applying the `PolicySet`, perform these steps:

1. To allow for subscriptions to be applied below you must apply and set to enforce the policy [policy-configure-subscription-admin-hub.yaml](https://github.com/open-cluster-management-io/policy-collection/blob/main/community/CM-Configuration-Management/policy-configure-subscription-admin-hub.yaml).
2. Install the Policy generator Kustomize plugin by following the [installation instructions](https://github.com/stolostron/policy-generator-plugin#installation). It is recommended to use Kustomize v4.5+.
3. Policies are installed to the `policies` namespace.  Make sure the placement bindings match this namespace for the hub and other managed clusters.
   Example yaml to apply a ManagedClusterSetBinding for the policies namespace.
    ```apiVersion: cluster.open-cluster-management.io/v1beta2
    kind: ManagedClusterSetBinding
    metadata:
        name: default
        namespace: policies
    spec:
        clusterSet: default
    ```
    ```bash
    oc apply -f managed-cluster.yaml 
    ```

Apply the policies using the kustomize command or subscribing to a fork of the repository and pointing to this directory.  See the details for using the Policy Generator for [more information](https://github.com/stolostron/policy-collection/tree/main/policygenerator).  The command to run is `kustomize build --enable-alpha-plugins  | oc apply -f -`

**Note**: For any components of OpenShift Plus that you do not wish to install, edit the `policyGenerator.yaml` file and remove or comment out the policies for those components.

## Sample Setup for OpenShift Plus

A community PolicySet has been created to configure a cluster for the needed prerequisites for OpenShift Plus.  Review this PolicySet to make sure you have prepared the hub cluster properly or apply this PolicySet to use the recommended configuration settings for the hub cluster.

  - PolicySet to [setup prerequisites for OpenShift Plus]()
