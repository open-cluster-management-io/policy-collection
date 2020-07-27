# Policies -- Community
Policies in this folder are organized by [NIST Special Publication 800-53](https://nvd.nist.gov/800-53). For more information, read [NIST.SP.800-53r4](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r4.pdf).

## Security control catalog
View a list of policies that are organized by the security control catalog.

* Access Control
* Awareness and Training
* Audit and Accountability
* Security Assessment and Authorization
* Configuration Management
  * [Trusted Container policy](./CM-Configuration-Management/policy-trusted-container.yaml): Use the trusted container policy to detect if running pods are using trusted images. For more information, see [Trusted Container Policy Controller](https://github.com/ycao56/trusted-container-policy-controller).
  * [OPA Sample policy](./CM-Configuration-Management/policy-opa-sample.yaml): Use the Open Policy Agent (OPA) Sample policy to view example of how an OPA policy can be created using ConfigMap. You can also view an example of adding a `REGO` script into a ConfigMap, which is evaluated by the OPA. For more information on this approach, see the [example repository](https://github.com/ycao56/mcm-opa). Note: OPA must be installed to use the OPA ConfigMap policy.
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
  * [Falco Cloud-Native runtime security](./SI-System-and-Information-Integrity/policy-falco.yaml) -- Falco parses Linux system calls from the kernel at runtime, and asserts the stream against a powerful rules engine. If a rule is violated a Falco alert is triggered. See [The Falco Project](https://falco.org/).
  * [Sysdig Agent](./SI-System-and-Information-Integrity/policy-sysdig.yaml) -- Enforce Sysdig Agent deployment in all targeted clusters. The Sysdig Secure DevOps Platform converges security and compliance with performance and capacity monitoring to create a secure DevOps workflow. It uses the same data to monitor and secure, so you can correlate system activity with Kubernetes services. Check [Sysdig](https://sysdig.com/) and start a [Free Trial](https://go.sysdig.com/IBM-OpenShift-Everywhere.html).




