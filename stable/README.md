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
[policy-limitclusteradmin](./AC-Access-Control/policy-limitclusteradmin.yaml) | Limit the number of cluster administrator Openshift users |
[policy-role](./AC-Access-Control/policy-role.yaml) | Ensure a role exists with permissions as specified |
[policy-rolebinding](./AC-Access-Control/policy-rolebinding.yaml) | Ensure an entity is bound to a particular role |

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
No policies yet       |  | 

### Configuration Management

Policy  | Description | Prerequisites
------- | ----------- | -------------
[policy-etcdencryption](./CM-Configuration-Management/policy-etcdencryption.yaml) | Use an encryption policy to encrypt sensitive resources such as Secrets, ConfigMaps, Routes and OAuth access tokens in your cluster.  | See the [OpenShift Documentation](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.5/html/security/encrypting-etcd#enabling-etcd-encryption_encrypting-etcd) to learn how to enable ETCD encryption post install.
[policy-limitmemory](./CM-Configuration-Management/policy-limitmemory.yaml) | Ensure resource limits are in place as specified |
[policy-namespace](./CM-Configuration-Management/policy-namespace.yaml) | Ensure a namespace exists as specified |
[policy-pod](./CM-Configuration-Management/policy-pod.yaml) | Ensure a pod exists as specified |

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
[policy-certificate](./SC-System-and-Communications-Protection/policy-certificate.yaml) | Ensure certificates are not expiring within a given minimum timeframe |

### System and Information Integrity

Policy  | Description | Prerequisites
------- | ----------- | -------------
[policy-imagemanifestvuln](./SI-System-and-Information-Integrity/policy-imagemanifestvuln.yaml) | Detect vulnerabilities in container images. (Leverages the [Container Security Operator](https://github.com/quay/container-security-operator) and installs it on the managed cluster if not already present.) |
[policy-psp](./SI-System-and-Information-Integrity/policy-psp.yaml) | Ensure a Pod Security Policy exists as specified |
[policy-scc](./SI-System-and-Information-Integrity/policy-scc.yaml) | Ensure a Security Context Constraint exists as specified |
