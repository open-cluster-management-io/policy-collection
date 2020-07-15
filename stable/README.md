# Policies -- Stable
Policies in this folder are organized by [NIST Special Publication 800-53](https://nvd.nist.gov/800-53). For more information, please read [NIST.SP.800-53r4](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r4.pdf).

## Policies organized by security control catalog

* Access Control
  * [policy-limitclusteradmin](./AC-Access-Control/policy-limitclusteradmin.yaml)
  * [policy-role](./AC-Access-Control/policy-role.yaml)
  * [policy-rolebinding](./AC-Access-Control/policy-rolebinding.yaml)
* Awareness and Training
* Audit and Accountability
* Security Assessment and Authorization
* Configuration Management
  * [policy-limitmemory](./CM-Configuration-Management/policy-limitmemory.yaml)
  * [policy-namespace](./CM-Configuration-Management/policy-namespace.yaml)
  * [policy-pod](./CM-Configuration-Management/policy-pod.yaml)
* Contingency Planning
* Identification and Authentication
* Incident Response
* Maintenance
* Media Protection
* Physical and Environmental Protection
* Planning
* Personnel Security
* Risk Assessment
* System and Services Acquisition
* System and Communications Protection
  * [policy-certificate](./SC-System-and-Communications-Protection/policy-certificate.yaml)
* System and Information Integrity
  * [policy-imagemanifestvuln](./SI-System-and-Information-Integrity/policy-imagemanifestvuln.yaml)
  * [policy-psp](./SI-System-and-Information-Integrity/policy-psp.yaml)
  * [policy-scc](./SI-System-and-Information-Integrity/policy-scc.yaml)

