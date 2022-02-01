# Access Control

See [NIST Special Publication 800-53 (Rev. 4)](https://nvd.nist.gov/800-53/Rev4/control/AC-1) for a description of the Access Control family. View the policies that define user actions for your cluster and map to the Access Control catalog. View the following table list of the stable policies that are supported by [Red Hat Advanced Cluster Management for Kubernetes](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.2/html-single/security/index#kubernetes-configuration-policy-controller):

Policy  | Description | Prerequisites
------- | ----------- | -------------
[policy-limitclusteradmin](../AC-Access-Control/policy-limitclusteradmin.yaml) | Limit the number of cluster administrator for Openshift users. |
[policy-role](../AC-Access-Control/policy-role.yaml) | Ensures that a role exists with permissions as specified. |
[policy-rolebinding](../AC-Access-Control/policy-rolebinding.yaml) | Ensures that an entity is bound to a particular role. |


You can contribute more policies that map to the Access Control catalog. See [Contibuting policies](https://github.com/stolostron/policy-collection/blob/main/docs/CONTRIBUTING.md) for more details.
