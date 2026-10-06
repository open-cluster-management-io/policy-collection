# Fine-grained RBAC for OpenShift Virtualization

PolicySet for ACM 2.16+ fleet virtualization RBAC. It follows the [2.17 fine-grained RBAC procedure](https://docs.redhat.com/en/documentation/red_hat_advanced_cluster_management_for_kubernetes/2.17/html-single/secure_clusters/index#fine-grain-enable) and the role layout in `examplefulladmin`.

## Hub policies and managed-cluster policies

Custom ClusterRoles are authored once, on the hub, with the three Fleet Management labels:

- `rbac.open-cluster-management.io/filter: vm-clusterroles`
- `clusterview.open-cluster-management.io/discoverable: "true"`
- `rbac.open-cluster-management.io/custom-role: "true"`

`policy-virt-custom-roles` creates them on the hub so they show up on the Fleet Management Roles page. The PolicySet itself is placed on the hub. `policy-virt-custom-roles-propagate` is also placed on OpenShift managed clusters. It lists every hub ClusterRole with `custom-role=true` and creates that same role there. The cluster proxy evaluates the role on the managed cluster, so the hub copy has to be deployed to those clusters as well.

Default roles are installed by OpenShift Virtualization and by the `fine-grained-rbac` component. This set binds them. It does not recreate them.

| Role | Installed by | Where it is used |
| --- | --- | --- |
| `kubevirt.io:view`, `kubevirt.io:edit`, `kubevirt.io:admin` | OpenShift Virtualization | Managed cluster, via MulticlusterRoleAssignment |
| `acm-vm-fleet:view`, `acm-vm-fleet:admin` | fine-grained-rbac | Hub ClusterRoleBinding, console prerequisite |
| `acm-vm-extended:view`, `acm-vm-extended:admin` | fine-grained-rbac | Managed cluster |
| `acm-vm-cluster-migration:view` | fine-grained-rbac | Managed cluster, cluster-scoped |
| `migrations.kubevirt.io:view` | OpenShift Virtualization | View assignment until [ACM-47215](https://redhat.atlassian.net/browse/ACM-47215) |
| `migrations.kubevirt.io:storagemigrate` | OpenShift Virtualization | Admin assignment until ACM-47215 |
| `migrations.kubevirt.io:storagemigrate_multins` | OpenShift Virtualization | Admin assignment until ACM-47215 |
| `custom-vm-execution-role`, `custom-vm-admin-role`, `custom-vm-snapshot-role`, `custom-vm-migration-role`, `custom-vm-storage-role`, `custom-vm-console-role` | this PolicySet | Hub and managed clusters |

ACM-47215 will fold `migrations.kubevirt.io:view` into `acm-vm-extended:view`, and the two storage-migrate roles into `acm-vm-extended:admin`. The 2.17 scenario tables omit those roles today. The view and admin assignments bind them until that change ships. Confirm the multi-namespace name before enabling the admin assignment. The console in the reference environment shows an underscore (`storagemigrate_multins`). The Jira text uses a hyphen (`storagemigrate-multins`).

```bash
oc get clusterrole -o name | grep '^clusterrole.rbac.authorization.k8s.io/migrations.kubevirt.io'
oc api-resources --api-group=migrations.kubevirt.io
```

Drop `targetNamespaces` on a migration assignment when those resources are cluster-scoped.

## What is enforced on first apply

| Policy | Placement | Effect |
| --- | --- | --- |
| `policy-virt-fine-grained-rbac-enable` | Hub | Sets `fine-grained-rbac` enabled on MultiClusterHub |
| `policy-virt-custom-roles` | Hub | Creates the six custom ClusterRoles |
| `policy-virt-hub-lookup-rbac` | Hub | ServiceAccount that can list ClusterRoles for the hub lookup |
| `policy-virt-clusters-placement` | Hub | Placement `virt-clusters` (`acm.io/virtualization=true`) |
| `policy-virt-custom-roles-propagate` | Hub and OpenShift managed clusters | Copies the labeled hub ClusterRoles onto each managed cluster |

These assignment policies are in the set with `disabled: true`. Edit the group and `team-vms`, then set `disabled: false`.

| Policy | Persona | Hub role | Managed roles |
| --- | --- | --- | --- |
| `policy-virt-assign-view` | `virt-viewers` | `acm-vm-fleet:view` | `kubevirt.io:view`, `migrations.kubevirt.io:view` |
| `policy-virt-assign-admin` | `virt-admins` | `acm-vm-fleet:view` | `kubevirt.io:admin`, `acm-vm-extended:admin`, `migrations.kubevirt.io:storagemigrate`, `migrations.kubevirt.io:storagemigrate_multins` |
| `policy-virt-assign-cclm` | `virt-migrators` | `acm-vm-fleet:admin` | `kubevirt.io:admin`, `acm-vm-extended:admin`, `acm-vm-cluster-migration:view` (cluster-scoped) |
| `policy-virt-assign-custom-execution` | `virt-operators` | `acm-vm-fleet:view` | `kubevirt.io:view`, `custom-vm-execution-role` |

Copy `input/assignments/custom-execution.yaml` for the other custom roles. Each custom role is meant to be layered on `kubevirt.io:view`.

`optional/` holds `custom-vm-full-admin-role`. That role allows every verb on every resource. It is cluster-admin equivalent and is not part of the generator. `kubevirt.io:admin` does not narrow it.

## Prerequisites

- ACM 2.16 or newer. The hub is self-managed (`local-cluster=true`).
- OpenShift Virtualization on the hub and on every cluster you will select with `virt-clusters`.
- The same users and groups on the hub and on those managed clusters.
- Governance enabled.
- Policy Generator kustomize plugin.

Policies, the lookup ServiceAccount, the `virt-clusters` Placement, and the assignments live in the `policies` namespace so `<namespace>.<policy-name>` stays within 63 characters. `kustomization.yml` creates the namespace and a `ManagedClusterSetBinding` to the `default` cluster set. Change `clusterSet` in `input/bootstrap/namespace.yaml` if your clusters are in another set.

Label each virt managed cluster. The placement selects nothing until you do.

```bash
oc label managedcluster <name> acm.io/virtualization=true
```

`team-vms` must exist on those clusters before an assignment policy is enabled. A missing `kubevirt.io:view` on a selected cluster makes the binding fail.

If the MultiClusterHub name or namespace is not `multiclusterhub` / `open-cluster-management`, edit `input/hub/enable-fine-grained-rbac.yaml`.

## Install

```bash
kustomize build --enable-alpha-plugins policygenerator/policy-sets/community/virt-fine-grained-rbac \
  | oc apply -f -
```

`policy-virt-custom-roles-propagate` sets `hubTemplateOptions.serviceAccountName` to `policy-virt-hub-clusterroles` so the hub lookup runs as that ServiceAccount.

## Adding another custom role

1. Add a ClusterRole under `input/hub/custom-roles/` with all three labels.
2. Add its path to `policy-virt-custom-roles` in `policyGenerator.yaml`.
3. Re-apply. The propagate policy picks up any hub ClusterRole with `custom-role=true` on the next evaluation.

The label is the propagation selector. A ClusterRole with that label is copied to every OpenShift managed cluster this set selects.
