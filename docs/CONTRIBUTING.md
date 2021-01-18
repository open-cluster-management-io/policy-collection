# Contributing policies

This doc provides instruction on how to contribute policies to the `policy-collection` repo.

You can contribute policies by submitting a pull request (PR) in the `policy-collection` repo. Your PR must be reviewed by the [OWNERS](../OWNERS) of the repo. Contributors own full responsibility for all aspects of secure engineering for their contributions, and need to provide an email address to report security issues found in their contributions.

## Guidelines

You can use a policy from the [`policy-collection/stable` folder](https://github.com/open-cluster-management/policy-collection/tree/master/stable), or create your own policy using the product policy framework. For more information, see _Policy overview_ in the [Red Hat Advanced Cluster Management for Kubernetes documentation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.1/html/security/security#policy-overview). Use [NIST Special Publication 800-53](https://nvd.nist.gov/800-53/Rev4) to determine the correct NIST 800-53 Control Family for the policy.

Start with creating your own fork and clone the `policy-collection` repo for your local environment by running the following command: `git clone https://github.com/<your-username>/policy-collection.git`

For more information, see [GitHub documentation](https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github/fork-a-repo) to learn how to fork repos.

## Contributing a custom policy

Learn how to create a custom policy, validate that the custom policy is added, and add your policy to the `policy-collection` repository. Complete the following steps to create a custom policy:

1. Create a new branch to develop a custom policy:
   
   ```
   git checkout -b no-wildcard-roles
   ```

2. Create a new YAML file in the community folder that corresponds to the Security Control Family. Use the [`policy-collection/stable` folder](https://github.com/open-cluster-management/policy-collection/tree/master/stable) for an example of the policy framework.

3. Update the table in the [community README](https://github.com/open-cluster-management/policy-collection/blob/master/community/README.md) with the custom policy details by adding a new row to the table corresponding to the Security Control Family that we identified in the previous step. Provide the appropriate information in the format that is presented. For more about formatting the content, see GitHub’s Markdown guide. Your entry might resemble the following syntax:
  
   ```
   [policy-name](./control-family/path/to/yaml) | <description> | <prerequisites>
   ```
   
## Validate

To validate the creation of your policy, use the Red Hat Advanced Cluster Management web console to create a new policy using our custom YAML file. 

1. Log in to the Red Hat Advanced Cluster Management web console, click the navigation menu, and select **Govern risk**.

2. Click the **Create policy** button to create a new policy. Replace the entire contents of the policy editor with the contents of the policy you have created.

3. Click **Create** to create the policy on the hub cluster and propagate it to the selected managed clusters. Make sure the policy is created successfully and alerts on non-compliant clusters having the `environment:dev` label as expected.

   **Note**: You can also validate your policy using GitOps instead of manually creating the policy.

It is important to remember to set your policy to only inform users of policy violations by default and not enforce. You can test the enforcement of the policy if your policy supports it. For more information on which policies support enforcement, see [Policy controllers](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.1/html/security/security#policy-controllers). 

Be sure that your contributed policy is set to `enforce` if the intent of your policy requires something to be created. For example, a policy that creates an operator would be expected to enforce creation of the operator. On the other hand, it is recommended for a configuration policy to be set to `inform` by default so that the policy does not change cluster resources automatically when it is applied.

## Contribute

Create a pull request that can be reviewed by the product team. See the following instructions to populate a pull request: 

1. Return to the `policy-collection` directory and add all changed files with the following command:

   ```
   git add .
   ```

   * Run `git status` and make sure all of the changes that you expect have been added to the commit. If you make any additional changes, you’ll need to make sure to run `git add` again for those files.

2. Commit the changes with a descriptive message with the following command:

   ```
   git commit -m "create a least privilege policy that looks for a role using wildcards"
   ```

3. Push the changes to your repository by running the following command:

   ```
   git push origin no-wildcard-roles
   ```

4. Copy and paste the URL to the pull request into your browser, which is provided in the output of the push command. Push changes from your fork back to the `open-cluster-management/policy-collection` repository.
  
   Alternatively, view the [policy-collection compare page](https://github.com/open-cluster-management/policy-collection/compare), select **compare across forks**, and select your fork and branch from the drop-down list.

   **Tip:** Provide comments in the pull request to help describe any details about your policy that may be useful to reviewers.

5. Add the [policy-collection OWNERS](https://github.com/open-cluster-management/policy-collection/blob/master/OWNERS) as reviewers to the pull request so that they receive notifications about the pull request.

6. After the pull request is reviewed and approved, select **Squash and Merge** in your pull request to merge the changes into the master branch of the repository.
