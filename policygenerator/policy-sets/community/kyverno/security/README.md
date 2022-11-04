# Kyverno-PolicySet based on Security

## Kyverno Security

https://kyverno.io/policies/?policytypes=Security


## List of Policies 

Policy                              | Description 
------------------------------------| ----------- 
authorization-disallow-scc-runasany | Using RunAsAny in one of available SCC strategies can be used for privilege escalation and should not be allowed
authorization-protect-default-scc   | Prevent users from modifying or deleting default scc
authorization-host-namespaces       | Host namespaces (Process ID namespace, Inter-Process Communication namespace, and network namespace) allow access to shared information and can be used to elevate privileges. Pods should not be allowed access to host namespaces. This policy ensures fields which make use of these host namespaces are unset or set to `false`.
networking-block-nodeport-services  | Do not allow services with the type of `NodePort`
restrict-wildcard-verbs             | Do not allow Roles or ClusterRoles to specify wildcards as a verb.
restrict-wildcard-resources         | Do not allow Roles or ClusterRoles to specify wildcards as a resource.
restrict-service-port-range         | Require services to use a port range that will not conflict with other applications.
restrict-service-account            | Users may be able to specify any ServiceAccount which exists in their Namespace without   restrictions. Confining Pods to a list of authorized ServiceAccounts can be useful to   ensure applications in those Pods do not have more privileges than they should.   This policy verifies that in the `staging` Namespace the ServiceAccount being   specified is matched based on the image and name of the container. For example:   'sa-name: ["registry/image-name"]' 
restrict-secret-role-verbs          | Prevent roles from being granted access to secret contents which may contain sensitive information.
restrict-node-selection             | Do not allow pods to target a specific node.
restrict-loadbalancer               | Do not allow services to be of type LoadBalancer.
restrict-ingress-wildcard           | Do not allow a wildcard character for Ingress hosts.
restrict-clusterrole-nodesproxy     | Do not allow a ClusterRole with the nodes/proxy resource.
restrict-binding-clusteradmin       | Do not allow RoleBindings or ClusterRoleBindings to bind to the `cluster-admin` ClusterRole.
restrict-automount-sa-token         | Block automounting the service account token since most pods do not need to communicate with the API Server.
restrict-annotations                | Restrict a list of annotations that should not be used.  Some annotations are reserved and should not be used.

