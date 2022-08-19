# Kyverno-PolicySet based on Security

## Kyverno Security

https://kyverno.io/policies/?policytypes=Security



## List of Policies 


Policy                              | Description 
------------------------------------| ----------- 

disallow-scc-runasany               | Using RunAsAny in one of available SCC strategies can be used for privilege escalation and should not be allowed

disallow-host-ports                 | Provides a list of allowed ports in the host network namespace.  Access to host ports allows potential snooping of network traffic and should be forbidden / 

disallow-host-network               |  Host network Controls whether the pod may use the host's network namespace.
                                    |  Providing access to the host's network gives the pod access to the host's network devices.
                                    |  Pods with access to the host's network devices can be used to snoop on network activity of other pods on the same node.
disallow-host-ports                 |  Provides a list of allowed ports in the host network namespace.
                                    |  Access to host ports allows potential snooping of network traffic and should be forbidden / minimized.                                        

authorization                       | Prevent users from modifying or deleting default scc

disallow-host-namespaces            | Host namespaces (Process ID namespace, Inter-Process Communication namespace, and
                                    | network namespace) allow access to shared information and can be used to elevate
                                    | privileges. Pods should not be allowed access to host namespaces. This policy ensures
                                    | fields which make use of these host namespaces are unset or set to `false`.


disallow_latest_tag                 | The ':latest' tag is mutable and can lead to unexpected errors if the
                                    | image changes. A best practice is to use an immutable tag that maps to
                                    | a specific version of an application Pod. This policy validates that the image
                                    | specifies a tag and that it is not called `latest`

networking                          | Prevent users from deploying Routes with no https 
                       |
require-run-as-non-root-user        | Containers must be required to run as non-root users. This policy ensures
                                    | `runAsUser` is either unset or set to a number greater than zero.
            |
restrict_automount_sa_token         | Kubernetes automatically mounts ServiceAccount credentials in each Pod.
                                    | The ServiceAccount may be assigned roles allowing Pods to access API resources.
                                    | Blocking this ability is an extension of the least privilege best practice and should
                                    | be followed if Pods do not need to speak to the API server to function.
                                    | This policy ensures that mounting of these ServiceAccount tokens is blocked.

restrict-binding-clusteradmin       |  The cluster-admin ClusterRole allows any action to be performed on any resource in the cluster and its granting
                                    |  should This policy prevents binding to the cluster-admin ClusterRole in
                                    |  RoleBinding or ClusterRoleBinding resources.


restrict-escalation-verbs-roles     |  The verbs `impersonate`, `bind`, and `escalate` may all potentially lead to
                                    |  privilege escalation and should be tightly controlled. This policy prevents
                                    |  use of these verbs in Role or ClusterRole resources. In order to
                                    |  fully implement this control, it is recommended to pair this policy with another which
                                    |  also prevents use of the wildcard ('*') in the verbs list.


security-context-contraint          |   Disallow the use of the SecurityContextConstraint (SCC) anyuid which allows a pod to run with the UID as declared in the image instead of a random UID spe

restrict-service-account            |   Users may be able to specify any ServiceAccount which exists in their Namespace without
                                    |   restrictions. Confining Pods to a list of authorized ServiceAccounts can be useful to
                                    |   ensure applications in those Pods do not have more privileges than they should.
                                    |   This policy verifies that in the `staging` Namespace the ServiceAccount being
                                    |   specified is matched based on the image and name of the container. For example:
                                    |   'sa-name: ["registry/image-name"]' 

restrict_usergroup_fsgroup_id       |   All processes inside a Pod can be made to run with specific user and groupID
                                    |   by setting `runAsUser` and `runAsGroup` respectively. `fsGroup` can be specified
                                    |   to make sure any file created in the volume will have the specified groupID.
                                    |   This policy validates that these fields are set to the defined values. 












