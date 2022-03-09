# PolicySets -- Stable
PolicySets in this folder are organized by name. Each `PolicySet` requires the policy
generator for deployment. See the 
[Policy Generator](https://github.com/stolostron/policy-generator-plugin) 
Kustomize plugin for more information on using the policy generator.

## PolicySet details

Policy  | Description | Prerequisites
------- | ----------- | -------------
[Advanced Cluster Management Hardening](./openshift-hardening) | Applies best practices for how to harden your Advanced Cluster Management hub installation. | Needs to be deployed only to the Advanced Cluster Management hub cluster. The `PolicySet` uses cluster `Placement` and not the `PlacementRule` placement mechanism.
