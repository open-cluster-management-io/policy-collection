# Policy Collection
A collection of policy examples for Open Cluster Management

## Repo structure
This repo hosts policies for Open Cluster Management. You can find policies from the following folders:

* [stable](stable) -- Policies in the `stable` folder are supported by [Red Hat Advanced Cluster Management for Kubernetes](https://www.redhat.com/en/technologies/management/advanced-cluster-management).
* [community](community) -- Policies in the `community` folder are contributed from the open source community. 

## Syncing policy-collection to a cluster

Make sure you have [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed and that you are logged into your hub cluster in terminal.

Run `kubectl create ns policies` to create a "policies" ns on hub. If you prefer to call the namespace something else, you can run `kubectl create ns <custom ns>` instead.

From within this directory in terminal, run `cd deploy` to access the deployment directory, then run `bash ./deploy.sh <url> <path> <namespace>`. The parameters for this command are defined as follows:
- `url`: the url of the target repo to run the sync against. Defaults to https://github.com/open-cluster-management/policy-collection.git.
- `path`: the name of the folder in the policy-collection repo that you'd like to pull policies from. Defaults to `stable`.
- `namespace`: the namespace you'd like to deploy the policies on, which should be the same as the one you created earlier. Defaults to `policies`.

## Community, discussion, contribution, and support

Check the [CONTRIBUTING Doc](docs/CONTRIBUTING.md) on how to contribute to the repo.

You can reach the maintainers of this project at:

- [#xxx on Slack](https://slack.com/signin?redir=%2Fmessages%2Fxxx)
