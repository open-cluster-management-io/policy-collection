# PolicySets -- Hub Best Practices

See the [Policy Generator](https://github.com/stolostron/policy-generator-plugin) 
Kustomize plugin for more information on using the policy generator.

## PolicySet details

The Advanced Cluster Management Hub Best Practices `PolicySet` applies best practices for how to govern your Advanced Cluster Management hub installation. 
This `PolicySet` needs to be deployed only to the Advanced Cluster Management hub cluster. 

**Note**: The `PolicySet` uses cluster `Placement` and not the `PlacementRule` placement mechanism, so the namespace of
the `Placement` must also be bound to a `ManagedClusterSet` using a `ManagedClusterSetBinding`. See the
[Placement](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.8/html/clusters/cluster_mce_overview#placement-overview)
and
[ManagedClusterSetBinding](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.8/html/clusters/cluster_mce_overview#creating-managedclustersetbinding)
documentation.
