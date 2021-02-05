# System and Information Integrity

See [NIST Special Publication 800-53 (Rev. 4)](https://nvd.nist.gov/800-53/Rev4/control/SI-1) for a description of the System and Information Integrity security control. View the following table list of the stable policies that are supported by [Red Hat Advanced Cluster Management for Kubernetes](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.1/html-single/security/index#kubernetes-configuration-policy-controller):

Policy  | Description | Prerequisites
------- | ----------- | -------------
[policy-imagemanifestvuln](../SI-System-and-Information-Integrity/policy-imagemanifestvuln.yaml) | Detect vulnerabilities in container images. Leverages the [Container Security Operator](https://github.com/quay/container-security-operator) and installs it on the managed cluster if it does not exist. |
[policy-psp](../SI-System-and-Information-Integrity/policy-psp.yaml) | Ensure a pod security policy exists as specified. |
[policy-scc](../SI-System-and-Information-Integrity/policy-scc.yaml) | Ensure a Security Context Constraint (SCC) exists as specified. |

You can contribute more policies that map to the System and Information Integrity control family. See [Contibuting policies](https://github.com/open-cluster-management/policy-collection/blob/master/docs/CONTRIBUTING.md) for more details.
