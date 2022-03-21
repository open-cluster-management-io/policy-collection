# Policy Generator

Generate Open Cluster Management policies from existing Kubernetes manifests in your repository
using the [Policy Generator](https://github.com/stolostron/policy-generator-plugin) Kustomize plugin
through GitOps in Open Cluster Management.

## Topics

- [About the Policy Generator](#about-the-policy-generator)
- [Deploying the example manifests](#deploying-the-example-manifests)
- [Adding additional manifests](#adding-additional-manifests)

### Additional information

- [Policy Generator product documentation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.4/html/governance/governance#policy-generator)
- [Policy Generator source repository documentation](https://github.com/stolostron/policy-generator-plugin/blob/main/README.md)
- [Policy Generator reference YAML](https://github.com/stolostron/policy-generator-plugin/blob/main/docs/policygenerator-reference.yaml)
- [Kustomize documentation](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/)

## About the Policy Generator

The generator automatically wraps Kubernetes manifests in Open Cluster Management policies, allowing
you to deploy policies to Open Cluster Management without needing to have an additional manifest to
maintain. Furthermore, it also expands on wrapping
[Gatekeeper](https://open-policy-agent.github.io/gatekeeper/) and [Kyverno](https://kyverno.io/)
policies by automatically generating additional policies alongside policies from these engines to
detect violation objects created by those engines, providing a full view of compliance for each Open
Cluster Management policy.

For more information about contributing to the policy engine expanders, see the
[repository documentation](https://github.com/stolostron/policy-generator-plugin/blob/main/docs/policygenerator.md#policy-expanders).

## Deploying the example manifests

In this `policygenerator/` folder you will find:

- [`subscription.yaml`](subscription.yaml) - Manifest to deploy the Subscription/Channel resource
  objects for GitOps for the `kustomize/` folder
- `kustomize/`
  - [`kustomization.yaml`](kustomize/kustomization.yaml) - Kustomize manifest pointing to the
    PolicyGenerator manifest
  - [`policyGenerator.yaml`](kustomize/policyGenerator.yaml) - Policy Generator manifest defining
    the policies to generate, placement, and customizations to both the policies and target
    manifests
  - [`policy1_deployment/`](kustomize/policy1_deployment) - Kubernetes manifests to wrap in a policy
  - [`policy2_gatekeeper/`](kustomize/policy2_gatekeeper) - Gatekeeper policy manifests to wrap in a
    policy (assumes Gatekeeper is installed)
  - [`policy3_kyverno/`](kustomize/policy3_kyverno) - Kyverno policy manifests to wrap in a policy
    (assumes Kyverno is installed)
- `policy-sets/` - A directory of generator manifests that are each using the `PolicySet` mechanism
  for organizing related policies. Requires Advanced Cluster Management 2.5 and newer for the
  `PolicySet` support.
  - [`stable/`](policy-sets/stable) - tested and supported PolicySets
  - [`community/`](policy-sets/community) - PolicySets that have been contributed by the community

To deploy the policy generator examples in the `kustomize/` folder via GitOps:

- Clone this repository.
- Create the [`subscription.yaml`](subscription.yaml) on an Open Cluster Management hub. This file
  contains the Namespace, Subscription, and Channel needed to establish GitOps with the
  [`kustomize/`](kustomize) folder. Additionally, it deploys an Application and PlacementRule for
  visibility in the Application tab of the hub (this is not a requirement for GitOps):
  ```shell
  oc create -f subscription.yaml
  ```
  **NOTES**:
  - You must be a Subscription Admin to successfully deploy this manifest. See the
    [Subscription Administrator](../README.md#subscription-administrator) topic.
  - Use [deploy.sh](../deploy) to create customized Subscription/Channel manifests or update the
    `apps.open-cluster-management.io/git-path` annotation in the Subscription of
    [`subscription.yaml`](subscription.yaml) to deploy a different folder of the `policy-collection`
    repository)
- Navigate to the Governance tab of your hub to view the deployed policies!

  **NOTE**: The deployment could take a few minutes. Check the status of the Subscription if the
  policies don't appear:

  ```shell
  oc -n policy-generator-demo describe subscription.apps.open-cluster-management.io policy-generator-demo-subscription
  ```

- You'll notice that all of these policies are set to `remediationAction: inform`, and the
  Gatekeeper policy itself is set to `enforcementAction: dryrun`. This prevents unexpected changes
  to your cluster. To customize these examples, like enabling the sample policies or trying out
  different configurations, fork this repository and update `spec.pathname` in the Channel manifest
  of [`subscription.yaml`](subscription.yaml):
  ```yaml
  spec:
    type: Git
    pathname: https://github.com/<organization-or-username>/policy-collection.git
  ```
  Apply the change to your hub:
  ```shell
  oc apply -f subscription.yaml
  ```
  Now, you can commit changes to your forked repository and view the updates on the hub! See
  [Adding additional manifests](#adding-additional-manifests) for how to add your own files.

To generate the policy manifests locally:

- Install the policy generator locally (See the
  [Installation](https://github.com/stolostron/policy-generator-plugin#installation) section of the
  generator documentation)
- Change to the `kustomize/` directory
- Generate the policies:
  ```shell
  kustomize build --enable-alpha-plugins
  ```

## Adding additional manifests

To add your own manifests to be generated, add your YAML files to the
[`policygenerator/kustomize`](kustomize) directory (or to a new or existing subdirectory there).
Then, update the `policies` array in [`policyGenerator.yaml`](kustomize/policyGenerator.yaml) with:

1. The name of the policy you want to generate.
2. Paths to the manifests from which to generate policies (specifying a directory will place all
   manifests there in a policy).

If the manifests point to a Kyverno or Gatekeeper API version, they will automatically be expanded
upon generation with additional Open Cluster Management policies to show whether the respective
policy engine has detected a violation.

See [Additional information](#additional-information) for resources about additional generator
configuration options and the policy expanders.

Full Policy YAML can also be deployed and customized by leveraging Kustomize directly in the
`kustomization.yaml` by adding a `resources:` key and listing the files or directories underneath.
