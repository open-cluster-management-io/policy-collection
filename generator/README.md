# Policy Generator

Generate Open Cluster Management policies from existing Kubernetes manifests in your repository
using the [Policy Generator](https://github.com/stolostron/policy-generator-plugin)
Kustomize plugin through GitOps in Open Cluster Management.

## Additional information

- [Policy Generator product documentation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.4/html/governance/governance#policy-generator)
- [Policy Generator source repository documentation](https://github.com/stolostron/policy-generator-plugin/blob/main/README.md)
- [Policy Generator reference YAML](https://github.com/stolostron/policy-generator-plugin/blob/main/docs/policygenerator-reference.yaml)

## Deploying the example manifests

In this `generator/` folder you will find:

- [`subscription.yaml`](subscription.yaml) - Manifest to deploy the Subscription/Channel resource
  objects for GitOps for this folder
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

To deploy the examples in this folder via GitOps:

- Clone this repository.
- Create the [`subscription.yaml`](subscription.yaml) on an Open Cluster Management hub. This file
  contains the Namespace, Subscription, and Channel needed to establish GitOps with the
  [`kustomize/`](kustomize) folder. Additionally, it deploys an Application and PlacementRule for
  visibility in the Application tab of the hub (this is not a requirement for GitOps):
  ```shell
  oc create -f subscription.yaml
  ```
  **NOTE**: You must be a Subscription Admin to successfully deploy this manifest. See the
  [Subscription Administrator](../README.md#subscription-administrator) topic.
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
  Now, you can commit changes to your forked repository and view the updates on the hub!

To generate the policy manifests locally:

- Install the policy generator locally (See the
  [Installation](https://github.com/stolostron/policy-generator-plugin#installation)
  section of the generator documentation)
- Change to the `kustomize/` directory
- Generate the policies:
  ```shell
  kustomize build --enable-alpha-plugins
  ```
