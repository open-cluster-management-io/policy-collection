**Table of Contents**

- [Contributing guidelines](#contributing-guidelines)
    - [Terms](#terms)
    - [Certificate of Origin](#certificate-of-origin)
    - [DCO Sign Off](#dco-sign-off)
    - [Code of Conduct](#code-of-conduct)
    - [Contributing a custom policy](#contributing-a-custom-policy)
      - [Validate](#validate)
      - [Contribute](#contribute)
    - [Issue and pull request management](#issue-and-pull-request-management)

# Contributing guidelines

You can contribute policies by submitting a pull request (PR) in the `policy-collection` repository. Your PR must be reviewed by the [OWNERS](OWNERS) of the repository. Contributors own full responsibility for all aspects of secure engineering for their contributions, and need to provide an email address to report security issues found in their contributions.

## Terms

All contributions to the repository must be submitted under the terms of the [Apache Public License 2.0](https://www.apache.org/licenses/LICENSE-2.0).

## Certificate of Origin

By contributing to this project, you agree to the Developer Certificate of Origin (DCO). This document was created by the Linux Kernel community and is a simple statement that you, as a contributor, have the legal right to make the contribution. See the [DCO](https://github.com/open-cluster-management-io/community/blob/main/DCO) file for details.

## DCO Sign Off

You must sign off your commit to state that you certify the [DCO](https://github.com/open-cluster-management-io/community/blob/main/DCO). To certify your commit for DCO, add a line like the following at the end of your commit message:

```
Signed-off-by: John Smith <john@example.com>
```

This can be done with the `--signoff` option to `git commit`. See the [Git documentation](https://git-scm.com/docs/git-commit#Documentation/git-commit.txt--s) for details. You can also mass sign-off a whole pull request with `git rebase --signoff main`, replacing `main` with the branch you are creating a pull request into.

## Code of Conduct

The Open Cluster Management project has adopted the CNCF Code of Conduct. Refer to our [Community Code of Conduct](https://github.com/open-cluster-management-io/community/blob/main/CODE_OF_CONDUCT.md) for details.

## Guidelines

You can use a policy from the [`policy-collection/stable` folder](https://github.com/open-cluster-management-io/policy-collection/tree/main/stable), or create your own policy using the product policy framework. For more information, see _Policy overview_ in the [Open Cluster Management documentation](https://open-cluster-management.io/concepts/policy/). Use [NIST Special Publication 800-53](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) to determine the correct NIST 800-53 Control Family for the policy.

Start with creating your own fork and clone the `policy-collection` repository for your local environment by running the following command: `git clone https://github.com/<your-username>/policy-collection.git`

For more information, see [GitHub documentation](https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github/fork-a-repo) to learn how to fork repositories.

## Contributing a custom policy

Learn how to create a custom policy, validate that the custom policy is added, and add your policy to the `policy-collection` repository. Complete the following steps to create a custom policy:

1. Create a new branch to develop a custom policy:
   
   ```
   git checkout -b no-wildcard-roles
   ```

2. Create a new YAML file in the community folder that corresponds to the Security Control Family. Use the [`policy-collection/stable` folder](https://github.com/open-cluster-management-io/policy-collection/tree/main/stable) for an example of the policy framework.

3. Update the table in the [community README](https://github.com/open-cluster-management-io/policy-collection/blob/main/community/README.md) with the custom policy details by adding a new row to the table corresponding to the Security Control Family that we identified in the previous step. Provide the appropriate information in the format that is presented. For more about formatting the content, see GitHub’s Markdown guide. Your entry might resemble the following syntax:
  
   ```
   [policy-name](./control-family/path/to/yaml) | <description> | <prerequisites>
   ```
   
### Validate

To validate the creation of your policy, login to the Open Cluster Management hub cluster to create a new policy using our custom YAML file. 

1. Log in to the Open Cluster Management cluster so you can issue `kubectl` commands.

2. Run the command: `kubectl create -f <yaml-filename> -n <namespace>` to apply the policy resources to the namespace you provide.

   **Note**: You can also validate your policy using GitOps instead of manually creating the policy.

It is important to remember to set your policy to only inform users of policy violations by default and not enforce. You can test the enforcement of the policy if your policy supports it. For more information on which policies support enforcement, see [Policy controllers](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.6/html/security/governance-and-risk#policy-controllers). 

Be sure that your contributed policy is set to `enforce` if the intent of your policy requires something to be created. For example, a policy that creates an operator would be expected to enforce creation of the operator. On the other hand, it is recommended for a configuration policy to be set to `inform` by default so that the policy does not change cluster resources automatically when it is applied.

### Contribute

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

4. Copy and paste the URL to the pull request into your browser, which is provided in the output of the push command. Push changes from your fork back to the `open-cluster-management-io/policy-collection` repository.
  
   Alternatively, view the [policy-collection compare page](https://github.com/open-cluster-management-io/policy-collection/compare), select **compare across forks**, and select your fork and branch from the drop-down list.

   **Tip:** Provide comments in the pull request to help describe any details about your policy that may be useful to reviewers.

5. Add the [policy-collection OWNERS](https://github.com/open-cluster-management-io/policy-collection/blob/main/OWNERS) as reviewers to the pull request so that they receive notifications about the pull request.

6. After the pull request is reviewed and approved, automation will merge the changes into the main branch of the repository.

## Issue and pull request management

Anyone can comment on issues and submit reviews for pull requests. In order to be assigned an issue or pull request, you can leave a `/assign <your Github ID>` comment on the issue or pull request (PR).
