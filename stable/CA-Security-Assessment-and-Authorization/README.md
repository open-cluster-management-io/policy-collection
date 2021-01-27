# Security Assessment and Authorization policies

See [NIST Special Publication 800-53 (Rev. 4)](https://nvd.nist.gov/800-53/Rev4/family/Security%20Assessment%20and%20Authorization) for a description of the Security Assessment and Authorization security control. 
View the following table list of the stable policy that is supported by [Red Hat Advanced Cluster Management for Kubernetes](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.1/html-single/security/index#kubernetes-configuration-policy-controller):

Policy  | Description | Prerequisites
------- | ----------- | -------------
[Install Red Hat Compliance Operator policy](./CA-Security-Assessment-and-Authorization/policy-compliance-operator-install.yaml) | Use the official and supported compliance operator installation, `policy-comp-operator` policy, to enable continuous compliance monitoring for your cluster. After you install this operator, you must select what benchmark you want to comply to, and create the appropriate objects for the scans to be run. | See [Compliance Operator](https://docs.openshift.com/container-platform/4.6/security/compliance_operator/compliance-operator-understanding.html#compliance-operator-understanding) for more details.

<!--concerned about creating a readme for this policy, unless this policy is also supported in 2.1-->