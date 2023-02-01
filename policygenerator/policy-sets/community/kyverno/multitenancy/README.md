# governance-best-practises-for-apps

repository showing best practices for apps

Based on the following links:

* https://cloud.redhat.com/blog/9-best-practices-for-deploying-highly-available-applications-to-openshift
* https://cloud.redhat.com/blog/14-best-practices-for-developing-applications-on-openshift

## Kyverno best prastices

https://kyverno.io/policies/?policytypes=Best%2520Practices


We look to create a `PolicySet` based on Open Cluster Management Policies and Kyverno Integration

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

