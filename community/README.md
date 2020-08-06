# Policies -- Community
Policies in this folder are organized by [NIST Special Publication 800-53](https://nvd.nist.gov/800-53). For more information, read [NIST.SP.800-53r4](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r4.pdf).

## Deploying community policies to your cluster
While the policies in [stable](../stable) all have out-of-the-box support installed with RHACM, community policies are maintained by the open source community, and thus you may need to deploy extra policy consumers in order for community policies to work as intended. If you are seeing the error `no matches for kind "<resource name>" in version "<group>/<version>", you will need to deploy the CRD for that policy before creating it. If some of the policies in this folder are not behaving properly, you will need to deploy the corresponding policy consumers to handle them.

### Custom policy controllers
Custom policy controllers are created from forks of the [sample policy controller repo](https://github.com/open-cluster-management/multicloud-operators-policy-controller), and as such the process for deploying them is essentially the same as the process for deploying the sample controller. 
- Run `kubectl apply -f <CRD path>` on your cluster to install the CRD for the custom policy.
- Run `kubectl apply -f deploy/` to set up the operator and service account that will run the controller on your cluster.

### Policy consumers on operator hub
Some policy consumers are stored as images on the Operator hub. These consumers can simply be deployed by creating a Policy with child [Configuration Policies](https://github.com/open-cluster-management/config-policy-controller) to handle the install. These Configuration Policies may include:
- create the namespace to deploy the operator on, if necessary
- ClusterServiceVersion with install capabilities to install the operator from the operator hub
- create an OperatorGroup
- create a Subscription
- create the custom resource defined by the consumer to enforce custom policies
For a more specific example of this method of deploying a policy consumer from the operator hub, see [policy-falco](./SI-System-and-Information-Integrity/policy-falco.yaml).

### Other custom policy consumers
Occasionally, policies in this folder may be consumed by controllers that do not fall into either of the two categories above. To get the most out of these policies, consult the "prerequisites" section in the catalog below.

## Security control catalog
| Security control | Policies | Prerequisites |
| --- | --- | --- |
| Access Control | N/A | N/A |
| Awareness and Training | N/A | N/A |
| Audit and Accountability | N/A | N/A |
| Security Assessment and Authorization | N/A | N/A |
| Configuration Management | <table><tr><td>[Trusted Container policy](./CM-Configuration-Management/policy-trusted-container.yaml): Use the trusted container policy to detect if running pods are using trusted images.</td><td>[Trusted Container Policy Controller](https://github.com/ycao56/trusted-container-policy-controller)</td></tr><tr><td>[Trusted Node policy](./CM-Configuration-Management/policy-trusted-node.yaml): Use the trusted node policy to detect if there are untrusted/unattested nodes in the cluster.</td><td>[Trusted Node Policy Controller](https://github.com/lumjjb/trusted-node-policy-controller)</td></tr><tr><td>[OPA Sample policy](./CM-Configuration-Management/policy-opa-sample.yaml): Use the Open Policy Agent (OPA) Sample policy to view example of how an OPA policy can be created using ConfigMap. You can also view an example of adding a `REGO` script into a ConfigMap, which is evaluated by the OPA.</td><td>See the [OPA example repository](https://github.com/ycao56/mcm-opa). Note: OPA must be installed to use the OPA ConfigMap policy.</td></tr></table> | N/A |
| Contingency Planning | N/A | N/A |
| Identification and Authentication | N/A | N/A |
| Incident Response | N/A | N/A |
| Maintenance | N/A | N/A |
| Media Protection | N/A | N/A |
| Physical and Environmental Protection | N/A | N/A |
| Planning | N/A | N/A |
| Personnel Security | N/A | N/A |
| Risk Assessment | N/A | N/A |
| System and Services Acquisition | N/A | N/A |
| System and Communications Protection | N/A | N/A |
| System and Information Integrity | <ul><li>[Falco Cloud-Native runtime security](./SI-System-and-Information-Integrity/policy-falco.yaml) -- Falco parses Linux system calls from the kernel at runtime, and asserts the stream against a powerful rules engine. If a rule is violated a Falco alert is triggered.</li><li>[Sysdig Agent](./SI-System-and-Information-Integrity/policy-sysdig.yaml) -- Enforce Sysdig Agent deployment in all targeted clusters. The Sysdig Secure DevOps Platform converges security and compliance with performance and capacity monitoring to create a secure DevOps workflow. It uses the same data to monitor and secure, so you can correlate system activity with Kubernetes services.</li></ul> | <ul><li>[The Falco Project](https://falco.org/)</li><li>Check [Sysdig](https://sysdig.com/) and start a [Free Trial](https://go.sysdig.com/IBM-OpenShift-Everywhere.html)</li></ul> |
