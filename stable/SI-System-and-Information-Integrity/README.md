# System and Information Integrity

See [Security and Privacy Controls for Information Systems and Organizations, Revision 5](https://csrc.nist.gov/projects/cprt/catalog#/cprt/framework/version/SP_800_53_5_1_0/home?element=SI) for details of the System and Information Integrity security controls.

Policy  | Description | Prerequisites
------- | ----------- | -------------
[policy-imagemanifestvuln](../SI-System-and-Information-Integrity/policy-imagemanifestvuln.yaml) | Detect vulnerabilities in container images. Leverages the [Container Security Operator](https://github.com/quay/container-security-operator) and installs it on the managed cluster if it does not exist. |

You can contribute more policies that map to the System and Information Integrity control family. See [Contibuting policies](https://github.com/open-cluster-management-io/policy-collection/blob/main/docs/CONTRIBUTING.md) for more details.
