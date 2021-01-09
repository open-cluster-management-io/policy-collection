# Contributing policies

This doc provides instruction on how to contribute policies to the `policy-collection` repo.

You can contribute policies by submitting a pull request (PR) in the `policy-collection` repo. Your PR must be reviewed by the [OWNERS](../OWNERS) of the repo. Contributors own full responsibility for all aspects of secure engineering for their contributions, and need to provide an email address to report security issues found in their contributions.

## Guidelines

Start with creating a fork to clone the policy-collection repo for your local environment. For more information, see [GitHub documentation](https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github/fork-a-repo) to learn how to fork repos.

You can use a policy from the [`policy-collection/stable` folder](https://github.com/open-cluster-management/policy-collection/tree/master/stable), or create your own policy using the product policy framework. For more information, see _Policy overview_ in the [Red Hat Advanced Cluster Management for Kubernetes documentation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.1/html/security/security#policy-overview). Use NIST Special Publication 800-53 to determine the correct NIST 800-53 Control Family for the policy.


View the following requirement list to contribute to the `policy-collection` repo:

* Contribute a policy by adding to the [community](../policy-collection/community) folder.
* Policies must be mapped to [NIST.SP.800-53r4](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r4.pdf) as this is how policies in this repo are organized. 
* You must provide the policy YAML and documentation that explains what the policies do, and how to use them.
