# PolicySets -- Community

`PolicySets` in this folder are organized by name. Each `PolicySet` requires the policy generator for deployment.
See the [Policy Generator](https://github.com/stolostron/policy-generator-plugin) Kustomize plugin for more information
on using the policy generator.

## PolicySet details

Policy  | Description | Prerequisites
------- | ----------- | -------------
[OpenShift Hardening](./openshift-hardening) | Applies the OpenShift best practices for how to harden your OpenShift clusters. | Requires placement on OpenShift 4.6 clusters or newer. The `PolicySet` uses cluster `Placement` and not the `PlacementRule` placement mechanism.
[OpenShift Platform Plus](./openshift-plus) | The OpenShift Platform Plus policy set applies several policies that installs the OpenShift Platform Plus products using best practices that allow them to work well together. | The OpenShift Platform Plus policy set works with OpenShift managed clusters and installs many components to the hub cluster. See the policy set [README.md](./openshift-plus/README.md) for more information on prerequisites. The `PolicySet` uses cluster `Placement` and not the `PlacementRule` placement mechanism.
[Kyverno Policy Sets](./kyverno) | The Kyverno policy sets are provided to help you apply best practices around security, multitenancy and applications. See the details for each each of the policy sets in the `kyverno` subdirectories. | The Kyverno `PolicySets` require the Kyverno helm chart to be installed on each managed cluster where you want to install the `PolicySets`.  Use the policy [`policy-install-kyverno`](https://raw.githubusercontent.com/stolostron/policy-collection/main/community/CM-Configuration-Management/policy-install-kyverno.yaml) to install kyverno and the policy [`policy-kyverno-config-exclude-resources`](https://raw.githubusercontent.com/stolostron/policy-collection/main/community/CM-Configuration-Management/policy-kyverno-config-exclude-resources.yaml) to update Kyverno resource filters. The `PolicySet` uses cluster `Placement` and not the `PlacementRule` placement mechanism.  For more details on Kyverno `PolicySet` installation, see the [README.md](./kyverno/README.md).
