# Configuration Management 

See [NIST Special Publication 800-53 (Rev. 4)](https://nvd.nist.gov/800-53/Rev4/family/Configuration%20Management) for a description of the Configuration Management control. View the configuration policies that map to the Configuration Management catalog, and helps to detect or remediate security issues that are in the category. See the following table list of the stable policies that are supported by [Red Hat Advanced Cluster Management for Kubernetes](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.1/html/security/security#governance-and-risk):

Policy  | Description | Prerequisites
------- | ----------- | -------------
[Scan your cluster with the E8 (Essential 8) security profile](../CM-Configuration-Management/policy-compliance-operator-e8-scan.yaml) | This example creates a ScanSettingBinding that the ComplianceOperator uses to scan the cluster for compliance with the E8 benchmark. | See the [Compliance Operator repo](https://github.com/openshift/compliance-operator) to learn more about the operator. **Note**: Compliance operator must be installed to use this policy. See the [Compliance operator policy](../CA-Security-Assessment-and-Authorization/policy-compliance-operator-install.yaml).
[Install Red Hat Gatekeeper Operator policy](../CM-Configuration-Management/policy-gatekeeper-operator-downstream.yaml) | Use the Gatekeeper operator policy to install the official and supported version of Gatekeeper on a managed cluster. | See the [Gatekeeper Operator](https://github.com/gatekeeper/gatekeeper-operator).
[policy-namespace](../CM-Configuration-Management/policy-namespace.yaml) | Ensures that a namespace exists as specified. |
[policy-pod](../CM-Configuration-Management/policy-pod.yaml) | Ensures that a pod exists as specified. |

You can contribute more policies that map to the Configuration Management catalog. See [Contibuting policies](https://github.com/open-cluster-management/policy-collection/blob/master/docs/CONTRIBUTING.md) for more details.
