# System and Communications Protection

See the [Security and Privacy Controls for Information Systems and Organizations, Revision 5](https://csrc.nist.gov/projects/cprt/catalog#/cprt/framework/version/SP_800_53_5_1_0/home?element=SC) for details of the System and Communications Protection control family.

Policy  | Description | Prerequisites
------- | ----------- | -------------
[policy-certificate](../SC-System-and-Communications-Protection/policy-certificate.yaml) | Ensure certificates are not expiring within a given minimum timeframe. |
[policy-etcdencryption](../SC-System-and-Communications-Protection/policy-etcdencryption.yaml) | Use an encryption policy to encrypt sensitive resources such as Secrets, ConfigMaps, Routes and OAuth access tokens in your cluster.  | See the [OpenShift Documentation](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.7/html/security_and_compliance/encrypting-etcd#enabling-etcd-encryption_encrypting-etcd) to learn how to enable ETCD encryption post install.
[policy-limitmemory](../SC-System-and-Communications-Protection/policy-limitmemory.yaml) | Ensures that a resource limits are in place as specified. |
[policy-psp](../SC-System-and-Communications-Protection/policy-psp.yaml) | Ensure a pod security policy exists as specified. |
[policy-scc](../SC-System-and-Communications-Protection/policy-scc.yaml) | Ensure a Security Context Constraint (SCC) exists as specified. |

You can contribute more policies that map to the System and Communications Protection control family. See [Contibuting policies](https://github.com/open-cluster-management-io/policy-collection/blob/main/docs/CONTRIBUTING.md) for more details.
