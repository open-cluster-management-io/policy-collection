# Policies -- Stable
Policies in this folder are supported by [Red Hat Advanced Cluster Management for Kubernetes](https://www.redhat.com/en/technologies/management/advanced-cluster-management) and organized by [NIST Special Publication 800-53](https://nvd.nist.gov/800-53). NIST SP 800-53 Rev 4 also includes mapping to the ISO/IEC 27001 controls. For more information, read _Appendix H_ in [NIST.SP.800-53r4](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r4.pdf).

## Security control catalog

- [AC - Access Control](#access-control)
- [AT - Awareness and Training](#awareness-and-training)
- [AU - Audit and Accountability](#audit-and-accountability)
- [CA - Security Assessment and Authorization](#security-assessment-and-authorization)
- [CM - Configuration Management](#configuration-management)
- [CP - Contingency Planning](#contingency-planning)
- [IA - Identification and Authentication](#identification-and-authentication)
- [IR - Incident Response](#incident-response)
- [MA - Maintenance](#maintenance)
- [MP - Media Protection](#media-protection)
- [PE - Physical and Environmental Protection](#physical-and-environmental-protection)
- [PL - Planning](#planning)
- [PS - Personnel Security](#personnel-security)
- [RA - Risk Assessment](#risk-assessment)
- [SA - System and Services Acquisition](#system-and-services-acquisition)
- [SC - System and Communications Protection](#system-and-communications-protection)
- [SI - System and Information Integrity](#system-and-information-integrity)


### Access Control
Policy  | Description | Prerequisites
------- | ----------- | -------------
[policy-limitclusteradmin](./AC-Access-Control/policy-limitclusteradmin.yaml) | Limits the number of cluster administrator Openshift users. |
[policy-role](./AC-Access-Control/policy-role.yaml) | Ensures that a role exists with permissions as specified. |
[policy-rolebinding](./AC-Access-Control/policy-rolebinding.yaml) | Ensures that an entity is bound to a particular role. |

### Awareness and Training

Policy  | Description | Prerequisites
------- | ----------- | -------------
No policies yet       |  | 

### Audit and Accountability

Policy  | Description | Prerequisites
------- | ----------- | -------------
No policies yet       |  | 

### Security Assessment and Authorization
Policy  | Description | Prerequisites
------- | ----------- | -------------
[Install Red Hat Compliance Operator policy](./CA-Security-Assessment-and-Authorization/policy-compliance-operator-install.yaml) | Use the official and supported compliance operator installation, `policy-comp-operator` policy, to enable continuous compliance monitoring for your cluster. After you install this operator, you must select what benchmark you want to comply to, and create the appropriate objects for the scans to be run. | See [Compliance Operator](https://docs.openshift.com/container-platform/4.6/security/compliance_operator/compliance-operator-understanding.html#compliance-operator-understanding) for more details.

### Configuration Management
Policy  | Description | Prerequisites
------- | ----------- | -------------
[Scan your cluster with the E8 (Essential 8) security profile](./CM-Configuration-Management/policy-compliance-operator-e8-scan.yaml) | This example creates a ScanSettingBinding that the ComplianceOperator uses to scan the cluster for compliance with the E8 benchmark. | See the [Compliance Operator repo](https://github.com/openshift/compliance-operator) to learn more about the operator. **Note**: Compliance operator must be installed to use this policy. See the [Compliance operator policy](./CA-Security-Assessment-and-Authorization/policy-compliance-operator-install.yaml).
[Install Red Hat Gatekeeper Operator policy](./CM-Configuration-Management/policy-gatekeeper-operator-downstream.yaml) | Use the Gatekeeper operator policy to install the official and supported version of Gatekeeper on a managed cluster. | See the [Gatekeeper Operator](https://github.com/gatekeeper/gatekeeper-operator).
[policy-etcdencryption](./CM-Configuration-Management/policy-etcdencryption.yaml) | Use an encryption policy to encrypt sensitive resources such as Secrets, ConfigMaps, Routes and OAuth access tokens in your cluster.  | See the [OpenShift Documentation](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.5/html/security/encrypting-etcd#enabling-etcd-encryption_encrypting-etcd) to learn how to enable ETCD encryption post install.
[policy-limitmemory](./CM-Configuration-Management/policy-limitmemory.yaml) | Ensures that resource limits are in place as specified. |
[policy-namespace](./CM-Configuration-Management/policy-namespace.yaml) | Ensures that a namespace exists as specified. |
[policy-pod](./CM-Configuration-Management/policy-pod.yaml) | Ensures that a pod exists as specified. |

### Contingency Planning

Policy  | Description | Prerequisites
------- | ----------- | -------------
No policies yet       |  | 

### Identification and Authentication

Policy  | Description | Prerequisites
------- | ----------- | -------------
No policies yet       |  | 

### Incident Response

Policy  | Description | Prerequisites
------- | ----------- | -------------
No policies yet       |  | 

### Maintenance

Policy  | Description | Prerequisites
------- | ----------- | -------------
No policies yet       |  | 

### Media Protection

Policy  | Description | Prerequisites
------- | ----------- | -------------
No policies yet       |  | 

### Physical and Environmental Protection

Policy  | Description | Prerequisites
------- | ----------- | -------------
No policies yet       |  | 

### Planning

Policy  | Description | Prerequisites
------- | ----------- | -------------
No policies yet       |  | 

### Personnel Security

Policy  | Description | Prerequisites
------- | ----------- | -------------
No policies yet       |  | 

### Risk Assessment

Policy  | Description | Prerequisites
------- | ----------- | -------------
No policies yet       |  | 

### System and Services Acquisition

Policy  | Description | Prerequisites
------- | ----------- | -------------
No policies yet       |  | 


### System and Communications Protection
Policy  | Description | Prerequisites
------- | ----------- | -------------
[policy-certificate](./SC-System-and-Communications-Protection/policy-certificate.yaml) | Ensure certificates are not expiring within a given minimum time frame. |


### System and Information Integrity
Policy  | Description | Prerequisites
------- | ----------- | -------------
[policy-imagemanifestvuln](./SI-System-and-Information-Integrity/policy-imagemanifestvuln.yaml) | Detect vulnerabilities in container images. Leverages the [Container Security Operator](https://github.com/quay/container-security-operator) and installs it on the managed cluster if not already present. |
[policy-psp](./SI-System-and-Information-Integrity/policy-psp.yaml) | Ensure a pod security policy exists as specified. |
[policy-scc](./SI-System-and-Information-Integrity/policy-scc.yaml) | Ensure a Security Context Constraint exists as specified. |

