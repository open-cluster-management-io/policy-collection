# Access Control

Use access control policies to define user actions for your cluster. View the following table list of the stable policies that are supported by [Red Hat Advanced Cluster Management for Kubernetes](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.1/html-single/security/index#kubernetes-configuration-policy-controller):

Policy  | Description | Prerequisites
------- | ----------- | -------------
[policy-limitclusteradmin](./AC-Access-Control/policy-limitclusteradmin.yaml) | Limit the number of cluster administrator for Openshift users. |
[policy-role](./AC-Access-Control/policy-role.yaml) | Ensures that a role exists with permissions as specified. |
[policy-rolebinding](./AC-Access-Control/policy-rolebinding.yaml) | Ensures that an entity is bound to a particular role. |
