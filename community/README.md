# Policies -- Community
Policies in this folder are organized by [NIST Special Publication 800-53](https://nvd.nist.gov/800-53). For more information, read [NIST.SP.800-53r4](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r4.pdf).

## Security control catalog
<table>
  <tr>
    <th>Security control</th>
    <th>Policies</th>
    <th>Prerequisites</th>
  </tr>
  <tr>
    <td>Access Control</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Awareness and Training</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Audit and Accountability</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Security Assessment and Authorization</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td rowspan="3">Configuration Management</td>
    <td><a href="./CM-Configuration-Management/policy-trusted-container.yaml">Trusted Container policy</a>: Use the trusted container policy to detect if running pods are using trusted images.</td>
    <td><a href="https://github.com/ycao56/trusted-container-policy-controller">Trusted Container Policy Controller</a></td>
  </tr>
  <tr>
    <td><a href="./CM-Configuration-Management/policy-trusted-node.yaml">Trusted Node policy</a>: Use the trusted node policy to detect if there are untrusted/unattested nodes in the cluster.</td>
    <td><a href="https://github.com/lumjjb/trusted-node-policy-controller">Trusted Node Policy Controller</a></td>
  </tr>
  <tr>
    <td><a href="./CM-Configuration-Management/policy-opa-sample.yaml">OPA Sample policy</a>: Use the Open Policy Agent (OPA) Sample policy to view example of how an OPA policy can be <br>created using ConfigMap. You can also view an example of adding a `REGO` script into a ConfigMap, which is evaluated by the OPA.</td>
    <td>See the <a href="https://github.com/ycao56/mcm-opa">OPA example repository</a>. Note: OPA must be installed to use the OPA ConfigMap policy.</td>
  </tr>
  <tr>
    <td>Contingency Planning</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Identification and Authentication</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Incident Response</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Maintenance</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Media Protection</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Physical and Environmental Protection</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Planning</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Personnel Security</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Risk Assessment</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>System and Services Acquisition</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>System and Communications Protection</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td rowspan="2">System and Information Integrity</td>
    <td><a href="./SI-System-and-Information-Integrity/policy-falco.yaml">Falco Cloud-Native runtime security</a> -- Falco parses Linux system calls from the kernel at runtime, and asserts <br>the stream against a powerful rules engine. If a rule is violated a Falco alert is triggered.</td>
    <td><a href="https://falco.org/">The Falco Project</a></td>
  </tr>
  <tr>
    <td><a href="./SI-System-and-Information-Integrity/policy-sysdig.yaml">Sysdig Agent</a> -- Enforce Sysdig Agent deployment in all targeted clusters. The Sysdig Secure DevOps Platform <br> converges security and compliance with performance and capacity monitoring to create a secure DevOps workflow. It uses the same data <br>to monitor and secure, so you can correlate system activity with Kubernetes services.</td>
    <td>Check <a href="https://sysdig.com/">Sysdig</a> and start a <a href="https://go.sysdig.com/IBM-OpenShift-Everywhere.html">Free Trial</a></td>
  </tr>
</table>

## Deploying community policies to your cluster
While the policies in [stable](../stable) all have out-of-the-box support installed with RHACM, community policies are maintained by the open source community, and thus you may need to deploy extra policy consumers in order for community policies to work as intended. If you are seeing the error `no matches for kind "<resource name>" in version "<group>/<version>", you will need to deploy the CRD for that policy before creating it. If some of the policies in this folder are not behaving properly, you will need to deploy the corresponding policy consumers to handle them.

### Custom policy controllers
Custom policy controllers are created from forks of the [sample policy controller repo](https://github.com/open-cluster-management/multicloud-operators-policy-controller), and as such the process for deploying them is essentially the same as the process for deploying the sample controller. 
- Run `kubectl apply -f <CRD path>` on your cluster to install the CRD for the custom policy.
- Run `kubectl apply -f deploy/` to set up the operator and service account that will run the controller on your cluster.

### Policy consumers on operator hub
Some policy consumers are packaged as [operators](https://coreos.com/operators/) and are available on the [Operator hub](https://operatorhub.io/). These consumers can simply be deployed by creating a Policy with child [Configuration Policies](https://github.com/open-cluster-management/config-policy-controller) to handle the install. These Configuration Policies may include:
- create the namespace to deploy the operator on, if necessary
- ClusterServiceVersion with install capabilities to install the operator from the operator hub
- create an OperatorGroup
- create a Subscription
- create the custom resource defined by the consumer to enforce custom policies
For a more specific example of this method of deploying a policy consumer from the operator hub, see [policy-falco](./SI-System-and-Information-Integrity/policy-falco.yaml).

### Other custom policy consumers
Occasionally, policies in this folder may be consumed by controllers that do not fall into either of the two categories above. To get the most out of these policies, consult the "prerequisites" section in the catalog below.
