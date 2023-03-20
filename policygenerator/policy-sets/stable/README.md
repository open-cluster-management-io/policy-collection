# PolicySets -- Stable
PolicySets in this folder are organized by name. Each `PolicySet` requires the policy
generator for deployment. See the 
[Policy Generator](https://github.com/stolostron/policy-generator-plugin) 
Kustomize plugin for more information on using the policy generator.

## PolicySet details

Policy  | Description | Prerequisites
------- | ----------- | -------------
[Advanced Cluster Management Hub Best Practices](./acm-hardening) | Applies best practice policies for your Advanced Cluster Management hub installation. | Needs to be deployed only to the Advanced Cluster Management hub cluster. The `PolicySet` uses cluster `Placement` and not the `PlacementRule` placement mechanism.
[OpenShift Platform Plus](./openshift-plus) | The OpenShift Platform Plus policy set applies several policies that installs the OpenShift Platform Plus products using best practices that allow them to work well together. | The OpenShift Platform Plus policy set works with OpenShift managed clusters and installs many components to the hub cluster. See the policy set [README.md](./openshift-plus/README.md) for more information on prerequisites. The `PolicySet` uses cluster `Placement` and not the `PlacementRule` placement mechanism. Red Hat Advanced Cluster Management version 2.7 is required to install this PolicySet.
