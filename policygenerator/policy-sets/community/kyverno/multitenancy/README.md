# Kyverno Multitenancy Best Practices Sample

Repository showing best practices sample for two tenants
that can be separated using Kyverno policies.

## Kyverno multitenancy

https://kyverno.io/policies/?policytypes=Multi-Tenancy


This is a sample that creates policy sets to provide multitenancy
best practices.  There are two policy sets created by this solution:
1. kyverno-multitenancy-hub-policyset - a set of policies deployed to the hub for multitenancy.  This placement should remain configured for hub deployment only.
2. kyverno-multitenancy-policyset - a set of policies that should be deployed to the clusters running the application workloads from the 2 tenants. Update the placement for this policy set.  The default deploys placement is hub only.

## List of Policies 


Policy                 | Description 
-----------------------| ----------- 
add-labels-to-tenant   | Label namespaces uniquely based on Group RBAC bindings for the namespace.
disallowplacementrules | Deny usage of the PlacementRule API.
generateall            | Create resources specified in the policy in the namespace with RBAC bindings for a particular group.  You must edit the group for your use case.
genargocdpersmissions  | Generate a RoleBinding for ArgoCD when a namespace for the Group is created.
gen-managed-clusterset-binding | Create a ManagedClusterSetBinding when a namespace for the Group is created.
gen-placement-rules    | Create a Placement for the tenant when the namespace for the Group is created.
other                  | Set the time to live for a job that doesn't have the TTL defined. The default is 15 minutes.
preventupdatesappproject | This policy prevents updates to the project field after an Application is created.
restrictions           | Restrict management resources for a tenant to the team associated with that tenant.
sharedresources        | Create any shared resources between the tenants.
validatens             | Require special naming for the namespaces for a tenant.
validateplacement      | Restrict Placement resources for a tenant to be bound to the ClusterSet only for that tenant.

