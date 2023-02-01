# Security Assessment and Authorization

See [Security and Privacy Controls for Information Systems and Organizations, Revision 5](https://csrc.nist.gov/projects/cprt/catalog#/cprt/framework/version/SP_800_53_5_1_0/home?element=CA) for details of the Security Assessment and Authorization security control.

Policy  | Description | Prerequisites
------- | ----------- | -------------
[Install Red Hat Compliance Operator policy](../CA-Security-Assessment-and-Authorization/policy-compliance-operator-install.yaml) | Use the official and supported compliance operator installation, `policy-comp-operator` policy, to enable continuous compliance monitoring for your cluster. After you install this operator, you must select what benchmark you want to comply to, and create the appropriate objects for the scans to be run. | See [Compliance Operator](https://docs.openshift.com/container-platform/4.6/security/compliance_operator/compliance-operator-understanding.html#compliance-operator-understanding) for more details.

You can contribute more policies that map to the Security Assessment and Authorization control family. See [Contributing policies](https://github.com/open-cluster-management-io/policy-collection/blob/main/docs/CONTRIBUTING.md) for more details.

