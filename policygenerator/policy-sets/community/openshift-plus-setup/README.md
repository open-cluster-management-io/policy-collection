# Setup OpenShift Plus PolicySet

## Prerequisites
 To install the Setup for OpenShift Plus using this PolicySet, you must first have:
 - A supported Red Hat OpenShift Container Platform version
 - An install of Open Cluster Management that includes the Policy framework
   - Follow the document [1.1 Requirements and recommendations](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.7/html/install/installing#requirements-and-recommendations)


## Installation

The Setup for OpenShift Plus PolicySet deploys only to the hub cluster.  

Prior to applying the `PolicySet`, perform these steps:

1. To allow for subscriptions to be applied below you must apply and set to enforce the policy [policy-configure-subscription-admin-hub.yaml](https://github.com/open-cluster-management-io/policy-collection/blob/main/community/CM-Configuration-Management/policy-configure-subscription-admin-hub.yaml). Alternatively apply the following yaml to the hub cluster:
  ```bash
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRoleBinding
  metadata:
    name: open-cluster-management:subscription-admin
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: open-cluster-management:subscription-admin
  subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: kube:admin
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: system:admin
  ```
2. Install the Policy generator Kustomize plugin by following the [installation instructions](https://github.com/stolostron/policy-generator-plugin#installation). It is recommended to use Kustomize v4.5+.
3. Edit the RHCOS AMI IDs that are provided in the [machine set](./aws-machine-sets.yaml) definitions so the AMI ID for each machineset matches an appropriate ID for your AWS region.  See [RHCOS AMIs for the AWS infrastructure](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.12/html/installing/installing-on-aws#installation-aws-user-infra-rhcos-ami_installing-aws-user-infra) for more details.  Note that you should use the ID that corresponds to your version of OpenShift.

Apply the policies using the kustomize command or subscribing to a fork of the repository and pointing to this directory.  See the details for using the Policy Generator for [more information](https://github.com/stolostron/policy-collection/tree/main/policygenerator).  The command to run is `kustomize build --enable-alpha-plugins  | oc apply -f -`

After applying the PolicySet, wait a few minutes for all nodes to be up. Check that the nodes are available with this command:

```bash
oc get nodes -l node-role.kubernetes.io/worker -l '!node-role.kubernetes.io/master'
```

## Install OpenShift Platform Plus

Now that the setup for OpenShift Plus is completed, install the stable policy for [OpenShift Plus](../../stable/openshift-plus).
