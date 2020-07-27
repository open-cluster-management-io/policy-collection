# Policies -- Community
Policies in this folder are organized by [NIST Special Publication 800-53](https://nvd.nist.gov/800-53). For more information, read [NIST.SP.800-53r4](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r4.pdf).

## Security control catalog
View a list of policies that are organized by the security control catalog.

* Access Control
* Awareness and Training
* Audit and Accountability
* Security Assessment and Authorization
* Configuration Management
  * [Trusted Container policy](./CM-Configuration-Management/policy-trusted-container.yaml): Detect if running pods are using trusted images. For more information, see [Trusted Container Policy Controller](https://github.com/ycao56/trusted-container-policy-controller).
  * [OPA ConfigMap policy](./CM-Configuration-Management/opa-configmap.yaml): Use the Open Policy Agent (OPA) ConfigMap policy to view example of how a ConfigMap can be created with a policy. This policy also verifies that the namespaces for your OPA installation and for the placement policy already exist. You can also view an example of adding a `REGO` script into a ConfigMap, which is evaluated by the OPA. For more information on this approach, see the [example repository](https://github.com/ycao56/mcm-opa).
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
* System and Information Integrity




