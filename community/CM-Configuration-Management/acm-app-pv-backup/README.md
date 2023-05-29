# ACM Persistent data backup and restore

Stateful application DR using ACM policies 
------

- [List of PolicySets](#list-of-policysets)
- [List of Policies](#list-of-policies)
- [hdr-app-configmap ConfigMap](#policies-input-data-using-hdr-app-configmap)
- [Scenario](#scenario)
- [Apply policies on the hub](#apply-policies-on-the-hub)
- [Create multiple backup configurations](#create-multiple-backup-configurations)
- [Usage considerations](#usage-considerations)
- [Testing Scenario - pacman](#testing-scenario)
- [Backup and Restore hooks](#backup-and-restore-hooks)

------

## List of PolicySets 

PolicySet   | Description 
-------------------------------------------| ----------- 
[acm-app-backup](./resources/policy-sets/acm-app-backup-policy-set.yaml)   | This PolicySet is used to place the [oadp-hdr-app-install](./resources/policies/oadp-hdr-app-install.yaml) and [oadp-hdr-app-backup](./resources/policies/oadp-hdr-app-backup.yaml) policies on managed clusters using the [acm-app-backup-placement](./resources/policy-sets/acm-app-backup-policy-set.yaml) rule, which is all managed clusters with a label `"acm-pv-dr=backup"`. Update the placement if you want to customize the target cluster list.
[acm-app-restore](./resources/policy-sets/acm-app-restore-policy-set.yaml)                            | This PolicySet is used to place the [oadp-hdr-app-install](./resources/policies/oadp-hdr-app-install.yaml) and [oadp-hdr-app-restore](./resources/policies/oadp-hdr-app-restore.yaml) policies on managed clusters using the [acm-app-restore-placement](./resources/policy-sets/acm-app-restore-policy-set.yaml) rule, which is all managed clusters with a label `acm-app-restore=<backup-name>` label. The `<backup-name>` from the label is the name of the backup that will be restored on this cluster. Update the placement if you want to customize the target cluster list.

<b>Note</b>

1. The `clusterSets` list from the `acm-app-backup-placement` and `acm-app-restore-placement` Placement spec is used to dynamically select a set of managedClusters in one or multiple ManagedClusterSet. You can update the Placement clusterSets with the list of ManagedClusterSets to be used in your hub configuration. <br> <u>You need to create a ManagedClusterSetBinding resource</u> for each of the ManagedClusterSet used by your `acm-app-backup-placement` and `acm-app-restore-placement` Placement. For example, if using the `default` clusterSets, which is set by default, then you must create this resource on the hub, in the same namespace with the Placement:

```yaml
apiVersion: cluster.open-cluster-management.io/v1beta2
kind: ManagedClusterSetBinding
metadata:
  name: default
spec:
  clusterSet: default
```

2. Optionally, update the `requiredClusterSelector` from the `acm-app-backup-placement` and `acm-app-restore-placement` Placement predicates to match only the clusters where you want to backup or to restore a backup. For example, to select the clusters with label `environment=prod` use this matchExpressions:

```yaml
  predicates:
    - requiredClusterSelector:
        labelSelector:
          matchExpressions:
            - key: environment
              operator: In
              values:
                - prod
```


## List of Policies 

Policy      | Description 
-------------------------------------------| ----------- 
[oadp-hdr-app-install](./resources/policies/oadp-hdr-app-install.yaml)                       | Deploys velero using the OADP operator to all managed clusters matching the [acm-app-backup-placement](./resources/policy-sets/acm-app-backup-policy-set.yaml) placements. Installs the [OADP Operator](https://github.com/openshift/oadp-operator) using the [hdr-app-configmap](./input/restic/hdr-app-configmap.txt) `channel` and `subscriptionName` properties. Creates the cloud credentials secret used by the `DataProtectionApplication.oadp.openshift.io` to connect with the backup storage. The cloud credentials secret is set using the [hdr-app-configmap](./input/restic/hdr-app-configmap.txt) `dpaAwsBackupCloudCredentials` property. Creates the `DataProtectionApplication.oadp.openshift.io` resource used to configure [Velero](https://velero.io/). Uses hdr-app-configmap `dpaName` for the DataProtectionApplication name and hdr-app-configmap `dpaSpec` for the resource spec settings. Informs on Velero pod not running, or DataProtectionApplication not properly configured.
[oadp-hdr-app-backup](./resources/policies/oadp-hdr-app-backup.yaml)                         | Creates a velero backup schedule on managed clusters matching the [acm-app-backup-placement](./resources/placements/acm-app-backup-placement.yaml) rules. The schedule is used to backup applications resources and PVs. Informs on backup errors.
[oadp-hdr-app-restore](./resources/policies/oadp-hdr-app-restore.yaml)                        | Creates a velero restore resource on managed clusters matching the [oadp-hdr-app-restore-placement](./resources/placements/oadp-hdr-app-restore-placement.yaml) rules, which is all managed clusters with `acm-app-restore=<backup-name>` label. The `<backup-name>` from the label is the name of the backup that will be restored on this cluster. 


## Policies input data using hdr-app-configmap 


All values specified with brackets <> should be updated before applying the `hdr-app-configmap`.

hdr-app-configmap ConfigMap               | Description 
-------------------------------------------| ----------- 
backupNS                                   | Used by the [oadp-hdr-app-install](./resources/policies/oadp-hdr-app-install.yaml) policy. Namespace name where Velero/OADP is installed on the target cluster. If the hub is one of the clusters where the policies will be placed, and the `backupNS=open-cluster-management-backup` then first enable cluster-backup on `MultiClusterHub`. The MultiClusterHub resource looks for the cluster-backup option and if set to false, it uninstalls OADP from the `open-cluster-management-backup` and deletes the namespace. 
channel                                    | Used by the [oadp-hdr-app-install](./resources/policies/oadp-hdr-app-install.yaml) policy. OADP operator install channel; set to stable-1.1 by default
dpaAwsBackupCloudCredentials           | Used by the [oadp-hdr-app-install](./resources/policies/oadp-hdr-app-install.yaml) policy. Defines cloud-credential used to connect to the storage location, base64 encoded string. You must update this property with a valid value.
dpaName                                    | Used by the [oadp-hdr-app-install](./resources/policies/oadp-hdr-app-install.yaml) policy and sets the `DataProtectionApplication` resource name.
dpaSpec                                   | Used by the [oadp-hdr-app-install](./resources/policies/oadp-hdr-app-install.yaml) policy and sets the `DataProtectionApplication` spec content. The config file `dpaSpec` defines a spec configuration for an aws storage. Update this with spec content for the type of storage you are using. 
backupPrefix                              | Used by the [oadp-hdr-app-backup](./resources/policies/oadp-hdr-app-backup.yaml) policy and sets the name prefix for the backup resource. It defaults to `acm-app` so the backup name on `managed-cls-name` will be in this format : `acm-app-<volumeSnapshotLocation>-managed-cls-name-<timestamp>`. You can optionally change the prefix if you want to match the name of the application you are backing up, for example to `pacman-app` if you are backing up the pacman application; in this case the backup name becomes `pacman-app-<volumeSnapshotLocation>-managed-cls-name-<timestamp>`. The timestamp represents the time when the backup was executed and is appended by the velero Schedule creating this backup. The backup name must be less than 63 chars so in the case the name exceeds this length you should update the configMap.backupPrefix and/or configMap.backupVolumeSnapshotLocation values to keep the name at the required length.
backupSnapshotVolumes                     | Used by the [oadp-hdr-app-backup](./resources/policies/oadp-hdr-app-backup.yaml) policy. Set to `true` if you want to create backup snapshots instead of restic. This is the value used by the [pv snapshot config](./input/pv-snap/hdr-app-configmap.txt). It is set to `false` by the [restic config](./input/restic/hdr-app-configmap.txt).
backupDefaultVolumesToRestic               | Used by the [oadp-hdr-app-backup](./resources/policies/oadp-hdr-app-backup.yaml) policy. Set to `false` if you want to create backup snapshots instead of restic. This is the value used by the [pv snapshot config](./input/pv-snap/hdr-app-configmap.txt). It is set to `true` by the [restic config](./input/restic/hdr-app-configmap.txt).
backupVolumeSnapshotLocation               | Used by the [oadp-hdr-app-backup](./resources/policies/oadp-hdr-app-backup.yaml) policy, when the [pv-snap](./input/pv-snap/hdr-app-configmap.txt) is used.
backupSchedule                             | Used by the [oadp-hdr-app-backup](./resources/policies/oadp-hdr-app-backup.yaml) policy. Defines the cron schedule for creating backups.
backupTTL                                  | Used by the [oadp-hdr-app-backup](./resources/policies/oadp-hdr-app-backup.yaml) policy. Defines the expiration time for the backups.
backupNSToBackup                           | Used by the [oadp-hdr-app-backup](./resources/policies/oadp-hdr-app-backup.yaml) policy. Defines the list of namespaces to backup. It backs up all resources from these namespaces, including the PV and PVC used by the applications running in these namespaces.
backupExcludedResources                    | Used by the [oadp-hdr-app-backup](./resources/policies/oadp-hdr-app-backup.yaml) policy. Defines the list of resources to be excluded from backup. If empty, all resources from the specified namespaces are included.
restoreNSToExcludeFromRestore                         | Used by the [oadp-hdr-app-restore](./resources/policies/oadp-hdr-app-restore.yaml) policy. Defines the list of namespaces to exclude when restoring the backup file. If empty, all namespaces from the backup will be restored. 
restoreRestorePVs                          | Used by the [oadp-hdr-app-restore](./resources/policies/oadp-hdr-app-restore.yaml) policy. Set to `true` if the backup to restore had used `backupSnapshotVolumes:true`, should be set to `false` otherwise.
restoreStorageConfigName                 | Used by the [oadp-hdr-app-restore](./resources/policies/oadp-hdr-app-restore.yaml) policy. Restore storage config map resource name [class mapping](https://velero.io/docs/main/restore-reference/#changing-pvpvc-storage-classes), used when the source cluster has a different storage class than the restore cluster. You can optionally change the default value `storage-class-acm-app`. 
restore.mappings                            | Used by the [oadp-hdr-app-restore](./resources/policies/oadp-hdr-app-restore.yaml) policy and in conjunction with the  `restoreStorageConfigName`. Defines the data for the storage config map resource name. 


## Scenario

The Policies available here provide backup and restore support for stateful applications running on  managed clusters or hub. Velero is used to backup and restore applications data. The product is installed using the OADP operator, which the [oadp-hdr-app-install](./resources/policies/oadp-hdr-app-install.yaml) policy installs and configure on each target cluster.

To backup an application:
- On the hub, apply the [Backup PolicySet](./resources/policy-sets/acm-app-backup-policy-set.yaml) to install OADP and and create the backup. 
- Note that the placements use the `acm-pv-dr` label to match the managed clusters. If you plan to have multiple configurations to backup your applications then make sure you update the placement to match the subset of clusters for each configuration types. If you just keep the default placement and define multiple backup configurations, the backup policies will be applied on all managed clusters with the `acm-pv-dr` label and endup in backup policies coliding on those clusters.
- Apply the [hdr-app-configmap](./input/) and update the `backupNSToBackup` property with the list of application namespaces to backup.

To restore an application backup:
- On the hub, apply the [Restore PolicySet](./resources/policy-sets/acm-app-restore-policy-set.yaml) to install OADP and to restore the backup. 
- Note that the PolicySet placement uses the `acm-app-restore=<backup-name>` label to match the managed clusters. The `<backup-name>` from the label is the name of the backup that will be restored on those clusters. If you plan to have multiple configurations to restore your application then make sure you update the placement to match the subset of clusters for each configuration types. If you keep the default placement, the restore policies will be applied on all managed clusters with a `acm-app-restore` label and could endup in restore or install policies coliding on those clusters. 
- Apply the [hdr-app-configmap](./input/) and use `acm-app-restore=<backup-name>` label on managed clusters to restore the backup by name. 
       

## Apply policies on the hub

Create a ./resources/kustomization.yaml with this content defined below, to apply all resources from the command line. You can also apply the resources from the `./resources` folder using an application subscription.

```yaml
resources:
- policy-sets/acm-app-backup-policy-set.yaml
- policy-sets/acm-app-restore-policy-set.yaml
- policies/oadp-hdr-app-install.yaml
- policies/oadp-hdr-app-backup.yaml
- policies/oadp-hdr-app-restore.yaml
```
On the hub run `oc apply -k ./resources` to apply the backup and restore policies and placements. 

<br> <u>You need to create a ManagedClusterSetBinding resource</u> for each of the ManagedClusterSet used by your `acm-app-backup-placement` and `acm-app-restore-placement` Placement. For example, if using the `default` clusterSets, which is set by default, then you must create this resource on the hub, in the same namespace with the Placement:

```yaml
apiVersion: cluster.open-cluster-management.io/v1beta2
kind: ManagedClusterSetBinding
metadata:
  name: default
spec:
  clusterSet: default
```

The policies use the [configmaps](./input/) to configure the backup setup so you have to create a ConfigMap resource named `hdr-app-configmap` in the same namespace where the policies were applied on the hub.

Use [restic config](./input/pv-snap/hdr-app-configmap.txt) settings if you want to use Restic when backing up data. Use the [pv config](./input/pv-snap/hdr-app-configmap.txt) if you want to use Persistent Volume Snapshot instead of [Restic](https://velero.io/docs/v1.9/restic).

Make sure you <b>update all settings with valid values</b> before applying the `hdr-app-configmap` resource on the hub.

Use Restic if: 
- the PV snapshot is not supported 
- or your backup and restore clusters are running on different platforms 
- or they are in different regions and can't share PV snapshots, 
See restic limitations here https://velero.io/docs/v1.9/restic/#limitations 

PV Snapshot usage limitations:
- PVStorage for the backup resource must match the location of the PVs to be backed up. 
- You cannot backup PVs from different regions/locations in the same backup, since a backup points to only one PVStorage
-  You cannot restore a PV unless the restore resource points to the same PVStorage as the backup; so the restore cluster must have access to the PV snapshot storage location.
- PV backup is storage/platform specific; you need the same storage class usage on both source ( where you backup the PV and take the snapshots) and on target cluster ( where you restore the PV snapshot )


### Create multiple backup configurations

To create multiple backup configurations you want to deploy the install and backup policies on separate namespaces on the hub. 
You also need to update the PolicySets placements for each namespace to match the sets of clusters to apply them on. If you just keep the default placement, these policies will be applied on all managed clusters with the `acm-pv-dr` or `acm-app-restore=<backup-name>` label and could endup in backup or restore policies coliding on those clusters.

For example, if you need to backup `pacman` application running on `managed-1`, `managed-2` clusters and want to backup `mysql` on `managed-3`, you can apply the backup policy set and use 2 different namespaces:

1. For the `pacman` app:

- update the [hdr-app-configmap](./input/) ConfigMap and set `backupNSToBackup: "[\"pacman-ns\"]"`
- update the [acm-app-backup-placement](./resources/policy-sets/acm-app-backup-policy-set.yaml) Placement to match just the `managed-1`, `managed-2` clusters.
- on the hub, create the `pacman-policy-ns` namespace and apply the [backup PolicySet](./resources/policy-sets/acm-app-backup-policy-set.yaml) and updated `hdr-app-configmap` ConfigMap.

`oc project pacman-policy-ns`
`oc apply -k ./resources`


1. For the `mysql` app:

- update the [hdr-app-configmap](./input/) ConfigMap and set `backupNSToBackup: "[\"mysql-ns\"]"`
- update the [acm-app-backup-placement](./resources/policy-sets/acm-app-backup-policy-set.yaml) Placement to match just the `managed-3` cluster.
- on the hub, create the `mysql-policy-ns` namespace and apply the [backup PolicySet](./resources/policy-sets/acm-app-backup-policy-set.yaml) and updated `hdr-app-configmap` ConfigMap.

`oc project mysql-policy-ns`
`oc apply -k ./resources`


# Usage considerations

1. When restoring a backup make sure the restored namespaces don't exist on the cluster or they have the same `openshift.io/sa.scc` annotations as the namespaces in the backup. Even if the restore asks to update existing resources, the namespaces are not being updated to avoid breaking existing resources. You could have pod security violiation issues if the namespace `openshift.io/sa.scc` is not matching the pod constraints.
2. When restoring a backup make sure the restore cluster doesn't already contain PVs and PVClaims with the same name as the ones restored with the backup. The PV and PVClaims will not be updated if they already exist on the restore cluster. 
3. Using restic for backing up PVs (use the configmap from the `./policy/input/restic` folder)
    - Use this option if 
        - the PV snapshot is not supported
        - or your backup and restore clusters are running on different platforms 
        - or they are in different regions and can't share PV snapshots, 
    - See restic limitations here https://velero.io/docs/v1.9/restic/#limitations 
4. Using PV Snapshot backup (use the configmap from the  `./policy/input/pv-snap` folder)
    - PVStorage for the backup resource must match the location of the PVs to be backed up. 
    - You cannot backup PVs from different regions/locations in the same backup, since a backup points to only one PVStorage
    -  You cannot restore a PV unless the restore resource points to the same PVStorage as the backup; so the restore cluster must have access to the PV snapshot storage location.
    - PV backup is storage/platform specific; you need the same storage class usage on both source ( where you backup the PV and take the snapshots) and on target cluster ( where you restore the PV snapshot )
5. Policy template adds new data if the CRD allows: Updating the config map and reapplying it on hub could end up in duplicating resource properties. For example, if I want to update the `snapshotLocations` location property to `us-est-1`, after I update the config map I end up with a DataProtectionApplication object containing two `snapshotLocations`, one for the old value and another for the new one.  The fix would be to :
    -  delete the policy and reapply - but this removes all the resources created by the policy, so a bit too aggressive.
    - manually remove the old property - hard to do and error prone if the resource was placed on a lot of clusters


## Testing scenario

Use the pacman app to test the policies. (You can use 2 separate hubs for the sample below, each managing one cluster. Place the pacman app on the hub managing c1)

1. On the hub, have 2 managed clusters c1 and c2.
2. On the hub, create the pacman application subscription 
- create an app in the `pacman-ns` namespace, of type git and point to this app https://github.com/tesshuflower/demo/tree/main/pacman
- place this app on c1
- play the app, create some users and save the data.
- verify that you can see the saved data when you launch the pacman again.
3. On the hub, install the polices above, using the instructions from the [readme](#scenario). 


Backup step:<br>

5. On the hub, set the `backupNSToBackup: "[\"pacman-ns\"]" ` on the `hdr-app-configmap` resource. This will backup all resources from the `pacman-ns`
6. Place the install and backup policies on c1 : create this label on managed cluster c1 `acm-pv-dr=backup` and update the [acm-app-backup-placement](./resources/policy-sets/acm-app-backup-policy-set.yaml) placement to match cluster c1.


Restore step:<br>

7. Set the `acm-app-restore=<backup_name>` on cluster c2 (`<backup_name>` is a backup resource created from step 6) and update the [oadp-hdr-app-restore-placement](./resources/policy-sets/acm-app-restore-policy-set.yaml) placement to match just cluster c2. The `acm-app-restore` label is going to place the restore policy on cluster c2 and restore the `<backup_name>` passed as a value for the restore label. By updating the placement to match only c2 you make sure this policy is only targetting cluster c2, and no other cluster with a `acm-app-restore` label.
8. You should see the pacman app on c2; launch the pacman app and verify that you see the data saved when running the app on cluster c1.


# Backup and Restore Hooks

## Backup pre and post hooks 

If you want to prepare the application before running the backup, you can use the following annotations on a pod to make [Velero execute a backup hook](https://velero.io/docs/v1.9/backup-hooks/) when backing up the pod:

`pre.hook.backup.velero.io/container`
`pre.hook.backup.velero.io/command`


## Restore pre and post hooks 

If you want to run some commands pre and post restore, you can use the following annotations on a pod to make [Velero execute a restore hook](https://velero.io/docs/v1.9/restore-hooks/) when restoring the pod:


`init.hook.restore.velero.io/container-image`
The container image for the init container to be added.
`init.hook.restore.velero.io/container-name`
The name for the init container that is being added.
`init.hook.restore.velero.io/command`
This is the ENTRYPOINT for the init container being added. This command is not executed within a shell and the container image’s ENTRYPOINT is used if this is not provided.


## Example of pre and post backup hooks:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    name: mongo
  name: mongo
spec:
  replicas: 1
  selector:
    matchLabels:
      name: mongo
  template:
    metadata:
      labels:
        name: mongo
      annotations:
        pre.hook.backup.velero.io/container: mongo
        pre.hook.backup.velero.io/command: '["/sbin/fsfreeze", "--freeze", "/bitnami/mongodb/data/db"]'
        post.hook.backup.velero.io/container: mongo
        post.hook.backup.velero.io/command: '["/sbin/fsfreeze", "--unfreeze", "/bitnami/mongodb/data/db"]'
    spec:
      containers:
      - image: bitnami/mongodb:5.0.14
        name: mongo
        ports:
        - name: mongo
          containerPort: 27017
        volumeMounts:
          - name: mongo-db
            mountPath: /bitnami/mongodb/data/db
      volumes:
        - name: mongo-db
          persistentVolumeClaim:
            claimName: mongo-storage
```
