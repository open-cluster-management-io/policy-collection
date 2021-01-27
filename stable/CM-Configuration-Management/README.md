# Configuration management 

<!--explain what is the CM catalog, the following policy maps to the cm helps detect or remediate security issues that are in the category(NIST security spec)-->
Use Configuration management policies maintain a consistent state for your cluster. View the following table list of the stable policies that are supported by [Red Hat Advanced Cluster Management for Kubernetes](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.1/html-single/security/index#kubernetes-configuration-policy-controller):

Policy  | Description | Prerequisites
------- | ----------- | -------------
[Scan your cluster with the E8 (Essential 8) security profile](./CM-Configuration-Management/policy-compliance-operator-e8-scan.yaml) | This example creates a ScanSettingBinding that the ComplianceOperator uses to scan the cluster for compliance with the E8 benchmark. | See the [Compliance Operator repo](https://github.com/openshift/compliance-operator) to learn more about the operator. **Note**: Compliance operator must be installed to use this policy. See the [Compliance operator policy](./CA-Security-Assessment-and-Authorization/policy-compliance-operator-install.yaml).
[policy-etcdencryption](./CM-Configuration-Management/policy-etcdencryption.yaml) | Use an encryption policy to encrypt sensitive resources such as Secrets, ConfigMaps, Routes and OAuth access tokens in your cluster.  | See the [OpenShift Documentation](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.5/html/security/encrypting-etcd#enabling-etcd-encryption_encrypting-etcd) to learn how to enable ETCD encryption post install.
[policy-limitmemory](./CM-Configuration-Management/policy-limitmemory.yaml) | Ensure resource limits are in place as specified |
[policy-namespace](./CM-Configuration-Management/policy-namespace.yaml) | Ensure a namespace exists as specified |
[policy-pod](./CM-Configuration-Management/policy-pod.yaml) | Ensure a pod exists as specified |
