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
    <td rowspan="7">Configuration Management</td>
    <td><a href="./CM-Configuration-Management/policy-trusted-container.yaml">Trusted Container policy</a>: Use the trusted container policy to detect if running pods are using trusted images.</td>
    <td><a href="https://github.com/ycao56/trusted-container-policy-controller">Trusted Container Policy Controller</a></td>
  </tr>
  <tr>
    <td><a href="./CM-Configuration-Management/policy-trusted-node.yaml">Trusted Node policy</a>: Use the trusted node policy to detect if there are untrusted or unattested nodes in the cluster.</td>
    <td><a href="https://github.com/lumjjb/trusted-node-policy-controller">Trusted Node Policy Controller</a></td>
  </tr>
  <tr>
    <td><a href="./CM-Configuration-Management/policy-opa-sample.yaml">OPA Sample policy</a>: Use the Open Policy Agent (OPA) Sample policy to view an example of how an OPA policy can be created. You can also view an example of adding a <i>REGO</i> script into a ConfigMap, which is evaluated by the OPA.</td>
    <td>See the <a href="https://github.com/ycao56/mcm-opa">OPA example repository</a>. <b>Note</b>: OPA must be installed to use the OPA ConfigMap policy.</td>
  </tr>
  <tr>
    <td><a href="./CM-Configuration-Management/policy-gatekeeper-sample.yaml">Gatekeeper Sample policy</a>: Use the Gate Sample policy to view an example of how a gatekeeper policy can be applied to a managed cluster</td>
    <td>See the <a href="https://github.com/open-policy-agent/gatekeeper">Gatekeeper</a>. <b>Note</b>: Gatekeeper controllers must be installed to use the gatekeeper policy.</td>
  </tr>
  <tr>
    <td><a href="./CM-Configuration-Management/policy-machineconfig-chrony.yaml">MachineConfig Chrony Sample policy: </a> Use the MachineConfig Chrony policy to configure <i>/etc/chrony.conf</i> on certain machines </a>.</td> 
    <td>For more information see, <a href="https://jaosorior.dev/2019/modifying-node-configurations-in-openshift-4.x/"> Modifying node configurations in OpenShift 4.x blog</a>. <b>Note</b>: The policy requires that the managed cluster is OpenShift Container Platform.</td>
    </tr>
  <tr>
    <td><a href="./CM-Configuration-Management/policy-network-policy-samples.yaml">Network-Policy-Samples:</a> Use the Network policy to specify how groups of pods are allowed to communicate with each other and other network endpoints. For examples of Network policies, see <a href="./CM-Configuration-Management/policy-network-policy-samples.yaml">Network-Policy-Samples.</a>
    <td>See the <a href "https://access.redhat.com/articles/5059881"> OpenShift Security Guide </a>. <b>Note</b>: The policy might be modified to the actual usecases </td>
    </tr>
  <tr>
    <td><a href="./CM-Configuration-Management/policy-egress-firewall-sample.yaml">Egress-Policy-Sample:</a> With the egress firewall you can define rules (per project) to allow or deny traffic (TCP or UDP) to the external network.</td>
    <td>See the <a href "https://access.redhat.com/articles/5059881"> OpenShift Security Guide </a>: Use the OpenShift Security Guide to secure your OpenShift cluster. </td>
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
    <td><a href="./SI-System-and-Information-Integrity/policy-falco.yaml">Falco Cloud-Native runtime security</a>: Falco parses Linux system calls from the kernel at runtime, and asserts <br>the stream against a powerful rules engine. If a rule is violated a Falco alert is triggered.</td>
    <td><a href="https://falco.org/">The Falco Project</a></td>
  </tr>
  <tr>
    <td><a href="./SI-System-and-Information-Integrity/policy-sysdig.yaml">Sysdig Agent</a>: The Sysdig Secure DevOps Platform converges security and compliance with performance and capacity monitoring <br> to create a secure DevOps workflow. It uses the same data to monitor and secure, so you can correlate system activity with Kubernetes services.</td>
    <td>Check <a href="https://sysdig.com/">Sysdig</a> and start a <a href="https://go.sysdig.com/IBM-OpenShift-Everywhere.html">Free Trial</a></td>
  </tr>
</table>

## Deploying community policies to your cluster
While the policies in the [stable](../stable) folder all have out-of-the-box support installed with Red Hat Advanced Cluster Management, community policies are maintained by the open source community. You might need to deploy extra policy consumers in order for community policies to work as intended. If you are seeing the error `no matches for kind "<resource name>" in version "<group>/<version>"`, you must deploy the CustomResourceDefiniton (CRD) for the policy before you create it. If some of the policies in this folder are not behaving properly, you must deploy the corresponding policy consumers to handle them.

### Custom policy controllers
Custom policy controllers are created from forks of the [sample policy controller repo](https://github.com/open-cluster-management/multicloud-operators-policy-controller), and as such the process for deploying them is essentially the same as the process for deploying the sample controller. 
- Run the following command on your cluster to install the CRD for the custom policy: `kubectl apply -f <CRD path>`
- Run the following command to set up the operator and service account that runs the controller on your cluster: `kubectl apply -f deploy/`

### Policy consumers on operator hub
Some policy consumers are packaged as [operators](https://coreos.com/operators/) and are available on the [Operator hub](https://operatorhub.io/). These consumers can simply be deployed by creating a policy with child [configuration policies](https://github.com/open-cluster-management/config-policy-controller) to handle the install. The configuration policies might include the following information:
- A namespace to deploy the operator on, if necessary
- A ClusterServiceVersion with install capabilities to install the operator from the operator hub
- A OperatorGroup
- A Subscription
- The custom resource defined by the consumer to enforce custom policies
For a more specific example of this method of deploying a policy consumer from the operator hub, see [policy-falco](./SI-System-and-Information-Integrity/policy-falco.yaml).

### Other custom policy consumers
Occasionally, policies in this folder might be consumed by controllers that do not fall into either of the two categories previously mentioned. To get the most out of these policies, see the [Security control catalog](#security-control-catalog)
