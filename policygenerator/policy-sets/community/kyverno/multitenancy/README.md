# governance-best-practises-for-apps

repository showing best practices for apps

Based on the following links:

* https://cloud.redhat.com/blog/9-best-practices-for-deploying-highly-available-applications-to-openshift
* https://cloud.redhat.com/blog/14-best-practices-for-developing-applications-on-openshift

## Kyverno best prastices

https://kyverno.io/policies/?policytypes=Best%2520Practices


we look to create a PolicySet based on RHACM-Policies and Kyverno Integration

## List of Policies 


Policy                 | Description 
-----------------------| ----------- 
create-default-pdb     |  A PodDisruptionBudget limits the number of Pods of a replicated application that are down simultaneously from voluntary disruptions. For example, a quorum-based application would like to ensure that the number of replicas running is never brought below the number needed for a quorum. As an application owner, you can create a PodDisruptionBudget (PDB) for each application. This policy will create a PDB resource whenever a new Deployment is created.
scale-deployment-zero  |  If a Deployment's Pods are seen crashing multiple times it usually indicates there is an issue that must be manually resolved. Removing the failing Pods and marking the Deployment is often a useful troubleshooting step. This policy watches existing Pods and if any are observed to have restarted more than once, indicating a potential crashloop, Kyverno scales its parent deployment to zero and writes an annotation signaling to an SRE team that troubleshooting is needed.  It may be necessary to grant additional privileges to the Kyverno ServiceAccount, via one of the existing ClusterRoleBindings or a new one, so it can modify Deployments.
validate-probes       |   Liveness and readiness probes accomplish different goals, and setting both to the same is an anti-pattern and often results in app problems in the future. This policy checks that liveness and readiness probes are not equal. 
require-pod-probes    |   Liveness and readiness probes need to be configured to correctly manage a Pod's lifecycle during deployments, restarts, and upgrades. For each Pod, a periodic `livenessProbe` is performed by the kubelet to determine if the Pod's containers are running or need to be restarted. A `readinessProbe` is used by Services and Deployments to determine if the Pod is ready to receive network traffic. This policy validates that all containers have liveness and readiness probes by ensuring the `periodSeconds` field is greater than zero.
disallow-latest-tag   |   The ':latest' tag is mutable and can lead to unexpected errors if the image changes. A best practice is to use an immutable tag that maps to a specific version of an application Pod. This policy validates that the image specifies a tag and that it is not called `latest`.      
check-routes          |   HTTP traffic is not encrypted and hence insecure. This policy prevents configuration of OpenShift HTTP routes.
allowed-base-images   |   Building images which specify a base as their origin is a good start to improving supply chain security, but over time organizations may want to build an allow list of specific base images which are allowed to be used when constructing containers. This policy ensures that a container's base, found in an OCI annotation, is in a cluster-wide allow
validategit           |   When creating Applications we should ensure that only correct git-repos are used.
multiplereplicas      |   Deployments should have multiple replicas
