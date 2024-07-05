# Policy Collection

A collection of policy examples for Open Cluster Management.

> **Important**: The `PlacementRule` resource has been deprecated so policy users must begin moving to
the Placement API instead. See the
[Transitioning from `PlacementRule`(deprecated) to `Placement`](#transitioning-from-placementruledeprecated-to-placement)
that provides details below to learn how to begin using Placement. Policies will no longer include
placement details as part of contributions since placement resources can be shared to avoid
duplication and to allow users to choose different ways of including placement with gitops.

## Repository structure

This repository hosts policies for Open Cluster Management. You can find policies from the following
folders:

- [stable](stable) -- Policies in the `stable` folder can be applied with
  [Red Hat Advanced Cluster Management for Kubernetes](https://www.redhat.com/en/technologies/management/advanced-cluster-management).
- [community](community) -- Policies in the `community` folder are contributed from the open source
  community and can be applied with the product governance framework.

## Using GitOps to deploy policies to a cluster

Fork this repository and use the forked version as the target to run the sync. This avoids
unintended changes to your cluster. To get the latest policies from the `policy-collection`
repository, pull the latest changes from `policy-collection` and then create a pull request to merge
these changes into your forked repository. Any further changes to your repository will be applied to
your cluster automatically.

Make sure you have [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed and
that you are logged into your hub cluster in terminal.

Run `kubectl create ns policies` to create a "policies" ns on hub. If you prefer to call the
namespace something else, you can run `kubectl create ns <custom ns>` instead.

From within this directory in terminal, run `cd deploy` to access the deployment directory, then run
`bash ./deploy.sh -u <url> -p <path> -n <namespace>`. (Details on all of the parameters for this
command can be viewed in its [README](deploy/README.md).) This script assumes you have enabled
Application lifecycle management as an addon in your Open Cluster Management installation. See
[Application lifecycle management](https://open-cluster-management.io/getting-started/integration/app-lifecycle/)
for details on installing the Application addon. **Note**: If you are using ArgoCD for gitops, a
similar script [argoDeploy.sh](deploy/argoDeploy.sh) is provided that does not require the
Application Lifecycle addon.

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

After updating the `ClusterRoleBinding`, you need to delete the subscription and deploy the
subscription again.

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

## Distributing Policies to Managed Clusters

Distributing a `Policy` to a managed cluster requires four parts, all of which must be in the same
namespace:

- [Policy](https://open-cluster-management.io/concepts/policy/) is a grouping mechanism for Policy
  Templates and is the smallest deployable unit on the hub cluster. Embedded Policy Templates are
  distributed to applicable managed clusters and acted upon by the appropriate `policy controller`.

- [PlacementBinding](https://open-cluster-management.io/concepts/policy/#placementbinding) binds a
  Placement to a `Policy` or `PolicySet`.

- [Placement](https://open-cluster-management.io/concepts/placement/): Dynamically selects a set of
  `ManagedClusters` in one or multiple `ManagedClusterSet`s.

- [ManagedClusterSetBinding](https://open-cluster-management.io/concepts/managedclusterset/): Binds
  a `ManagedClusterSet` to a namespace, making this group of managed clusters available for
  selection by `Placement`.

When the `Policy` is bound to a `Placement` using a `PlacementBinding`, the `Policy` is distributed
to the managed clusters and the `Policy` status will report on each cluster returned by the bound
`Placement`.

### Using `Placement` with `Policies`

See the [Placement documentation](https://open-cluster-management.io/concepts/placement/) for
additional details on selecting managed clusters using `Placement`.

- **NOTE:** `PlacementRule` is **deprecated**. See the
  [migration section](#transitioning-from-placementruledeprecated-to-placement) for detail on
  migrating to `Placement`.

To use `Placement` to distribute `Policies`, bind the `Policy` to the `Placement` using a
`PlacementBinding`. All of the objects must be in the same namespace. View the following sample
`Placement` and `PlacementBinding` bound to a `Policy` named `policy-example` in the namespace
`example-ns`. The `Placement` selects managed clusters that have the label `environment: dev`:

```yaml
apiVersion: cluster.open-cluster-management.io/v1beta1
kind: Placement
metadata:
  name: placement-policy-example
  namespace: example-ns
spec:
  predicates:
    - requiredClusterSelector:
        labelSelector:
          matchExpressions:
            - { key: environment, operator: In, values: ["dev"] }
---
apiVersion: policy.open-cluster-management.io/v1
kind: PlacementBinding
metadata:
  name: binding-policy-example
  namespace: example-ns
placementRef:
  name: placement-policy-example
  kind: Placement
  apiGroup: cluster.open-cluster-management.io
subjects:
  - name: policy-example
    kind: Policy
    apiGroup: policy.open-cluster-management.io
```

### Transitioning from `PlacementRule`(deprecated) to `Placement`

`PlacementRule` had unrestricted access to selecting managed clusters. However, `Placement` requires
binding managed clusters to the `Policy` namespace in order for `Policies` to be distributed to
those managed clusters, bringing an additional layer of control to system administrators. View the
following steps on migrating from `PlacementRule` to `Placement`:

1. The desired managed clusters must be contained in a `ManagedClusterSet`. See the
   [ManagedClusterSet documentation](https://open-cluster-management.io/concepts/managedclusterset/)
   to read more, including the default sets that are available that include all managed clusters
   that would replicate `PlacementRule` behavior.

2. Create a `ManagedClusterSetBinding` to bind the `ManagedClusterSet` to the namespace where you
   are authoring policies. See the
   [ManagedClusterSet documentation](https://open-cluster-management.io/concepts/managedclusterset/).

3. Create the `Placement` manifest to replace the `PlacementRule`. To do this, take the selector
   `spec.clusterSelector` from the `PlacementRule` and put it into
   `spec.predicates.requiredClusterSelector.labelSelector`. For example, to select managed clusters
   with the label `environment: dev`:
   ```yaml
   apiVersion: cluster.open-cluster-management.io/v1beta1
   kind: Placement
   metadata:
     name: placement-policy-example
     namespace: example-ns // Ensure this namespace matches the ManagedClusterSetBinding
   spec:
     predicates:
     - requiredClusterSelector:
         labelSelector:
           matchExpressions: // From PlacementRule
           - {key: environment, operator: In, values: ["dev"]}
   ```

See the [Placement documentation](https://open-cluster-management.io/concepts/placement/) for
additional details on selecting managed clusters using `Placement`.

4. Identify any `PlacementBinding` resources that reference a `PlacementRule`. Update the
   `PlacementBinding` to reference the new `Placement`:

   - Change the `placementRef.kind` to `Placement`
   - Update the `placementRef.apiGroup` to `cluster.open-cluster-management.io` to reflect the
     `Placement`'s API version

   View the following sample `PlacementBinding` that references a `Placement`:

   ```yaml
   apiVersion: policy.open-cluster-management.io/v1
   kind: PlacementBinding
   metadata:
     name: binding-policy-example
   placementRef:
     apiGroup: cluster.open-cluster-management.io // Set to cluster.open-cluster-management.io
     kind: Placement                              // Set to Placement
     name: placement-policy-example
   subjects:
     - name: policy-example
       kind: Policy
       apiGroup: policy.open-cluster-management.io
   ```

## Community, discussion, contribution, and support

Check the [Contributing policies](CONTRIBUTING.md) document for guidelines on how to contribute to
the repository.

You can reach the maintainers of this project at:

- acm-contact@redhat.com

**Blogs**: Read our blogs that are in the [blogs folder](blogs/README.md).

**Resources**: View the following resources for more information on the components and mechanisms
are implemented in the product governance framework.

- [Product documentation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/)

- National Cyber security Center of Excellence (NCCoE) blog,
  [Policy Based Governance in Trusted Container Platform](https://www.nccoe.nist.gov/news/policy-based-governance-trusted-container-platform)

- IBM Developer blog,
  [Policy based governance for open hybrid cloud](http://ibm.biz/policy-based-governance-for-open-hybrid-cloud)
