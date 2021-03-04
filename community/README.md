# Policies -- Community
Policies in this folder are organized by [NIST Special Publication 800-53](https://nvd.nist.gov/800-53). NIST SP 800-53 Rev 4 also includes mapping to the ISO/IEC 27001 controls. For more information, read _Appendix H_ in [NIST.SP.800-53r4](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r4.pdf).

## Table of Contents

- [Policy catalog (grouped by security control)](#security-control-catalog)
- [Deploying community policies to your cluster](#deploying-community-policies-to-your-cluster)
  - [Custom policy controllers](#custom-policy-controllers)
  - [Policy consumers on operator hub](#policy-consumers-on-operator-hub)


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
[Disallowed roles policy](./AC-Access-Control/policy-roles-no-wildcards.yaml) | Use the disallowed roles policy to make sure no pods are being granted full access in violation of least privilege. | Check [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) to learn more about Kubernetes RBAC authorization.

### Awareness and Training

Policy  | Description | Prerequisites
------- | ----------- | -------------
No policies yet       |  | 

### Audit and Accountability

Policy  | Description | Prerequisites
------- | ----------- | -------------
[Example of configuring audit logging with a policy](./AU-Audit-and-Accountability/policy-openshift-audit-logs-sample.yaml) | Use `policy-openshift-audit-logs-sample.yaml` policy to configure audit logging in your OpenShift cluster. For example, you can deploy the policy to configure Elasticsearch to store the audit logs data and view them on Kibana console. | See the [OpenShift Documentation](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.6/html/logging/cluster-logging). This policy is only valid for OpenShift 4.6.x and needs to be adjusted for the proper environment.

### Security Assessment and Authorization

Policy  | Description | Prerequisites
------- | ----------- | -------------
[Install Upstream Compliance Operator policy](./CA-Security-Assessment-and-Authorization/policy-compliance-operator-install-upstream.yaml) | Use the upstream compliance operator installation, `policy-comp-operator` policy, to enable continuous compliance monitoring for your cluster. After you install this operator, you must select what benchmark you want to comply to, and create the appropriate objects for the scans to be run. | See [Compliance Operator](https://github.com/openshift/compliance-operator) for more details.

### Configuration Management

Policy  | Description | Prerequisites
------- | ----------- | -------------
[Upgrade OpenShift-Cluster Sample policy](./CM-Configuration-Management/policy-upgrade-openshift-cluster.yaml) | Use this policy to upgrade an OpenShift cluster. | In the provided example, a version 4.5 cluster is upgraded to version 4.5.3. Change the `channel` and the `desired version` if you want to upgrade other versions.
[Egress sample policy](./CM-Configuration-Management/policy-egress-firewall-sample.yaml) | With the egress firewall you can define rules (per-project) to allow or deny traffic (TCP-or UDP) to the external network. | See the [OpenShift Security Guide.](https://access.redhat.com/articles/5059881) Use the OpenShift Security Guide to secure your OpenShift cluster.
[Example of configuring a cluster-wide proxy with a policy](./CM-Configuration-Management/policy-cluster-proxy-sample.yaml) | Use this policy to configure a cluster-wide proxy. | See the [OpenShift Documentation.](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.5/html/security/encrypting-etcd#enabling-etcd-encryption_encrypting-etcd) This policy is only valid for OpenShift 4.x and needs to be adjusted for the proper environment.
[Example of configuring DNS with a policy](./CM-Configuration-Management/policy-cluster-dns-sample.yaml) | Use this policy to configure DNS in your OpenShift cluster. For example, you can remove public DNS. | See the [OpenShift Documentation](https://docs.openshift.com/container-platform/4.5/post_installation_configuration/network-configuration.html#private-clusters-setting-dns-private_post-install-network-configuration) This policy is only valid for OpenShift 4.x and needs to be adjusted for the proper environment.
[Example of configuring the Cluster Network Operator with a policy](./CM-Configuration-Management/policy-cluster-network-sample.yaml) | Use this policy to configure the network of your OpenShift cluster. | See the [OpenShift Documentation.](https://docs.openshift.com/container-platform/4.5/post_installation_configuration/network-configuration.html#nw-operator-cr_post-install-network-configuration) This policy is only valid for OpenShift 4.x and needs to be adjusted for the proper environment.
[Example of creating a deployment object](./CM-Configuration-Management/policy-deployment-sample.yaml) | This example generates 5 replicas of \`nginx-pods\`. | See the [Kubernetes Documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) to learn more about Deployments.
[Example of a policy used to configure GitHub-Authentication](./CM-Configuration-Management/policy-github-oauth-sample.yaml) | Use this policy to log in to your OpenShift cluster with GitHub-Authentication. | See the OpenShift Documentation, [Configuring a GitHub or GitHub Enterprise identify provider](https://docs.openshift.com/container-platform/4.5/authentication/identity_providers/configuring-github-identity-provider.html) to learn more information.
[Example of installing Performance Addon Operator](./CM-Configuration-Management/policy-pao-operator.yaml) | Use this policy to install the Performance Addon Operator, which provides the ability to enable advanced node performance tunings on a set of nodes. | See the [ACM & Performance Addon Operator repository documentation](https://github.com/alosadagrande/acm-cnf/tree/master/acm-manifests/performance-operator) for more details.
[Example of installing PTP Operator](./CM-Configuration-Management/policy-ptp-operator.yaml) | Use this policy to install the Precision Time Protocol (PTP) Operator, which creates and manages the linuxptp services on a set of nodes. | See the [ACM & PTP Operator repository documentation](https://github.com/alosadagrande/acm-cnf/tree/master/acm-manifests/ptp) for more details.
[Example of installing SR-IOV Network Operator](./CM-Configuration-Management/policy-sriov-operator.yaml) | Use this policy to install the Single Root I/O Virtualization (SR-IOV) Network Operator, which manages the SR-IOV network devices and network attachments in your clusters. | See the [ACM & SR-IOV Network Operator repository documentation](https://github.com/alosadagrande/acm-cnf/tree/master/acm-manifests/sriov-operator) for more details.
[Example of labelling nodes of a cluster](./CM-Configuration-Management/policy-label-worker-nodes.yaml) | Use this policy to label nodes in your managed clusters. Notice you must know the name of the node or nodes to label.  | See the [OpenShift Documentation](https://docs.openshift.com/container-platform/4.5/nodes/nodes/nodes-nodes-working.html#nodes-nodes-working-updating_nodes-nodes-working) to learn more about labelling objects.
[Example of a policy used to configure GitHub-Authentication](./CM-Configuration-Management/policy-deployment-sample.yaml) | Use this policy to log in to your OpenShift cluster with GitHub-Authentication. | See the OpenShift Documentation, [Configuring a GitHub or GitHub Enterprise identify provider](https://docs.openshift.com/container-platform/4.5/authentication/identity_providers/configuring-github-identity-provider.html) to learn more information.
[Example to configure an image policy](./CM-Configuration-Management/policy-image-policy-sample.yaml) | Use the image policy to define the repositories from where OpenShift can pull images. | See the [OpenShift Security Guide.](https://access.redhat.com/articles/5059881) Use the OpenShift Security Guide to secure your OpenShift cluster.
[Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml) | Use the Gatekeeper operator policy to install the community version of Gatekeeper on a managed cluster. | See the [Gatekeeper Operator](https://github.com/gatekeeper/gatekeeper-operator).
[Gatekeeper container image with the latest tag](./CM-Configuration-Management/policy-gatekeeper-container-image-latest.yaml) | Use the Gatekeeper policy to enforce containers in deployable resources to not use images with the _latest_ tag. | See the [Gatekeeper documentation](https://github.com/open-policy-agent/gatekeeper). **Note**: Gatekeeper controllers must be installed to use the gatekeeper policy. See the [Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml).
[Gatekeeper liveness probe not set](./CM-Configuration-Management/policy-gatekeeper-container-livenessprobenotset.yaml) | Use the Gatekeeper policy to enforce pods that have a [liveness probe.](https://docs.openshift.com/container-platform/latest/applications/application-health.html) | See the [Gatekeeper documentation](https://github.com/open-policy-agent/gatekeeper). **Note**: Gatekeeper controllers must be installed to use the gatekeeper policy. See the [Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml).
[Gatekeeper readiness probe not set](./CM-Configuration-Management/policy-gatekeeper-container-readinessprobenotset.yaml) | Use the Gatekeeper policy to enforce pods that have a [readiness probe.](https://docs.openshift.com/container-platform/latest/applications/application-health.html) | See the [Gatekeeper documentation](https://github.com/open-policy-agent/gatekeeper). **Note**: Gatekeeper controllers must be installed to use the gatekeeper policy. See the [Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml).
[Gatekeeper allowed external IPs](./CM-Configuration-Management/policy-gatekeeper-allowed-external-ips.yaml) | Use the Gatekeeper allowed external IPs policy to define external IPs that can be applied to a managed cluster. | See the [Gatekeeper](https://github.com/open-policy-agent/gatekeeper). **Note**: Gatekeeper controllers must be installed to use the gatekeeper policy. See the [Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml).
[Gatekeeper sample policy](./CM-Configuration-Management/policy-gatekeeper-sample.yaml) | Use the Gatekeeper sample policy to view an example of how a gatekeeper policy can be applied to a managed cluster. | See the [Gatekeeper](https://github.com/open-policy-agent/gatekeeper). **Note**: Gatekeeper controllers must be installed to use the gatekeeper policy. See the [Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml).
[Gatekeeper mutation policy (owner annotation)](./CM-Configuration-Management/policy-gatekeeper-annotation-owner.yaml) | Use the Gatekeeper mutation policy to set the owner annotation on pods. | See the [Gatekeeper](https://github.com/open-policy-agent/gatekeeper). **Note**: Gatekeeper controllers must be installed to use the gatekeeper policy. See the [Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml). You must enable [*mutatingWebhook*](https://github.com/open-cluster-management/policy-collection/blob/3d6775a7ddcc007d313421c1fcc25c1fbdf28fdd/community/CM-Configuration-Management/policy-gatekeeper-operator.yaml#L111) to use the gatekeeper mutation feature. 
[Gatekeeper mutation policy (image pull policy)](./CM-Configuration-Management/policy-gatekeeper-image-pull-policy.yaml) | Use the Gatekeeper mutation policy to set or update image pull policy on pods. | See the [Gatekeeper](https://github.com/open-policy-agent/gatekeeper). **Note**: Gatekeeper controllers must be installed to use the gatekeeper policy. See the [Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml). You must enable [*mutatingWebhook*](https://github.com/open-cluster-management/policy-collection/blob/3d6775a7ddcc007d313421c1fcc25c1fbdf28fdd/community/CM-Configuration-Management/policy-gatekeeper-operator.yaml#L111) to use the gatekeeper mutation feature. 
[MachineConfig Chrony sample policy](./CM-Configuration-Management/policy-machineconfig-chrony.yaml) | Use the MachineConfig Chrony policy to configure _/etc/chrony.conf_ on certain machines . | For more information see, [Modifying node configurations in OpenShift 4.x blog](https://jaosorior.dev/2019/modifying-node-configurations-in-openshift-4.x/). **Note**: The policy requires that the managed cluster is OpenShift Container Platform.
[Network-Policy-Samples](./CM-Configuration-Management/policy-network-policy-samples.yaml) | Use the Network policy to specify how groups of pods are allowed to communicate with each other and other network endpoints. | See the [OpenShift Security Guide](https://access.redhat.com/articles/5059881). **Note**: The policy might be modified to the actual usecases.
[OPA sample policy](./CM-Configuration-Management/policy-opa-sample.yaml) | Use the Open Policy Agent (OPA) Sample policy to view an example of how an OPA policy can be created. You can also view an example of adding a _REGO_ script into a ConfigMap, which is evaluated by the OPA. | See the [OPA example repository](https://github.com/ycao56/mcm-opa). **Note**: OPA must be installed to use the OPA ConfigMap policy.
[Trusted Container policy](./CM-Configuration-Management/policy-trusted-container.yaml) | Use the trusted container policy to detect if running pods are using trusted images. | [Trusted Container Policy Controller](https://github.com/ycao56/trusted-container-policy-controller)
[Trusted Node policy](./CM-Configuration-Management/policy-trusted-node.yaml) | Use the trusted node policy to detect if there are untrusted or unattested nodes in the cluster. | [Trusted Node Policy Controller](https://github.com/lumjjb/trusted-node-policy-controller)
[ETCD Backup](./CM-Configuration-Management/policy-etcd-backup.yaml) | Use the ETCD Backup policy to receive the last six backup snapshots for etcd. This policy uses the etcd container image in the policy because it contains all required tools like etcdctl. | For more information, see [OpenShift 4 with default storage class](https://docs.openshift.com/container-platform/4.5/storage/dynamic-provisioning.html).
[Integrity Shield](./CM-Configuration-Management/policy-integrity-shield.yaml)| Use the Integrity Shield to protect the integrity of Kubernetes resources in a cluster (e.g. OpenShift). | See the [Integrity Shield documentation.](https://github.com/open-cluster-management/integrity-shield/blob/master/docs/ACM/README_ENABLE_ISHIELD_PROTECTION_ACM_ENV.md)
[Integrity Shield Events](./CM-Configuration-Management/policy-integrity-shield-events.yaml)| Use the Integrity Shield Events policy to show a status, which represents whether Integrity Shield has denied some requests in a cluster or not. | See the [Integrity Shield documentation.](https://github.com/open-cluster-management/integrity-shield/blob/master/docs/ACM/README_SHOW_INTEGRITY_STATUS_ON_ACM_UI.md)
[PolicyReport failures](./CM-Configuration-Management/policy-check-reports.yaml)| The `policy-check-reports` policy searches for any PolicyReport resources that contain failures in the results. | An example of a tool that creates PolicyReports is [Kyverno](ihttps://kyverno.io/).
[Kyverno sample policy](./CM-Configuration-Management/policy-kyverno-sample.yaml) | Use the Kyverno sample policy to view an example of how a kyverno policy can be applied to a managed cluster. This policy is evaluated by the kyverno controller on a managed cluster. | See the [Installation instructions](https://kyverno.io/docs/installation/#install-kyverno-using-yamls) and [How to write Kyverno policies](https://kyverno.io/docs/writing-policies). **Note**: Kyverno must be installed on managed cluster to use Kyverno policy.

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
[OpenShift Certificate Expiration Policy](./SC-System-and-Communications-Protection/policy-ocp4-certs.yaml) | Monitor the OpenShift 4.x namespaces to validate that certificates managed by the infrastructure are rotated as expected. | OpenShift 4

### System and Information Integrity

Policy  | Description | Prerequisites
------- | ----------- | -------------
[Falco Cloud-Native runtime security](./SI-System-and-Information-Integrity/policy-falco.yaml) | Falco parses Linux system calls from the kernel at runtime, and asserts the stream against a powerful rules engine. If a rule is violated a Falco alert is triggered. | [The Falco Project](https://falco.org/)
[Sysdig Agent](./SI-System-and-Information-Integrity/policy-sysdig.yaml) | The Sysdig Secure DevOps Platform converges security and compliance with performance and capacity monitoring to create a secure DevOps workflow. It uses the same data to monitor and secure, so you can correlate system activity with Kubernetes services. | Check [Sysdig](https://sysdig.com/) and start a [Free Trial](https://go.sysdig.com/rhacm-trial).


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
