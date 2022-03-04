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
- [Templatized Policies](#templatized-policies)

### Access Control

Policy  | Description                                                                                                                                                                                                            | Prerequisites
------- |------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| -------------
[Disallowed roles policy](./AC-Access-Control/policy-roles-no-wildcards.yaml) | Use the disallowed roles policy to make sure no pods are being granted full access in violation of least privilege.                                                                                                    | Check [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) to learn more about Kubernetes RBAC authorization.
[Disallowed anonymous authentication](./AC-Access-Control/policy-gatekeeper-disallow-anonymous.yaml) | Use the disallowed anonymous authentication policy to make sure that the system:anonymous user and system:unauthenticated group are not associated with any ClusterRole / Role in the environment                      | See the [Gatekeeper documentation](https://github.com/open-policy-agent/gatekeeper). **Note**: Gatekeeper controllers must be installed to use the gatekeeper policy.
[Configure RBAC for Application workloads ](./AC-Access-Control/policy-configure-appworkloads-rbac-sample.yaml) | Use this policy to configure a role based access control model for application workloads running on managed-clusters. This is a sample policy.                                                                         | This sample policy must be modified for your environment. Check [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) to learn more about Kubernetes RBAC authorization.
[Configure RBAC for Administering  policies ](./AC-Access-Control/policy-rbac-adminiterpolicies-sample.yaml) | Use this policy to configure a role based access control model on the hub for administering policies in a multi team environment.                                                                                      | Check [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) to learn more about Kubernetes RBAC authorization.
[Configure RBAC using groups in openshift for hub and managed clusters using admin and view-only roles ](./AC-Access-Control/policy-configure-clusterlevel-rbac.yaml) | Use this policy to configure a role based access control model on the hub to have a view-only access to desired managed clusters along with admin access to hub cluster based on groups to which the users belongs to. |  This sample policy must be modified for your environment, Check [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)  to learn more about Kubernetes RBAC authorization.

### Awareness and Training

Policy  | Description | Prerequisites
------- | ----------- | -------------
No policies yet       |  |

### Audit and Accountability

Policy  | Description | Prerequisites
------- | ----------- | -------------
[Example of configuring audit logging with a policy](./AU-Audit-and-Accountability/policy-openshift-audit-logs-sample.yaml) | Use `policy-openshift-audit-logs-sample.yaml` policy to configure audit logging in your OpenShift cluster. For example, you can deploy the policy to configure Elasticsearch to store the audit logs data and view them on Kibana console. | See the [OpenShift Documentation](https://docs.openshift.com/container-platform/latest/logging/cluster-logging.html). This policy is only valid for OpenShift 4.6.x and needs to be adjusted for the proper environment.

### Security Assessment and Authorization

Policy  | Description | Prerequisites
------- | ----------- | -------------
[Install Upstream Compliance Operator policy](./CA-Security-Assessment-and-Authorization/policy-compliance-operator-install-upstream.yaml) | Use the upstream compliance operator installation, `policy-comp-operator` policy, to enable continuous compliance monitoring for your cluster. After you install this operator, you must select what benchmark you want to comply to, and create the appropriate objects for the scans to be run. | See [Compliance Operator](https://github.com/openshift/compliance-operator) for more details.
[Check Fips-Compliance](./CA-Security-Assessment-and-Authorization/policy-check-fips.yaml) | Use this policy to check if a Cluster has FIPS-Compliance-Enabled. | This policy is only valid for OpenShift 4.6+. Read [here](https://docs.openshift.com/container-platform/latest/installing/installing-fips.html) for more information
[Remove Kubeadmin](./SC-System-and-Communications-Protection/policy-remove-kubeadmin.yaml) | Use this policy to remove the Kubeadmin-User from selected Clusters | This policy is only valid for OpenShift 4.x Clusters

### Configuration Management

Policy  | Description | Prerequisites
------- | ----------- | -------------
[Upgrade OpenShift-Cluster Sample policy](./CM-Configuration-Management/policy-upgrade-openshift-cluster.yaml) | Use this policy as an example for upgrading OpenShift clusters with a policy. | OpenShift 4.x is required. In the provided example, a version 4.7 cluster is upgraded to version 4.7.18. Change the `channel` and the `desired version` if you want to upgrade other versions.
[Egress sample policy](./CM-Configuration-Management/policy-egress-firewall-sample.yaml) | With the egress firewall you can define rules (per-project) to allow or deny traffic (TCP-or UDP) to the external network. | OpenShift 4.x is required. See the [OpenShift Security Guide.](https://access.redhat.com/articles/5059881) Use the OpenShift Security Guide to secure your OpenShift cluster.
[Example of configuring a cluster-wide proxy with a policy](./CM-Configuration-Management/policy-cluster-proxy-sample.yaml) | Use this policy to configure a cluster-wide proxy. | OpenShift 4.x is required. See the [OpenShift Documentation.](https://docs.openshift.com/container-platform/latest/security/encrypting-etcd.html) This policy is only valid for OpenShift 4.x and needs to be adjusted for the proper environment. You should not include passwords in a policy. Use the [templatized policy feature in RHACM 2.3](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.3/html/governance/governance#support-templates-in-config-policies) to avoid including the proxy password in the policy.
[Example of configuring DNS with a policy](./CM-Configuration-Management/policy-cluster-dns-sample.yaml) | Use this policy to configure DNS in your OpenShift cluster. For example, you can remove public DNS. | OpenShift 4.x is required. See the [OpenShift Documentation](https://docs.openshift.com/container-platform/latest/post_installation_configuration/network-configuration.html#private-clusters-setting-dns-private_post-install-network-configuration) This policy is only valid for OpenShift 4.x and needs to be adjusted for the proper environment.
[Example of configuring the Cluster Network Operator with a policy](./CM-Configuration-Management/policy-cluster-network-sample.yaml) | Use this policy to configure the network of your OpenShift cluster. | OpenShift 4.x is required. See the [OpenShift Documentation.](https://docs.openshift.com/container-platform/latest/post_installation_configuration/network-configuration.html#nw-operator-cr_post-install-network-configuration) This policy is only valid for OpenShift 4.x and needs to be adjusted for the proper environment.
[Example of creating a deployment object](./CM-Configuration-Management/policy-nginx-deployment.yaml) | This example generates 3 replicas of \`nginx-pods\`. | See the [Kubernetes Documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) to learn more about Deployments.
[Example of a policy used to configure GitHub-Authentication](./CM-Configuration-Management/policy-github-oauth-sample.yaml) | Use this policy to log in to your OpenShift cluster with GitHub-Authentication. | OpenShift 4.x is required. See the OpenShift Documentation, [Configuring a GitHub or GitHub Enterprise identify provider](https://docs.openshift.com/container-platform/latest/authentication/identity_providers/configuring-github-identity-provider.html) to learn more information about identity providers. You must modify the contents of this policy so that it is applicable to your environment.
[Example of installing Performance Addon Operator](./CM-Configuration-Management/policy-pao-operator.yaml) | Use this policy to install the Performance Addon Operator, which provides the ability to enable advanced node performance tunings on a set of nodes. | OpenShift 4.x is required. See the [RHACM & Performance Addon Operator repository documentation](https://github.com/alosadagrande/acm-cnf/tree/master/acm-manifests/performance-operator) for more details.
[Example of installing PTP Operator](./CM-Configuration-Management/policy-ptp-operator.yaml) | Use this policy to install the Precision Time Protocol (PTP) Operator, which creates and manages the linuxptp services on a set of OpenShift nodes. | OpenShift 4.x is required. See the [RHACM & PTP Operator repository documentation](https://github.com/alosadagrande/acm-cnf/tree/master/acm-manifests/ptp) for more details.
[Example of installing SR-IOV Network Operator](./CM-Configuration-Management/policy-sriov-operator.yaml) | Use this policy to install the Single Root I/O Virtualization (SR-IOV) Network Operator, which manages the SR-IOV network devices and network attachments in your clusters. | OpenShift 4.x is required. See the [RHACM & SR-IOV Network Operator repository documentation](https://github.com/alosadagrande/acm-cnf/tree/master/acm-manifests/sriov-operator) for more details.
[Example of labeling nodes of a cluster](./CM-Configuration-Management/policy-label-worker-nodes.yaml) | Use this policy to label nodes in your managed clusters. Notice you must know the name of the node or nodes to label. | OpenShift 4.x is required. See the [OpenShift Documentation](https://docs.openshift.com/container-platform/latest/nodes/nodes/nodes-nodes-working.html#nodes-nodes-working-updating_nodes-nodes-working) to learn more about labelling objects.
[Example to configure an image policy](./CM-Configuration-Management/policy-image-policy-sample.yaml) | Use the image policy to define the repositories from where OpenShift can pull images. | OpenShift 4.x is required. Refer to the chapter named *Container Image Security* in the [OpenShift Security Guide.](https://access.redhat.com/articles/5059881) for more information. You must customize the contents of this policy.
[Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml) | Use the Gatekeeper operator policy to install the community version of Gatekeeper on a managed cluster. | See the [Gatekeeper Operator](https://github.com/gatekeeper/gatekeeper-operator).
[Gatekeeper config exclude namespaces](./CM-Configuration-Management/policy-gatekeeper-config-exclude-namespaces.yaml) | Use the Gatekeeper policy to exclude namespaces from certain processes for all constraints in the cluster | See the gatekeeper documentation [exempting-namespaces-from-gatekeeper](https://open-policy-agent.github.io/gatekeeper/website/docs/exempt-namespaces) for more information. **Note**: Gatekeeper controllers must be installed to use the gatekeeper policy. See the [Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml).
[Gatekeeper container image with the latest tag](./CM-Configuration-Management/policy-gatekeeper-container-image-latest.yaml) | Use the Gatekeeper policy to enforce containers in deployable resources to not use images with the _latest_ tag. | See the [Gatekeeper documentation](https://github.com/open-policy-agent/gatekeeper). **Note**: Gatekeeper controllers must be installed to use the gatekeeper policy. See the [Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml).
[Gatekeeper liveness probe not set](./CM-Configuration-Management/policy-gatekeeper-container-livenessprobenotset.yaml) | Use this Gatekeeper policy to make sure pods have a [liveness probe.](https://docs.openshift.com/container-platform/latest/applications/application-health.html) | See the [Gatekeeper documentation](https://github.com/open-policy-agent/gatekeeper). **Note**: Gatekeeper controllers must be installed to use the gatekeeper policy. See the [Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml).
[Gatekeeper readiness probe not set](./CM-Configuration-Management/policy-gatekeeper-container-readinessprobenotset.yaml) | Use this Gatekeeper policy to make sure pods have a [readiness probe.](https://docs.openshift.com/container-platform/latest/applications/application-health.html) | See the [Gatekeeper documentation](https://github.com/open-policy-agent/gatekeeper). **Note**: Gatekeeper controllers must be installed to use the gatekeeper policy. See the [Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml).
[Gatekeeper allowed external IPs](./CM-Configuration-Management/policy-gatekeeper-allowed-external-ips.yaml) | Use the Gatekeeper allowed external IPs policy to define external IPs that can be specified by `Services`. | See the [Gatekeeper](https://github.com/open-policy-agent/gatekeeper). **Note**: Gatekeeper controllers must be installed to use the gatekeeper policy. See the [Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml).
[Gatekeeper sample policy](./CM-Configuration-Management/policy-gatekeeper-sample.yaml) | Use the Gatekeeper sample policy to view an example of how a gatekeeper policy can be applied to a managed cluster. This sample requires a `gatekeeper` label to be applied to a list of namespaces. | See the [Gatekeeper](https://github.com/open-policy-agent/gatekeeper). **Note**: Gatekeeper controllers must be installed to use the gatekeeper policy. See the [Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml).
[Gatekeeper mutation policy (owner annotation)](./CM-Configuration-Management/policy-gatekeeper-annotation-owner.yaml) | Use the Gatekeeper mutation policy to set the owner annotation on pods. | See the [Gatekeeper](https://github.com/open-policy-agent/gatekeeper). **Note**: Gatekeeper controllers must be installed to use the gatekeeper policy. See the [Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml). You must enable [*mutatingWebhook*](https://github.com/stolostron/policy-collection/blob/3d6775a7ddcc007d313421c1fcc25c1fbdf28fdd/community/CM-Configuration-Management/policy-gatekeeper-operator.yaml#L111) to use the gatekeeper mutation feature.
[Gatekeeper mutation policy (image pull policy)](./CM-Configuration-Management/policy-gatekeeper-image-pull-policy.yaml) | Use the Gatekeeper mutation policy to set or update image pull policy on pods. | See the [Gatekeeper](https://github.com/open-policy-agent/gatekeeper). **Note**: Gatekeeper controllers must be installed to use the gatekeeper policy. See the [Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml). You must enable [*mutatingWebhook*](https://github.com/stolostron/policy-collection/blob/3d6775a7ddcc007d313421c1fcc25c1fbdf28fdd/community/CM-Configuration-Management/policy-gatekeeper-operator.yaml#L111) to use the gatekeeper mutation feature.
[Gatekeeper mutation policy (termination GracePeriodSeconds)](./CM-Configuration-Management/policy-gatekeeper-container-tgps.yaml) | Use the Gatekeeper mutation policy to set or update the termination grace period seconds on pods. | See the [Gatekeeper](https://github.com/open-policy-agent/gatekeeper). **Note**: Gatekeeper controllers must be installed to use the gatekeeper policy. See the [Gatekeeper operator policy](./CM-Configuration-Management/policy-gatekeeper-operator.yaml). You must enable [*mutatingWebhook*](https://github.com/stolostron/policy-collection/blob/3d6775a7ddcc007d313421c1fcc25c1fbdf28fdd/community/CM-Configuration-Management/policy-gatekeeper-operator.yaml#L111) to use the gatekeeper mutation feature.
[MachineConfig Chrony sample policy](./CM-Configuration-Management/policy-machineconfig-chrony.yaml) | Use the MachineConfig Chrony policy to configure _/etc/chrony.conf_ on certain machines. | OpenShift 4.x is required. For more information see, [Modifying node configurations in OpenShift 4.x blog](https://jaosorior.dev/2019/modifying-node-configurations-in-openshift-4.x/).
[Network-Policy-Samples](./CM-Configuration-Management/policy-network-policy-samples.yaml) | Use the Network policy to specify how groups of pods are allowed to communicate with each other and with other network endpoints. | See the [OpenShift Security Guide](https://access.redhat.com/articles/5059881). **Note**: The policy might be modified to the actual usecases.
[OPA sample policy](./CM-Configuration-Management/policy-opa-sample.yaml) | Use the Open Policy Agent (OPA) Sample policy to view an example of how an OPA policy can be created. You can also view an example of adding a _REGO_ script into a ConfigMap, which is evaluated by the OPA. | See the [OPA example repository](https://github.com/ycao56/mcm-opa). **Note**: OPA must be installed to use the OPA ConfigMap policy.
[Trusted Container policy](./CM-Configuration-Management/policy-trusted-container.yaml) | Use the trusted container policy to detect if running pods are using trusted images. | This policy requires a custom controller to be deployed. See the [Trusted Container Policy Controller](https://github.com/ycao56/trusted-container-policy-controller) for details on the custom controller.
[Trusted Node policy](./CM-Configuration-Management/policy-trusted-node.yaml) | Use the trusted node policy to detect if there are untrusted or unattested nodes in the cluster. | This policy requires a custom controller to be deployed. See the [Trusted Node Policy Controller](https://github.com/lumjjb/trusted-node-policy-controller) for details on the custom controller.
[ETCD Backup](./CM-Configuration-Management/policy-etcd-backup.yaml) | Use the ETCD Backup policy to receive the last six backup snapshots for etcd. This policy uses the etcd container image in the policy because it contains all required tools like etcdctl. | OpenShift 4.x is required. For more information, see [OpenShift 4 with default storage class](https://docs.openshift.com/container-platform/latest/storage/dynamic-provisioning.html).
[Integrity Shield](./CM-Configuration-Management/policy-integrity-shield.yaml)| Use the Integrity Shield to protect the integrity of Kubernetes resources in a cluster (e.g. OpenShift). | See the [Integrity Shield documentation.](https://github.com/stolostron/integrity-shield/blob/master/docs/ACM/README_ENABLE_ISHIELD_PROTECTION_ACM_ENV.md)
[Integrity Shield Events](./CM-Configuration-Management/policy-integrity-shield-events.yaml)| Use the Integrity Shield Events policy to show a status, which represents whether Integrity Shield has denied some requests in a cluster or not. | See the [Integrity Shield documentation.](https://github.com/stolostron/integrity-shield/blob/master/docs/ACM/README_SHOW_INTEGRITY_STATUS_ON_ACM_UI.md)
[Integrity Shield Observer](./CM-Configuration-Management/policy-integrity-shield-observer.yaml)| Integrity Shield Observer continuously verifies Kubernetes resource on cluster according ManifestIntegrityConstraint resources and exports the results to resources called ManifestIntegrityState. This policy is used to alert on any resource signature violations that have been identified by the observer. | This policy does not install Integrity Shield. This policy does require Integrity Shield to already be installed. See the [Integrity Shield documentation.](https://github.com/stolostron/integrity-shield/blob/master/docs/ACM/README_SHOW_INTEGRITY_STATUS_ON_ACM_UI.md)
[v1alpha2 PolicyReport failures](./CM-Configuration-Management/policy-check-policyreports.yaml)| This policy searches for any `PolicyReport` resources that contain failures in the results. | An example of a tool that creates `PolicyReports` is [Kyverno](https://kyverno.io/). Be aware that the `PolicyReports` API is an alpha API and multiple versions may be available. A policy using the `v1alpha1` API is [v1alpha1 PolicyReport failures](./CM-Configuration-Management/policy-check-reports.yaml).
[Kyverno sample policy](./CM-Configuration-Management/policy-kyverno-sample.yaml) | Use the Kyverno sample policy to view an example of how a kyverno policy can be applied to a managed cluster. This policy is evaluated by the kyverno controller on a managed cluster. This policy requires all pods to have a certain label defined. Note that you cannot create pods that do not have this label if you apply this policy. | See the [Installation instructions](https://kyverno.io/docs/installation/#install-kyverno-using-yamls) and [How to write Kyverno policies](https://kyverno.io/docs/writing-policies). **Note**: Kyverno must be installed on the managed clusters to use the Kyverno policy.
[OpenShift Kernel Configuration](./CM-Configuration-Management/policy-kernel-devel.yaml) | Use this policy to create OpenShift 4 machine configurations that install kernel development packages. The kernel development packages are needed for the Sysdig and Falco agents to integrate into the host kernel. | This policy is only valid for OpenShift 4.x.
[Volsync Persistent Data Replication](./CM-Configuration-Management/policy-persistent-data-management.yaml) | Use this policy to deploy the Volsync controller. Once the controller has been deployed, replication source and replication destination objects can be created allowing for persistent volume claims to be replicated. | See the [VolSync Replication](https://volsync.readthedocs.io) documentation for more information.
[Setup-Subscription-Admin](./CM-Configuration-Management/policy-configure-subscription-admin-hub.yaml) | Use this policy to activate the Subscription-Admin feature in RHACM | See this Solution for more information about this feature [https://access.redhat.com/solutions/6010251](https://access.redhat.com/solutions/6010251)
[Configure-Logforwarding](./CM-Configuration-Management/policy-configure-logforwarding.yaml) | Use this policy to configure Logforwarding. | OpenShift 4.x is required. See this [blog](https://www.openshift.com/blog/implement-policy-based-governance-using-configuration-management-of-red-hat-advanced-cluster-management-for-kubernetes) for more information about this example
[Install OpenShift-Update-Service](./CM-Configuration-Management/policy-update-service-openshift-cluster.yaml) | Use this policy to install the OpenShift Update Service. | This policy is only valid for OpenShift 4.6+. Read the [documentation](https://docs.openshift.com/container-platform/latest/updating/installing-update-service.html#installing-update-service) for more information
[Install OpenShift-Gitops](./CM-Configuration-Management/policy-openshift-gitops.yaml) | Use this policy to install the Red Hat OpenShift GitOps operator which can be used to install and configure Gitops, Tekton and ArgoCD | Requires OpenShift 4.x. Check the [documentation](https://docs.openshift.com/container-platform/latest/cicd/gitops/gitops-release-notes.html) for more information.
[Configure OpenShift Image-Pruner](./CM-Configuration-Management/policy-resiliency-image-pruner.yaml) | Use this policy to configure the OpenShift Image-Pruner | OpenShift 4.x is required. Check the [documentation](https://docs.openshift.com/container-platform/latest/applications/pruning-objects.html) for more information
[Policy to configure a POD Disruption Budget](./CM-Configuration-Management/policy-engineering-pod-disruption-budget.yaml) | use this policy to configure a Pod Disruption Budget|     Check Kubernetes [documentation](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) for more information
[Policy to configure a cluster autoscaler](./CM-Configuration-Management/policy-autoscaler.yaml) | Use this policy to configure a `ClusterAutoscaler`. | OpenShift 4.x is required. Check the OpenShift [documentation](https://docs.openshift.com/container-platform/latest/post_installation_configuration/cluster-tasks.html#informational-resources_post-install-cluster-tasks) for more information.
[Policy to configure Ingress Controller](./CM-Configuration-Management/policy-ingress-controller.yaml) | Use this policy to configure the IngressController |  OpenShift 4.x is required. Check the OpenShift [documentation](https://docs.openshift.com/container-platform/latest/post_installation_configuration/cluster-tasks.html#informational-resources_post-install-cluster-tasks) for more information on how to customize this policy.
[Policy to configure the Scheduler](./CM-Configuration-Management/policy-scheduler.yaml) | Use this policy to configure the OpenShift Scheduler | OpenShift 4.x is required. Check OpenShift [documentation](https://docs.openshift.com/container-platform/latest/post_installation_configuration/cluster-tasks.html#configuration-resources_post-install-cluster-tasks) for more information
[Policy to install the Red Hat Single Sign-On Operator](./CM-Configuration-Management/policy-rhsso-operator.yaml) | Use this policy to install the Red Hat Single Sign-On Operator| OpenShift 4.x is required. Check the [documentation](https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html/server_installation_and_configuration_guide/operator) for more information
[Policy to install External-Secrets](./CM-Configuration-Management/policy-install-external-secrets.yaml) | Use this policy to install External Secrets. Kubernetes External Secrets allows you to use external secret management systems, like AWS Secrets Manager or HashiCorp Vault, to securely add secrets in Kubernetes. | Check the [documentation](https://github.com/external-secrets/kubernetes-external-secrets) and this [solution](https://access.redhat.com/solutions/6184721) for more information.
[Policy to install the Red Hat Advanced Cluster Security Central Server](./CM-Configuration-Management/policy-acs-operator-central.yaml) | Use this policy to install the Red Hat Advanced Cluster Security operator to the Open Cluster Management hub and install the Central Server to the `stackrox` namespace. | OpenShift 4.x is required. For more information on Red Hat Advanced Cluster Security, visit [Red Hat Advanced Cluster Security for Kubernetes](https://www.openshift.com/products/kubernetes-security)
[Policy to install the Red Hat Advanced Cluster Security Secure Cluster Services](./CM-Configuration-Management/policy-acs-operator-secured-clusters.yaml) | Use this policy to install the Red Hat Advanced Cluster Security operator to all OpenShift managed clusters and install the Secure Cluster Services to the `stackrox` namespace. | OpenShift 4.x is required. For more information on Red Hat Advanced Cluster Security, visit [Red Hat Advanced Cluster Security for Kubernetes](https://www.openshift.com/products/kubernetes-security). This policy requires policy template support to be available in Red Hat Advanced Cluster Management for Kubernetes version 2.3. See [advanced-cluster-security](https://github.com/stolostron/advanced-cluster-security) for additional prerequisites needed for installing this policy.
[Policy to install `cert-manager`](./CM-Configuration-Management/policy-cert-manager-operator.yaml) | Use this policy to deploy the community operator for `cert-manager` which installs `cert-manager` on OpenShift clusters. | For more information on `cert-manager` visit [Cloud native certificate management](https://cert-manager.io/)
[Policy to label a Managed-Cluster](./CM-Configuration-Management/policy-label-cluster.yaml) | Use this policy to label a Managed-Cluster | Open Cluster Management is required. This policy needs to be applied on the Managing-Cluster, adjust the labels to your needs
[Policy to set a Config-Map with properties for different environments](./CM-Configuration-Management/policy-engineering-configmap.yaml) | Use this policy to configure a policy for different environments | Adjust this example for your needs
[Policy to install Local Storage Operator](./CM-Configuration-Management/policy-odf.yaml) | Use this policy to install and configure the Local Storage Operator | adjust the LocalVolumeSet and StorageClass for your needs
[Policy to define a Custom CatalogSource](./CM-Configuration-Management/policy-custom-catalog.yaml) | Use this policy to configure or patch a Custom CatalogSource | OpenShift 4.x is required. Consult the [documentation](https://docs.openshift.com/container-platform/latest/operators/admin/olm-managing-custom-catalogs.html) for more information
[Policy to install the ansible-awx-operator](./CM-Configuration-Management/policy-ansible-awx-operator.yaml) | Use this policy to configure the `ansible-awx-operator` to allow `AnsibleJobs` to be processed. | **Archived**: This policy is needed for Ansible integration on OpenShift 4.8 and older. Use the [Ansible Automation Platform operator](./CM-Configuration-Management/policy-automation-operator.yaml) policy as a replacement for this operator.
[Policy to install the Ansible Automation Platform operator](./CM-Configuration-Management/policy-automation-operator.yaml) | Use this policy to install Ansible Automation Platform | Requires OpenShift 4.x. This operator is needed to process `AnsibleJobs`. See the [Red Hat Ansible Automation Platform](https://red.ht/AAP-20) for more details.
[Policy to configure ClusterLogForwarding using Template-Feature](./CM-Configuration-Management/policy-cluster-logforwarder-templatized.yaml) | Use this policy to configure ClusterLogForwarding to send audit logs to a Kafka-Topic. | Every Cluster gets it's own topic because of the new Templatized-Feature. To validate the configuration, run the following command: ```oc get ClusterLogForwarder instance -n openshift-logging -oyaml```. The minimum prerequisites are OpenShift 4.6 and RHACM 2.3
[Policy to setup ODF](./CM-Configuration-Management/policy-odf.yaml) | Use this policy to install and configure the OpenShift Data Foundation | making it work would require e.g. on AWS m5 instances would be required. Requires OpenShift 4.6 or later.
[Policy to install Kyverno](./CM-Configuration-Management/policy-install-kyverno.yaml) | Use this policy to install Kyverno | Consult the following [link](https://github.com/kyverno) to get more information about Kyverno.
[Kyverno config exclude resources](./CM-Configuration-Management/policy-kyverno-config-exclude-resources.yaml) | Use this Kyverno policy to exclude resources from certain processes for all constraints in the cluster | See the [Resource Filters](https://kyverno.io/docs/installation/#resource-filters) from the Kyverno documentation. **Note**: Kyverno controller must be installed to use the kyverno policy. See [Policy to install Kyverno](./CM-Configuration-Management/policy-install-kyverno.yaml).
[Kyverno mutation policy (image pull policy)](./CM-Configuration-Management/policy-kyverno-image-pull-policy.yaml) | Use the Kyverno mutation policy to set or update the image pull policy on pods | See the [Kyverno project](https://github.com/kyverno/kyverno). **Note**: Kyverno controller must be installed to use the kyverno policy. See the [Policy to install Kyverno](./CM-Configuration-Management/policy-install-kyverno.yaml).
[Kyverno mutation policy (termination GracePeriodSeconds)](./CM-Configuration-Management/policy-kyverno-container-tgps.yaml) | Use the Kyverno mutation policy to set or update the termination grace period seconds on pods | See the [Kyverno project](https://github.com/kyverno/kyverno). **Note**: Kyverno controller must be installed to use the kyverno policy. See the [Policy to install Kyverno](./CM-Configuration-Management/policy-install-kyverno.yaml).
[Kyverno Generate Network Policies](./CM-Configuration-Management/policy-kyverno-add-network-policy.yaml) | Configures a new `NetworkPolicy` resource named `default-deny` which will deny all traffic anytime a new Namespace is created. | See the [Kyverno project](https://github.com/kyverno/kyverno). **Note**: Kyverno controller must be installed to use the kyverno policy. See the [Policy to install Kyverno](./CM-Configuration-Management/policy-install-kyverno.yaml).
[Kyverno Generate Quota](./CM-Configuration-Management/policy-kyverno-add-quota.yaml) | Configures new `ResourceQuota` and `LimitRange` resources anytime a new Namespace is created. | See the [Kyverno project](https://github.com/kyverno/kyverno). **Note**: Kyverno controller must be installed to use the kyverno policy. See the [Policy to install Kyverno](./CM-Configuration-Management/policy-install-kyverno.yaml).
[Kyverno Sync Secrets](./CM-Configuration-Management/policy-kyverno-sync-secrets.yaml) | This policy will copy a Secret called `regcred` which exists in the `default` Namespace to new Namespaces when they are created and it will keep the secret updated with changes. | See the [Kyverno project](https://github.com/kyverno/kyverno). **Note**: Kyverno controller must be installed to use the kyverno policy. See the [Policy to install Kyverno](./CM-Configuration-Management/policy-install-kyverno.yaml).
[Policy to install ArgoCD on Non-OpenShift Clusters](./CM-Configuration-Management/policy-argocd-kubernetes.yaml) | Use this policy to install ArgoCD on Kubernetes. | This policy deploys ArgoCD as a Helm Chart and can be applied to non OpenShift clusters.
[Policy to create a CronJob installing oc-client](./CM-Configuration-Management/policy-oc-client-cronjob.yaml) | Use this policy to execute custom commands using oc-client | There are several examples where you might need to setup custom commands. You must customize the commands you want to run in the policy. To learn more visit [Kubernetes CronJob documentation](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)
[Scan your cluster with the OpenShift Moderate security profile](./CM-Configuration-Management/policy-compliance-operator-moderate-scan.yaml) | This example creates a `ScanSettingBinding` that the Compliance Operator uses to scan the cluster for compliance with the OpenShift FedRAMP Moderate benchmark. | The Compliance Operator can only scan OpenShift nodes. For more details, visit: [Understanding the Compliance Operator](https://docs.openshift.com/container-platform/latest/security/compliance_operator/compliance-operator-understanding.html).
[Policy to customize OpenShift OAuth tokens](./CM-Configuration-Management/policy-oauth-config.yaml) | Use this policy to configure the OpenShift tokens to expire after a set period of inactivity. | OpenShift 4.x is required. For more information on configuring the OAuth clients, see the OpenShift documentation: [Configurating the internal oauth Server](https://docs.openshift.com/container-platform/latest/authentication/configuring-internal-oauth.html)
[Policy to install IDP operator](./CM-Configuration-Management/policy-idp-operator.yaml) | Use this policy to install Identity configuration management operator. | For more information on this operator, see the [IDP documentation](https://identitatem.github.io/idp-mgmt-docs/). NOTE: See the [IDP requirements and recommendations](https://identitatem.github.io/idp-mgmt-docs/requirements.html#requirements-and-recommendations) before using this policy.
[Policy to configure Github identity provider in IDP ](./CM-Configuration-Management/policy-idp-sample-github.yaml) | Use this policy to apply Github OAuth to managed clusters through IDP . | For more information on this operator, see the IDP documentation: [Identity configuration management for Kubernetes](https://identitatem.github.io/idp-mgmt-docs/). NOTE: IDP Operator must be installed before using this policy.
[Policy to install the OpenShift File Integrity operator](./CM-Configuration-Management/policy-file-integrity-operator.yaml) | Use the *File Integrity Operator* to continually run file integrity checks on the cluster nodes. This policy becomes `NonCompliant` when a `FileIntegrityNodeStatus` returns a status of `Failed`, which indicates files on the nodes have changed. | OpenShift 4.x is required. See [Understanding the File Integrity Operator](https://docs.openshift.com/container-platform/latest/security/file_integrity_operator/file-integrity-operator-understanding.html) for more details.

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
[OpenShift Certificate Expiration Policy](./SC-System-and-Communications-Protection/policy-ocp4-certs.yaml) | Monitor the OpenShift 4.x namespaces to validate that certificates managed by the infrastructure are rotated as expected. | OpenShift 4.x is required.
[OpenShift Cluster Operator state policy](./SC-System-and-Communications-Protection/policy-checkclusteroperator.yaml) | This policy alerts when an OpenShift `ClusterOperator` becomes unhealthy. See [ClusterOperator config](https://docs.openshift.com/container-platform/latest/rest_api/config_apis/clusteroperator-config-openshift-io-v1.html) for additional details. | OpenShift 4.x only.

### System and Information Integrity

Policy  | Description | Prerequisites
------- | ----------- | -------------
[Falco Cloud-Native runtime security Operator install](./SI-System-and-Information-Integrity/policy-falco.yaml) | Falco parses Linux system calls from the kernel at runtime, and asserts the stream against a powerful rules engine. If a rule is violated, a Falco alert is triggered. | **Archived**: Install Falco using the [Falco helm install](./SI-System-and-Information-Integrity/policy-falco-helm.yaml) since the [operator](https://github.com/sysdiglabs/falco-operator) is not being updated. [The Falco Project](https://falco.org/). If the agent fails to integrate with an OpenShift host kernel, install the policy [OpenShift Kernel Configuration](./CM-Configuration-Management/policy-kernel-devel.yaml).
[Falco Cloud-Native runtime security Helm install](./SI-System-and-Information-Integrity/policy-falco-helm.yaml) | Falco parses Linux system calls from the kernel at runtime, and asserts the stream against a powerful rules engine. If a rule is violated, a Falco alert is triggered. | [The Falco Project](https://falco.org/). If the agent fails to integrate with an OpenShift 4.x host kernel, install the policy [OpenShift Kernel Configuration](./CM-Configuration-Management/policy-kernel-devel.yaml).
[OpenShift Auditing for Falco](./SI-System-and-Information-Integrity/policy-falco-auditing.yaml) | Falco can also parse Kubernetes audit events and trigger alerts when auditing rules are violated. Use this policy to enable sending audit events to falco on OpenShift clusters. | [The Falco Project](https://falco.org/).
[Sysdig Agent](./SI-System-and-Information-Integrity/policy-sysdig.yaml) | The Sysdig Secure DevOps Platform converges security and compliance with performance and capacity monitoring to create a secure DevOps workflow. It uses the same data to monitor and secure, so you can correlate system activity with Kubernetes services. | Check [Sysdig](https://sysdig.com/) and start a [Free Trial](https://go.sysdig.com/rhacm-trial). If the agent fails to integrate with an OpenShift 4.x host kernel, install the [OpenShift Kernel Configuration](./CM-Configuration-Management/policy-kernel-devel.yaml) policy.
[Black Duck Connector](./SI-System-and-Information-Integrity/policy-blackduck.yaml) | By integrating Black Duck with Kubernetes and OpenShift, you can automatically scan, identify, and monitor all your container images to gain visibility into, and control over, any security vulnerabilities or policy violations found in the open source code that exists in your containers. | Check out [Black Duck for OpenShift](https://www.synopsys.com/software-integrity/partners/red-hat.html) and [read more](https://www.synopsys.com/software-integrity/security-testing/software-composition-analysis/demo.html).

### Templatized Policies 

The following sample policies demonstrate the use of templatization feature to build flexible policies

Policy  | Description | Prerequisites
------- | ----------- | -------------
[Configure Deployment](./CM-Configuration-Management/policy-nginx-deployment-templatized.yaml) | Configures nginx deployment resource customized to the target cluster based on contents of resources on the target managedcluster , template-type: managedcluster, template-functions : fromClusterClaim, fromSecret, eq, if-else | [Go Templates functions](https://pkg.go.dev/text/template)
[Configure PodDisrution Budget](./CM-Configuration-Management/policy-managedclusterinfo-templatized.yaml) | Configures a pod disruption budget resource with the   values customized based on whether the target managedcluster is labeled a prod environment, template-type: managedcluster, template-functions : lookup, eq, if-else | [Go Templates functions](https://pkg.go.dev/text/template)
[Configure Cluster Info](./CM-Configuration-Management/policy-managedclusterinfo-templatized.yaml) | Configures a clusterinfo configmap  which contains information about the target managedcluster e.g. its ocp-version etc , template-type: managedcluster, template-functions : fromClusterClaim | [Go Templates functions](https://pkg.go.dev/text/template)
[Configure ClusterAutoScaler](./CM-Configuration-Management/policy-autoscaler-templatized.yaml) | Using hub templates configures the ClusterAutoScaler resource with values customized to the target cluster , template-type: hub, template-functions : fromConfigMap, .ManagedClusterName | [Go Templates functions](https://pkg.go.dev/text/template)
[Enable Policy If Namespace exists](./CM-Configuration-Management/policy-enable-if-ns-exists-templatized.yaml) | Demos enabling  one policy from another based on existence of a namespace, template type: managedcluster, template functions : lookup, ne, toBool | [Go Templates functions](https://pkg.go.dev/text/template)
[Enable Policy If EtcdEncryption is set](./CM-Configuration-Management/policy-enable-if-etcd-encrypted-templatized.yaml) | Enables one policy from another based on whether etcd encryption is setup, template type: managedcluster, template functions : lookup, ne, toBool | [Go Templates functions](https://pkg.go.dev/text/template)


## Deploying community policies to your cluster
While the policies in the [stable](../stable) folder all have out-of-the-box support installed with Red Hat Advanced Cluster Management, community policies are maintained by the open source community. You might need to deploy extra policy consumers in order for community policies to work as intended. If you are seeing the error `no matches for kind "<resource name>" in version "<group>/<version>"`, you must deploy the CustomResourceDefinition (CRD) for the policy before you create it. If some of the policies in this folder are not behaving properly, you must deploy the corresponding policy consumers to handle them.

### Custom policy controllers
Custom policy controllers are created from forks of the [sample policy controller repo](https://github.com/stolostron/multicloud-operators-policy-controller), and as such the process for deploying them is essentially the same as the process for deploying the sample controller.
- Run the following command on your cluster to install the CRD for the custom policy: `kubectl apply -f <CRD path>`
- Run the following command to set up the operator and service account that runs the controller on your cluster: `kubectl apply -f deploy/`

### Policy consumers on operator hub
Some policy consumers are packaged as [operators](https://coreos.com/operators/) and are available on the [Operator hub](https://operatorhub.io/). These consumers can simply be deployed by creating a policy with child [configuration policies](https://github.com/stolostron/config-policy-controller) to handle the installation. The configuration policies might include the following information:
- A namespace to deploy the operator on, if necessary
- A ClusterServiceVersion with install capabilities to install the operator from the operator hub
- A OperatorGroup
- A Subscription
- The custom resource defined by the consumer to enforce custom policies
For more specific examples of this method of deploying a policy consumer from the operator hub, see the [Policy to install `cert-manager`](./CM-Configuration-Management/policy-cert-manager-operator.yaml) and the [Ansible Automation Platform operator](./CM-Configuration-Management/policy-automation-operator.yaml).

### Other custom policy consumers
Occasionally, policies in this folder might be consumed by controllers that do not fall into either of the two categories previously mentioned. To get the most out of these policies, see the [Security control catalog](#security-control-catalog)