# Policy Collection

A collection of policy examples for Open Cluster Management.

## Repository structure

This repository hosts policies for Open Cluster Management. You can deploy these policies using
[Open Cluster Management](https://open-cluster-management.io/) which includes a policy framework
that is available as an addon. Policies are organized in two ways:

1. By support expectations which are detailed below.
2. By [NIST Special Publication 800-53](https://nvd.nist.gov/800-53). 

The following folders are used to separate policies by the support expectations:

- [stable](stable) -- Policies in the `stable` folder are contributions that are being supported by
  the Open Cluster Management Policy SIG.
- [3rd-party](3rd-party) -- Policies in the `3rd-party` folder are contributions that are being
  supported, but not by the Open Cluster Management Policy SIG.  See the details of the policy to understand
  the support being provided.
- [community](community) -- Policies in the `community` folder are contributed from the open source
  community.  Contributions should start in the community.

In addition to policy contributions, there is the option to contribute groups of policies as a set.
This is known as `PolicySets` and these contributions are made in directories organized as
`PolicyGenerator` projects.  The folder containing these contributions is located here:
[`PolicySet` projects](https://github.com/open-cluster-management-io/policy-collection/tree/main/policygenerator/policy-sets).

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
command can be viewed in its [README](deploy/README.md).) This script assumes you have enabled 
Application lifecycle management as an addon in your Open Cluster Management installation. See
[Application lifecycle management](https://open-cluster-management.io/getting-started/integration/app-lifecycle/) 
for details on installing the Application addon.

The policies are applied to all managed clusters that are available, and have the `environment` set
to `dev`. Specifically, an available managed cluster has the `status` parameter set to `true` by the
system, for the `ManagedClusterConditionAvailable` condition. If policies need to be applied to
another set of clusters, update the `PlacementRule.spec.clusterSelector.matchExpressions` section in
the policies.

**Note**: As new clusters are added that fit the criteria previously mentioned, the policies are
applied automatically.

### Subscription Administrator

In new versions of Open Cluster Management you must be a subscription administrator in order to
deploy policies using a subscription. In these cases the subscription is still successfully created,
but policy resources are not distributed as expected. You can view the status of the subscription to
see the subscription errors. If the subscription administrator role is required, a message similar
to the following one appears for any resource that is not created:

```
        demo-stable-policies-chan-Policy-policy-cert-ocp4:
          lastUpdateTime: "2021-10-15T20:37:59Z"
          phase: Failed
          reason: 'not deployed by a subscription admin. the resource apiVersion: policy.open-cluster-management.io/v1 kind: Policy is not deployed'
```

To become a subscription administrator, you must add an entry for your user to the
`ClusterRoleBinding` named `open-cluster-management:subscription-admin`. A new entry may look like
the following:

```
subjects:
  - kind: User
    apiGroup: rbac.authorization.k8s.io
    name: my-username
```

After updating the `ClusterRoleBinding`, you need to delete the subscription and deploy the subscription again.

### Policy Generator

GitOps through Open Cluster Management is able to handle Kustomize files, so you can also use the
[Policy Generator](https://github.com/stolostron/policy-generator-plugin) Kustomize plugin to
generate policies from Kubernetes manifests in your repository. The Policy Generator handles
Kubernetes manifests as well as policy engine manifests from policy engines like
[Gatekeeper](https://open-policy-agent.github.io/gatekeeper/) and [Kyverno](https://kyverno.io/).

For additional information about the Policy Generator:

- [Policy Generator product documentation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.6/html/governance/governance#policy-generator)
- [Policy Generator source repository documentation](https://github.com/stolostron/policy-generator-plugin/blob/main/README.md)
- [Policy Generator reference YAML](https://github.com/stolostron/policy-generator-plugin/blob/main/docs/policygenerator-reference.yaml)
- [Policy Generator examples](policygenerator)

## Community, discussion, contribution, and support

Check the [Contributing policies](CONTRIBUTING.md) document for guidelines on how to contribute to
the repository.

**Blogs**: Read our blogs that are in the [blogs folder](blogs/README.md).

**Resources**: View the following resources for more information on the components and mechanisms
are implemented in the product governance framework.

- [Open Cluster Management Quick Start](https://https://open-cluster-management.io/getting-started/quick-start/)

