# `deploy.sh`

## Deploy policies to Red Hat Advanced Cluster Management via GitOps
```
Prerequisites:
 - oc CLI should be pointing to the cluster to deploy to
 - The desired cluster namespace should already exist

Usage:
  ./deploy.sh [-u <url>] [-b <branch>] [-p <path>] [-n <namespace>] [-a|--name <resource-name]

  -h|--help                   Display this menu
  -u|--url <url>              URL to the Git repository
                                (Default URL: "https://github.com/open-cluster-management/policy-collection.git")
  -b|--branch <branch>        Branch of the Git repository to point to
                                (Default branch: "master")
  -p|--path <path>            Path to the desired subdirectory of the Git repository
                                (Default path: stable)
  -n|--namespace <namespace>  Namespace on the cluster to deploy policies to (must exist already)
                                (Default namespace: "policies")
  -a|--name <resource-name>   Prefix for the Channel and Subscription resources
                                (Default name: "demo-stable-policies")
```

# `remove.sh`

## Find and remove resources from Red Hat Advanced Cluster Management created via `deploy.sh`
```
Prerequisites:
 - oc CLI should be pointing to the cluster to remove from
 - Channel and Subscription should have been deployed using the deploy.sh script
   (or match the pattern <prefix>-chan and <prefix>-sub)

Usage:
  ./remove.sh [-n <namespace>] [-a|--name <resource-name>]

  -h|--help                   Display this menu
  -n|--namespace <namespace>  Namespace on the cluster that resources are located
  -a|--name <resource-name>   Prefix for the Channel and Subscription resources
```
