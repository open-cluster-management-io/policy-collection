## PolicySets used to backup and restore stateful application data on managed clusters

This Policysets cover:

- Persistent application backup 
- Persistent application restore

## Scenario

The Policies available here provide backup and restore support for stateful applications running on  managed clusters or hub. Velero is used to backup and restore applications data. The product is installed using the OADP operator, which the [oadp-hdr-app-install](./policies/oadp-hdr-app-install.yaml) policy installs and configure on each target cluster.

You can use these policies to backup stateful applications (policies under [oadp-hdr-app-backup-set](./policy-sets/acm-app-backup-policy-set.yaml) PolicySet) or to restore applications backups (policies under [oadp-hdr-app-restore-set](./policy-sets/acm-app-restore-policy-set.yaml) PolicySet).

The PolicySet is used to place the backup or restore policies on managed clusters.

The policies should be installed on the hub managing clusters where you want to create stateful applications backups, or the hub managing clusters where you plan to restore the application backups. 

Both backup and restore policies can be installed on the same hub, if this hub manages clusters where applications need to be backed up or restored. 

A managed cluster can be a backup target if the PlacementRule for the [oadp-hdr-app-backup-set](./policy-sets/acm-app-backup-policy-set.yaml) PolicySet includes this managed cluster.

A managed cluster can be a restore target if the PlacementRule for the [oadp-hdr-app-restore-set](./policy-sets/acm-app-restore-policy-set.yaml) PolicySet includes this managed cluster. 

A managed cluster can be both a backup and restore target, if the PlacementRule from the backup and restore PolicySets matches this cluster.

## List of PolicySets 

PolicySet                                     | Description 
-------------------------------------------| ----------- 
acm-app-backup                             | This PolicySet is used to place the [oadp-hdr-app-install](./policies/oadp-hdr-app-install.yaml) and [oadp-hdr-app-backup](./policies/oadp-hdr-app-backup.yaml) policies on managed clusters using the [acm-app-backup-placement](./policy-sets/acm-app-backup-policy-set.yaml) rule, which is all managed clusters with a label "acm-pv-dr=backup". Update the placement rule if you want to customize the target cluster list.
acm-app-restore                            | This PolicySet is used to place the [oadp-hdr-app-install](./policies/oadp-hdr-app-install.yaml) and [oadp-hdr-app-restore](./policies/oadp-hdr-app-restore.yaml) policies on managed clusters using the [acm-app-restore-placement](./policy-sets/acm-app-restore-policy-set.yaml) rule, which is all managed clusters with a label "acm-pv-dr=restore". Update the placement rule if you want to customize the target cluster list.


## List of Policies 

Policy                                     | Description 
-------------------------------------------| ----------- 
oadp-hdr-app-install                       | Deploys velero using the OADP operator to all managed clusters matching the acm-app-backup-placement or acm-app-restore-placement rules. Installs the OADP Operator using the hdr-app-configmap channel and subscriptionName properties. Creates the cloud credentials secret used by the DataProtectionApplication to connect with the backup storage. The cloud credentials secret is set using the [hdr-app-configmap](./input/restic/hdr-app-configmap.yaml) `dpa.aws.backup.cloud.credentials` property. Creates the DataProtectionApplication resource used to configure Velero. Uses hdr-app-configmap `dpaName` for the DataProtectionApplication name and hdr-app-configmap `dpa.spec` for the resource spec settings. Informs on Velero pod not running, or DataProtectionApplication not properly configured.
oadp-hdr-app-backup                         | Creates a velero backup schedule on managed clusters matching the [acm-app-backup-placement](./policy-sets/acm-app-backup-policy-set.yaml) rules. The schedule is used to backup applications resources and PVs.
oadp-hdr-app-restore                        | Creates a velero restore resource on managed clusters matching the [acm-app-restore-placement](./policy-sets/acm-app-restore-policy-set.yaml) rules. The restore resource is used to restore applications resources and PVs from a selected backup. The restore uses the `restore.nsToRestore` [hdr-app-configmap](./input/restic/hdr-app-configmap.yaml) property to specify the namespaces for the applications to restore.


## Policies input data using hdr-app-configmap 

Before you install the backup and restore Policies and PolicySets on the hub, you have to update the `hdr-app-configmap` available [here](./input/). 

You create the configmap on the hub, the same hub where the policies will be installed.

The configmap sets configuration options for the backup storage location, for the backup schedule backing up applications, and for the restore resource used to restore applications backups.

Make sure you <b>update all settings with valid values</b> before applying the `hdr-app-configmap` resource on the hub.

<b>Note</b>:

- The `dpa.spec` property defines the storage location properties. The default value shows the `dpa.spec` format for using an S3 bucket. Update this to match the type of storage location you want to use.
- You can still upate the `hdr-app-configmap` properties after the `ConfigMap` was applied to the hub. When you do that, the backup settings on the managed clusters where the PolicySet has been applied will be automatically updated with the new values for the `hdr-app-configmap`.  For example, to restore a new backup, update the `restore.backupName` property on the `hdr-app-configmap` on the hub; the change is pushed to the deployed policies on the managed cluster and a restore resource matching the new properties will be created there.

