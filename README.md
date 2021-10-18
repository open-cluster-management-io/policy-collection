# Policy Collection

A collection of policy examples for Open Cluster Management.

## Repository structure

This repository hosts policies for Open Cluster Management. You can find policies from the following
folders:

- [stable](stable) -- Policies in the `stable` folder can be applied with
  [Red Hat Advanced Cluster Management for Kubernetes](https://www.redhat.com/en/technologies/management/advanced-cluster-management).
- [community](community) -- Policies in the `community` folder are contributed from the open source
  community and can be applied with the product governance framework.

## Using GitOps to deploy policies to a cluster

Fork this repository and use the forked version as the target to run the sync against. This is to
avoid unintended changes to be applied to your cluster automatically. To get latest policies from
the `policy-collection` repository, you can pull the latest changes from `policy-collection` to your
own repository through a pull request. Any further changes to your repository are automatically be
applied to your cluster.

Make sure you have [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed and
that you are logged into your hub cluster in terminal.

Run `kubectl create ns policies` to create a "policies" ns on hub. If you prefer to call the
namespace something else, you can run `kubectl create ns <custom ns>` instead.

From within this directory in terminal, run `cd deploy` to access the deployment directory, then run
`bash ./deploy.sh -u <url> -p <path> -n <namespace>`. (Details on all of the parameters for this
command can be viewed in its [README](deploy/README.md).)

The policies are applied to all managed clusters that are available, and have the `environment` set
to `dev`. Specifically, an available managed cluster has the `status` parameter set to `true` by the
system, for the `ManagedClusterConditionAvailable` condition. If policies need to be applied to
another set of clusters, update the `PlacementRule.spec.clusterSelector.matchExpressions` section in
the policies.

**Note**: As new clusters are added that fit the criteria previously mentioned, the policies are
applied automatically.

### Subscription Administrator

In new versions of Open Cluster Management you must be a subscription administrator in order to deploy
policies using a subscription. In these cases the subscription is still successfully created, but policy
resources are not distributed as expected. You can view the status of the subscription to see the subscription
errors. If the subscription administrator role is required, a message similar to the following one appears for any resource that is not created:

```
        demo-stable-policies-chan-Policy-policy-cert-ocp4:
          lastUpdateTime: "2021-10-15T20:37:59Z"
          phase: Failed
          reason: 'not deployed by a subscription admin. the resource apiVersion: policy.open-cluster-management.io/v1 kind: Policy is not deployed'
```

To become a subscription administrator, you must add an entry for your user to the `ClusterRoleBinding` 
named `open-cluster-management:subscription-admin`.
A new entry may look like the following:

```
subjects:
  - kind: User
    apiGroup: rbac.authorization.k8s.io
    name: my-username
```

After updating the `ClusterRoleBinding`, you can delete the subscription and run the deploy script again or 
simply wait for the subscription controller to synchronize the resources.

### Policy Generator

GitOps through Open Cluster Management is able to handle Kustomize manifests, so you can also use
the [Policy Generator](https://github.com/open-cluster-management/policy-generator-plugin) Kustomize
plugin to generate policies from Kustomize manifests in your repository. See the
[Policy Generator documentation](https://github.com/open-cluster-management/policy-generator-plugin/blob/main/README.md)
for additional information.

## Community, discussion, contribution, and support

Check the [Contributing policies](CONTRIBUTING.md) document for guidelines on how to contribute to
the repository.

You can reach the maintainers of this project at:

- acm-contact@redhat.com

**Blogs**: Read our blogs that are in the [blogs folder](blogs/README.md).

**Resources**: View the following resources for more information on the components and mechanisms
are implemented in the product governance framework.

- [Product documentation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.2/)

- National Cyber security Center of Excellence (NCCoE) blog,
  [Policy Based Governance in Trusted Container Platform](https://www.nccoe.nist.gov/news/policy-based-governance-trusted-container-platform)

- IBM Developer blog,
  [Policy based governance for open hybrid cloud](http://ibm.biz/policy-based-governance-for-open-hybrid-cloud)
