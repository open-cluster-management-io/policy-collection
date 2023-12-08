# Advanced Cluster Security PolicySet for Secured Clusters

## Prerequisites

To install Advanced Cluster Security Secured Clusters using this PolicySet, 
you must have already installed your Advanced Cluster Security Central Server.
The policies make the following assumptions:

 - RHACS is installed on the RHACM hub and the ACS init bundle secrets are created
   in the `stackrox` namespace.
 - RHACS is installed on the RHACM hub and the ACS Central Server `Route` resource 
   exists in the `stackrox` namespace.
 - An install of Red Hat Advanced Cluster Management for Kubernetes version 2.8
   or newer is required.
  

## Installation

The ACS PolicySet for Secured Clusters contains two `PolicySets` that will be deployed.
The `PolicySets` install RHACS Secured Clusters onto all OpenShift clusters that are 
managed by RHACM except for the RHACM hub cluster.  If you want to install the RHACS
Secured Cluster component to the RHACM hub, that must be done separately.

Prior to applying the `PolicySet`, perform these steps:

1. Install the Policy generator Kustomize plugin by following the [installation instructions](https://github.com/open-cluster-management-io/policy-generator-plugin#installation). It is recommended to use Kustomize v4.5+.
2. Policies are installed to the `policies` namespace.
   Make sure the placement bindings match this namespace for the hub and other managed clusters.
   Example yaml to apply a ManagedClusterSetBinding for the policies namespace.

    ```yaml
    apiVersion: cluster.open-cluster-management.io/v1beta2
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

**Note**: If the RHACS `Route` or certificate bundles are not available on the RHACM 
hub cluster, you must edit the policy resources to make sure these resources are
available in the `policies` namespace. 