All values specified with brackets <> should be updated before applying the `hrd-app-configmap`.

hrd-app-configmap input data               | Description 
-------------------------------------------| ----------- 
backupNS                                   | Used by the [oadp-hdr-app-install](./policies/oadp-hdr-app-install.yaml) policy. Namespace name where velero/oadp is installed on the target cluster. If you want to place the application backup or restore policy on the hub, then first enable the backup and restore option on the MCH resource and use the `open-cluster-management-backup` value for the backupNS. If you don't enable the backup option on the MCH resource and use the `open-cluster-management-backup` value for the backupNS, the MCH will  delete this namespace on reconcile. 
channel                                    | Used by the [oadp-hdr-app-install](./policies/oadp-hdr-app-install.yaml) policy. OADP operator install channel; set to stable-1.1 by default
dpa.aws.backup.cloud.credentials           | Used by the [oadp-hdr-app-install](./policies/oadp-hdr-app-install.yaml) policy. Defines cloud-credential used to connect to the storage location, base64 encoded string. You must update this property with a valid value.
dpaName                                    | Used by the [oadp-hdr-app-install](./policies/oadp-hdr-app-install.yaml) policy. DataProtectionApplication resource name
dpa.spec                                   | Used by the [oadp-hdr-app-install](./policies/oadp-hdr-app-install.yaml) policy. DataProtectionApplication spec values. The config file contains a spec configuration for an aws storage. Update this with the DataProtectionApplication spec format for the type of storage you are using. 
backup.prefix                              | Used by the [oadp-hdr-app-backup](./policies/oadp-hdr-app-backup.yaml) policy. by the The name prefix for to backup resource. It is defaulted to `acm-app`. You can optionally change it if you want to match the name of the application you are backing up, for example to `pacman-app` if you are backing up the pacman application.
backup.snapshotVolumes                     | Used by the [oadp-hdr-app-backup](./policies/oadp-hdr-app-backup.yaml) policy. Set to `true` if you want to create backup snapshots. This is the value used by the [pv snapshot config](./input/pv-snap/hdr-app-configmap.yaml). It is set to `false` by the [restic config](./input/restic/hdr-app-configmap.yaml).
backup.defaultVolumesToRestic               | Used by the [oadp-hdr-app-backup](./policies/oadp-hdr-app-backup.yaml) policy. Set to `false` if you want to create backup snapshots. This is the value used by the [pv snapshot config](./input/pv-snap/hdr-app-configmap.yaml). It is set to `true` by the [restic config](./input/restic/hdr-app-configmap.yaml).
backup.schedule                             | Used by the [oadp-hdr-app-backup](./policies/oadp-hdr-app-backup.yaml) policy. Defines the cron schedule to use when creating backups.
backup.ttl                                  | Used by the [oadp-hdr-app-backup](./policies/oadp-hdr-app-backup.yaml) policy. Defines the expiration time for the backups.
backup.nsToBackup                           | Used by the [oadp-hdr-app-backup](./policies/oadp-hdr-app-backup.yaml) policy. Defines the list of namespaces to backup. Backing up all resources from these namespaces, including the PV and PVC used by the applications running in these namespaces.
restore.restorePVs                          | Used by the [oadp-hdr-app-restore](./policies/oadp-hdr-app-restore.yaml) policy. Set to `true` if the bacup to restore has used `backup.snapshotVolumes:true`, should be set to `false` otherwise.
restore.backupName                          | Used by the [oadp-hdr-app-restore](./policies/oadp-hdr-app-restore.yaml) policy. Sets the name of the backup to restore from, for example `acm-pv-schedule-vb-managed-cls-1-20230208150010`.
restore.nsToRestore                         | Used by the [oadp-hdr-app-restore](./policies/oadp-hdr-app-restore.yaml) policy. Defines the list of namespaces to restore from the backup file.
restore.storage.config.name                 | Used by the [oadp-hdr-app-restore](./policies/oadp-hdr-app-restore.yaml) policy. Restore storage config map resource name [class mapping](https://velero.io/docs/main/restore-reference/#changing-pvpvc-storage-classes), used when the source cluster has a different storage class than the restore cluster. You can optionally change the default value `storage-class-acm-app`. 
restore.mappings                            | Used by the [oadp-hdr-app-restore](./policies/oadp-hdr-app-restore.yaml) policy and in conjunction with the  `restore.storage.config.name`. Defines the data for the storage config map resource name.        

## Notes on Kustomization

Apply the PolicySets by running the [kustomization.yaml](./kustomization.yaml)

`oc apply -k ./acm-app-backup`

Update all settings with valid values before applying the `hdr-app-configmap` resource on the hub.
The `kustomization.yaml` uses the [resric config](./input/pv-snap/hdr-app-configmap.yaml), you can change it to use the [pv config](./input/pv-snap/hdr-app-configmap.yaml) if you want to use Restic instead of Persitent Volume Snapshot.

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

























