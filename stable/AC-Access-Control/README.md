# Access Control

See [Security and Privacy Controls for Information Systems and Organizations, Revision 5](https://csrc.nist.gov/projects/cprt/catalog#/cprt/framework/version/SP_800_53_5_1_0/home?element=AC) for details of the Access Control family. View the policies that define user actions for your cluster and map to the Access Control catalog.

Policy  | Description | Prerequisites
------- | ----------- | -------------
[policy-limitclusteradmin](../AC-Access-Control/policy-limitclusteradmin.yaml) | Limit the number of cluster administrator for Openshift users. |
[policy-role](../AC-Access-Control/policy-role.yaml) | Ensures that a role exists with permissions as specified. |
[policy-rolebinding](../AC-Access-Control/policy-rolebinding.yaml) | Ensures that an entity is bound to a particular role. |


You can contribute more policies that map to the Access Control catalog. See [Contibuting policies](https://github.com/open-cluster-management-io/policy-collection/blob/main/docs/CONTRIBUTING.md) for more details.
