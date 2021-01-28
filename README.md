# Policy Collection
A collection of policy examples for Open Cluster Management

## Repo structure
This repo hosts policies for Open Cluster Management. You can find policies from the following folders:

* [stable](stable) -- Policies in the `stable` folder can be applied with [Red Hat Advanced Cluster Management for Kubernetes](https://www.redhat.com/en/technologies/management/advanced-cluster-management).
* [community](community) -- Policies in the `community` folder are contributed from the open source community and can be applied with the product governance framework. 

## Using GitOps to deploy policies to a cluster

Fork this repository; you will use the forked version of this repo as the target to run the sync against. This is to avoid unintended changes to be applied to your cluster automatically. To get latest policies from the policy-collection repo, you can pull the latest changes from policy-collection to your own repo through a pull request. Any further changes to your repo will automatically be applied to your cluster.

Make sure you have [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed and that you are logged into your hub cluster in terminal.

Run `kubectl create ns policies` to create a "policies" ns on hub. If you prefer to call the namespace something else, you can run `kubectl create ns <custom ns>` instead.

From within this directory in terminal, run `cd deploy` to access the deployment directory, then run `bash ./deploy.sh -u <url> -p <path> -n <namespace>`. (Details on all of the parameters for this command can be viewed in its [README](deploy/README.md).)

The policies are applied to all managed clusters that are available, and have the `environement` set to `dev`. Specifically, an available managed cluster has the `status` parameter set to `true` by the system, for the `ManagedClusterConditionAvailable` condition. If policies need to be applied to another set of clusters, update the `PlacementRule.spec.clusterSelector.matchExpressions` section in the policies.

**Note**: As new clusters are added that fit the critieria previously mentioned, the policies are applied automatically. 

## Community, discussion, contribution, and support

Check the [CONTRIBUTING Doc](docs/CONTRIBUTING.md) on how to contribute to the repo.

You can reach the maintainers of this project at:

- acm-contact@redhat.com

**Blogs**: Read our blogs for more information and best practices for Red Hat Advanced Cluster Management for Kubernetes governance capability:

* [Comply to standards using the policy based governance of Red Hat Advanced Cluster Management for Kubernetes](https://www.openshift.com/blog/comply-to-standards-using-policy-based-governance-of-red-hat-advanced-cluster-management-for-kubernetes)

* [Develop your own policy controller to integrate with Red Hat Advanced Cluster Management for Kubernetes](https://www.openshift.com/blog/develop-your-own-policy-controller-to-integrate-with-red-hat-advanced-cluster-management-for-kubernetes)

* [How to Integrate Open Policy Agent with Red Hat Advanced Cluster Management for Kubernetes policy framework](https://www.openshift.com/blog/how-to-integrate-open-policy-agent-with-red-hat-advanced-cluster-management-for-kubernetes-policy-framework)

* [Securing Kubernetes Clusters with Sysdig and Red Hat Advanced Cluster Management](https://www.openshift.com/blog/securing-kubernetes-clusters-with-sysdig-and-red-hat-advanced-cluster-management)

* [Contributing and deploying community policies with Red Hat Advanced Cluster Management and GitOps](https://www.openshift.com/blog/contributing-and-deploying-community-policies-with-red-hat-advanced-cluster-management-and-gitops)

* [Implement Policy-based Governance Using Configuration Management of Red Hat Advanced Cluster Management for Kubernetes](https://www.openshift.com/blog/implement-policy-based-governance-using-configuration-management-of-red-hat-advanced-cluster-management-for-kubernetes)

**Resources**: View the following resources for more information on the components and mechanisms are implemented in the product governance framework.

* [Product documentation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.1/)

* National Cyber security Center of Excellence (NCCoE) blog, [Policy Based Governance in Trusted Container Platform](https://www.nccoe.nist.gov/news/policy-based-governance-trusted-container-platform)

* IBM Developer blog, [Policy based governance for open hybrid cloud](http://ibm.biz/policy-based-governance-for-open-hybrid-cloud)
