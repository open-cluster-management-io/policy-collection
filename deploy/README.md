# Deploy policies to Open Cluster Management

Deploy policies to Open Cluster Management with the `deploy.sh` script.

## Deploying policies with GitOps

You must meet the following prerequisites before you deploy policies with the script:

- Your `oc` or `kubectl` CLI must be configured and able to access the cluster to which you want to
  deploy.
- Starting in 2.4 you need to be Subscription-Admin. One option is to execute:
  [`community/CM-Configuration-Management/policy-configure-subscription-admin-hub`](../community/CM-Configuration-Management/policy-configure-subscription-admin-hub.yaml)
  from the command-line and set it to enforce.

View the following guidance on how to use the script (all parameters are optional--any parameters
not provided will use the defaults specified):

```
Usage:
  ./deploy.sh [-u <url>] [-b <branch>] [-p <path/to/dir>] [-n <namespace>]
              [-a|--name <resource-name>] [--deploy-app] [--dry-run]

  -h|--help                   Display this menu
  -u|--url <url>              URL to the Git repository
                                (Default URL: "https://github.com/open-cluster-management-io/policy-collection.git")
  -b|--branch <branch>        Branch of the Git repository to point to
                                (Default branch: "main")
  -p|--path <path/to/dir>     Path to the desired subdirectory of the Git repository
                                (Default path: stable)
  -n|--namespace <namespace>  Namespace on the cluster to deploy policies to (must exist already)
                                (Default namespace: "policies")
  -a|--name <resource-name>   Prefix for the Channel and Subscription resources
                                (Default name: "demo-stable-policies")
  -s|--sync <rate>            How frequently the github resources are compared to the hub resources
                                (Default rate: "medium") Rates: "high", "medium", "low", "off"
  --deploy-app                Create an Application and Placement manifest for additional visibility 
                                in the UI (Search should also be enabled in the Hub cluster)
  --dry-run                   Print the YAML to stdout without applying them to the cluster
```

For more details on the `sync` parameter values, see the git subscription chapter
[Resource reconciliation rate settings](https://github.com/open-cluster-management-io/multicloud-operators-subscription/blob/main/docs/gitrepo_subscription.md#resource-reconciliation-rate-settings).

## Remove resources

You can either use `remove.sh` to search for and remove resources from Open Cluster Management that
are created with the `deploy.sh` script, or you can use `kubectl delete -f manifests.yaml` if
`deploy.sh` has not been run since the manifests were generated and deployed to the cluster.

To use `remove.sh`, you must meet the following prerequisites before you remove resources with the
`remove.sh` script:

- Your `oc` or `kubectl` CLI must be configured and able to access to the resources that you want to
  remove from the cluster.
- Verify that Channel and Subscription were deployed using the `deploy.sh` script. Channel and
  Subscription must match the pattern `<prefix>-chan` and `<prefix>-sub` respectively.

View the following guidance on how to use the script (all parameters are optional--the script will
query the cluster to get options for parameters not provided):

```
Usage:
  ./remove.sh [-n <namespace>] [-a|--name <resource-name>]

  -h|--help                   Display this menu
  -n|--namespace <namespace>  Namespace on the cluster that resources are located
  -a|--name <resource-name>   Prefix for the Channel and Subscription resources
```
