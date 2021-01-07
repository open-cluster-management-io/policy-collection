# Contributing policies

This doc provides instruction on how to contribute policies to the `policy-collection` repo.

You can contribute policies by submitting a pull request (PR) in the `policy-collection` repo. Your PR must be reviewed by the [OWNERS](../OWNERS) of the repo. Contributors own full responsibility for all aspects of secure engineering for their contributions, and need to provide an email address to report security issues found in their contributions.

## Guidelines

You can begin with a policy from the [`policy-collection/stable` folder](https://github.com/open-cluster-management/policy-collection/tree/master/stable), or create your own policy using the product policy framework. For more information, see _Policy overview_ in the [Red Hat Advanced Cluster Management for Kubernetes documentation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.1/html/security/security#policy-overview).


View the following requirement list to contribute to the `policy-collection` repo:

* Contribute a policy by adding to the [community](../policy-collection/community) folder.
* Policies must be mapped to [NIST.SP.800-53r4](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r4.pdf) as this is how policies in this repo are organized. 
* You must provide the policy YAML and documentation that explains what the policies do, and how to use them.
