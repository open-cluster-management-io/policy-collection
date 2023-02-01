# governance-best-practises-for-apps

Repository showing best practices for apps

Based on the following links:

* https://cloud.redhat.com/blog/9-best-practices-for-deploying-highly-available-applications-to-openshift
* https://cloud.redhat.com/blog/14-best-practices-for-developing-applications-on-openshift

## Kyverno best prastices

https://kyverno.io/policies/?policytypes=Best%2520Practices


We look to create a PolicySet based on Open Cluster Management Policies and Kyverno Integration

## List of Policies 


Policy                 | Description 
-----------------------| ----------- 
require-probes        |   Liveness and readiness probes need to be configured to correctly manage a Pod's lifecycle during deployments, restarts, and upgrades. For each Pod, a periodic `livenessProbe` is performed by the kubelet to determine if the Pod's containers are running or need to be restarted. A `readinessProbe` is used by Services and Deployments to determine if the Pod is ready to receive network traffic. This policy validates that all containers have liveness and readiness probes by ensuring the `periodSeconds` field is greater than zero.
base-images           |   Building images which specify a base as their origin is a good start to improving supply chain security, but over time organizations may want to build an allow list of specific base images which are allowed to be used when constructing containers. This policy ensures that a container's base, found in an OCI annotation, is in a cluster-wide allow
routes                | HTTP traffic is not encrypted and hence insecure. This policy prevents configuration of OpenShift HTTP routes.
poddisruptionbudget   |  A PodDisruptionBudget limits the number of Pods of a replicated application that are down simultaneously from voluntary disruptions. For example, a quorum-based application would like to ensure that the number of replicas running is never brought below the number needed for a quorum. As an application owner, you can create a PodDisruptionBudget (PDB) for each application. This policy will create a PDB resource whenever a new Deployment is created.
deployreqmultiplereplicas |   Deployments should have multiple replicas
validategit           |   When creating Applications we should ensure that only correct git-repos are used.
limitsrequests        | Validates that all containers have a value specified for their memory and CPU requests and memory limits.
