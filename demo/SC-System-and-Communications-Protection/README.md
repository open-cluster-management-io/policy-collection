# System and Communications Protection

See the [NIST Special Publication 800-53 (Rev. 4)](https://nvd.nist.gov/800-53/Rev4/control/SC-1) for a description of the System and Communications Protection control family. View the following table list of with the stable policy that is supported by [Red Hat Advanced Cluster Management for Kubernetes](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.2/html/security/governance-and-risk#managing-certificate-policies):

Policy  | Description | Prerequisites
------- | ----------- | -------------
[policy-certificate](../SC-System-and-Communications-Protection/policy-certificate.yaml) | Ensure certificates are not expiring within a given minimum timeframe. |
[policy-etcdencryption](../SC-System-and-Communications-Protection/policy-etcdencryption.yaml) | Use an encryption policy to encrypt sensitive resources such as Secrets, ConfigMaps, Routes and OAuth access tokens in your cluster.  | See the [OpenShift Documentation](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.7/html/security_and_compliance/encrypting-etcd#enabling-etcd-encryption_encrypting-etcd) to learn how to enable ETCD encryption post install.
[policy-limitmemory](../SC-System-and-Communications-Protection/policy-limitmemory.yaml) | Ensures that a resource limits are in place as specified. |
[policy-psp](../SC-System-and-Communications-Protection/policy-psp.yaml) | Ensure a pod security policy exists as specified. |
[policy-scc](../SC-System-and-Communications-Protection/policy-scc.yaml) | Ensure a Security Context Constraint (SCC) exists as specified. |

You can contribute more policies that map to the System and Communications Protection control family. See [Contibuting policies](https://github.com/stolostron/policy-collection/blob/main/docs/CONTRIBUTING.md) for more details.
