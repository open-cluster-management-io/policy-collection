# OpenShift Plus PolicySet

**Note**: Currently this has only been tested successfully for a connected deployment on AWS. Some of the steps you see below will be specific to a connected AWS deployment.

## Prerequisites
 To install OpenShift Plus using this PolicySet, you must first have:
 - A supported Red Hat OpenShift Container Platform version
   - Follow the document [1.1 Requirements and recommendations](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.6/html/install/installing#requirements-and-recommendations)
 - An install of Open Cluster Management that includes the Policy framework
   - Follow the document [1.3 Installing while connected online](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.6/html/install/installing#installing-while-connected-online)
  

## Installation

The OpenShift Plus PolicySet contains two `PolicySets` that will be deployed.  The OpenShift Plus PolicySet installs everything onto the Open Cluster Management hub cluster.  The Advanced Cluster Security Secured Cluster Services and the Compliance Operator are deployed onto all OpenShift managed clusters.

Prior to applying the `PolicySet`, perform these steps:

1. Create the namespace `policies`: `oc create ns policies`
2. Prepare for Red Hat OpenShift Data Foundation by adding worker nodes for storage described [here](https://red-hat-storage.github.io/ocs-training/training/ocs4/ocs.html#_scale_ocp_cluster_and_add_new_worker_nodes). If you have any difficulties, see the [Add New Worker Nodes section](#1-add-new-worker-nodes). 
3. Create the namespace `openshift-storage`: `oc create ns openshift-storage`
4. Label the storage namespace: `oc label namespace openshift-storage "openshift.io/cluster-monitoring=true"`
5. To allow for subscriptions to be applied below you must apply and set to enforce the policy [policy-configure-subscription-admin-hub.yaml](https://github.com/open-cluster-management-io/policy-collection/blob/main/community/CM-Configuration-Management/policy-configure-subscription-admin-hub.yaml) in the policies namespace.
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
    ```bash
    oc apply -f managed-cluster.yaml 
    ```
  7. Install the Policy generator Kustomize plugin by following the [installation instructions](https://github.com/stolostron/policy-generator-plugin#installation). It is recommended to use Kustomize v4.5+.

Apply the policies using the kustomize command or subscribing to a fork of the repository and pointing to this directory.  See 
the details for using the Policy Generator for [more information](https://github.com/stolostron/policy-collection/tree/main/policygenerator).  The command to run is `kustomize build --enable-alpha-plugins  | oc apply -f -`

**Note**: For any components of OpenShift Plus that you do not wish to install, edit the `policyGenerator.yaml` file and remove or comment out the policies for those components.

## Troubleshooting

### Add New Worker Nodes 
  #### 1. Check your worker node to verify it has enough resources available to install ODF
  ```bash
  oc get nodes -l node-role.kubernetes.io/worker -l '!node-role.kubernetes.io/master'
  ```
 **Note:** make sure that the OpenShift cluster is large enough to hold the ACM installation.  An example of a working deployment topology is to use 3 master `m6a.2xlarge` nodes with 1 worker `m6a.2xlarge` node.
The added nodes for storage and the rest of OpenShift Platform Plus (OPP) are 6 `m6a.2xlarge` worker nodes all labeled for use by ODF storage and are also available for the other OPP components.

  #### 2. Acquire your availability-zone and region of your cluster
  To display the availability-zone:
  ```bash
  oc get machineset -n openshift-machine-api -o jsonpath='{.items[0].spec.template.spec.providerSpec.value.placement.availabilityZone}'
  ```

  To display the region used:

  ```bash
  oc get machineset -n openshift-machine-api -o jsonpath='{.items[0].spec.template.spec.providerSpec.value.placement.region}'  
  ```
  #### 3. Create new MachineSets

  Save your Cluster ID

  ```bash
  CLUSTERID=$(oc get machineset -n openshift-machine-api -o jsonpath='{.items[0].metadata.labels.machine\.openshift\.io/cluster-api-cluster}')
echo $CLUSTERID
  ```
Apply the yaml and create new MachineSets. 
***NOTE*** The below sample is for 1 zone and 6 replicas. [This](https://github.com/open-cluster-management-io/policy-collection/blob/main/community/CM-Configuration-Management/policy-aws-machine-sets.yaml) is another sample of 3 machinesets for 3 zones.

```
cat <<EOF | sed -e "s/CLUSTERID/${CLUSTERID}/g" | oc apply -f -
---
apiVersion: machine.openshift.io/v1beta1
kind: MachineSet
metadata:
  labels:
    machine.openshift.io/cluster-api-cluster: CLUSTERID
    machine.openshift.io/cluster-api-machine-role: workerocs
    machine.openshift.io/cluster-api-machine-type: workerocs
  name: CLUSTERID-workerocs-us-east-1f  # 🔴change to your AZ
  namespace: openshift-machine-api
spec:
  replicas: 6
  selector:
    matchLabels:
      machine.openshift.io/cluster-api-cluster: CLUSTERID
      machine.openshift.io/cluster-api-machineset: CLUSTERID-workerocs-us-east-1f # 🔴change to your AZ
  template:
    metadata:
      creationTimestamp: null
      labels:
        machine.openshift.io/cluster-api-cluster: CLUSTERID
        machine.openshift.io/cluster-api-machine-role: workerocs
        machine.openshift.io/cluster-api-machine-type: workerocs
        machine.openshift.io/cluster-api-machineset: CLUSTERID-workerocs-us-east-1f # 🔴change to your AZ
    spec:
      metadata:
        creationTimestamp: null
        labels:
          cluster.ocs.openshift.io/openshift-storage: ""
          node-role.kubernetes.io/worker: ""
      providerSpec:
        value:
          ami:
            id: ami-0fe05b1aa8dacfa90 # 🔴change to your AMI,  AMI IDs are region specific 
          apiVersion: awsproviderconfig.openshift.io/v1beta1
          blockDevices:
          - ebs:
              iops: 0
              volumeSize: 100
              volumeType: gp3 # 🔴change to your volumeType 
          credentialsSecret:
            name: aws-cloud-credentials
          deviceIndex: 0
          iamInstanceProfile:
            id: CLUSTERID-worker-profile
          instanceType: m6a.2xlarge # 🔴change to your instanceType 
          kind: AWSMachineProviderConfig
          metadata:
            creationTimestamp: null
          placement:
            availabilityZone: us-east-1f  # 🔴change to your AZ
            region: us-east-1   # 🔴change to your reion
          publicIp: null
          securityGroups:
          - filters:
            - name: tag:Name
              values:
              - CLUSTERID-worker-sg
          subnet:
            filters:
            - name: tag:Name
              values:
              - CLUSTERID-private-us-east-1f # 🔴change to your AZ
          tags:
          - name: kubernetes.io/cluster/CLUSTERID
            value: owned
          userDataSecret:
            name: worker-user-data
      versions:
        kubelet: ""
---
```
Wait a few minutes for all nodes to be up. 
Check with this command 

```bash
oc get nodes -l node-role.kubernetes.io/worker -l '!node-role.kubernetes.io/master'
```

***NOTE:*** For your volumeType or other values, you can get from machineset yaml.

### policy-odf-status NonCompliant 

Installing ODF takes over ***15 mins*** after the policies deployed. If the policy status still remains NonCompliant after 40 minutes, check to see if your worker nodes meet the requirements. 