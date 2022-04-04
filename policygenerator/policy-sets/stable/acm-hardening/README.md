# PolicySets -- ACM Hardening

See the [Policy Generator](https://github.com/stolostron/policy-generator-plugin) 
Kustomize plugin for more information on using the policy generator.

## PolicySet details

The ACM Hardening `PolicySet` Applies best practices for how to harden your Advanced Cluster Management hub installation. 
This `PolicySet` needs to be deployed only to the Advanced Cluster Management hub cluster. 

**Note**: The `PolicySet` uses cluster `Placement` and not the `PlacementRule` placement mechanism.
