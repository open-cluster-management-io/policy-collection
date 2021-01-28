# System and Communications Protection

As described in [NIST Special Publication 800-53 (Rev. 4)](https://nvd.nist.gov/800-53/Rev4/control/SC-1), use System and Communications Protection policy to implement policies for the selected security controls and control enhancements. 
View the following table list of the stable policy that is supported by [Red Hat Advanced Cluster Management for Kubernetes](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.1/html/security/security#managing-certificate-policies):

Policy  | Description | Prerequisites
------- | ----------- | -------------
[policy-certificate](./policy-certificate.yaml) | Ensure certificates are not expiring within a given minimum timeframe. |
