# ACM Hub PV backup and restore using volsync

ACM Hub PVC backup and restore with volsync using ACM policies 

Hub PVC with the `cluster.open-cluster-management.io/volsync` label are being backed up and could be restored on another hub using these volsync policies. The PVC label's value can be any string.

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: global-hub-postgres-0
  namespace: global-hub
  labels:
    cluster.open-cluster-management.io/volsync: gh
spec:
```

------

- [List of PolicySets](#list-of-policysets)
- [List of Policies](#list-of-policies)
- [Policies configuration files](#policies-configuration-files)
  - [Backup hub policies](#backup-hub-policies)
  - [Restore hub policies](#restore-hub-policies)
- [Scenario](#scenario)
- [References](#references)

------



## List of PolicySets 

PolicySet   | Description 
-------------------------------------------| ----------- 
[acm-volsync-policyset](./acm-volsync-policyset.yaml)   | This PolicySet is used to place the volsync policies on the hub, using the placement which matches the `local-cluster` or any managed cluster with the `is-hub=true` label. Using this label the policy can be placed on any managed cluster where the ACM operator is installed.

![Volsync PolisySet](images/policyset.png)

## List of Policies 

Policy      | Description 
-------------------------------------------| ----------- 
[acm-volsync-config](./acm-volsync-config.yaml)                       | Trigerred to run on the hub only if the hub has any PVCs with the `cluster.open-cluster-management.io/volsync` label. It installs the volsync-addon on the hub or any managed cluster matching the `acm-volsync-policyset` PolicySet's placement. It reports on volsync missing configuration: reports if the user had not create the `restic-secret` Secret and `volsync-config` ConfigMap resources under the PolicySet namespace. The Secret is used by volsync to connect to the storage location where the PVC snapshot is stored. The ConfigMap is used to define the ReplicationSource configuration, as defined [here](https://access.redhat.com/login?redirectTo=https%3A%2F%2Faccess.redhat.com%2Fdocumentation%2Fen-us%2Fred_hat_advanced_cluster_management_for_kubernetes%2F2.8%2Fhtml%2Fbusiness_continuity%2Fbusiness-cont-overview%23restic-backup-volsync).
[acm-volsync-source](./acm-volsync-source.yaml)                         | Creates a volsync ReplicationSource for all PVCs with the `cluster.open-cluster-management.io/volsync` label.
[acm-volsync-destination](./acm-volsync-destination.yaml)                        | In a restore hub backup operation, when the credentials backup is restored on a new hub, it creates a volsync ReplicationDestination for all PVCs with the `cluster.open-cluster-management.io/volsync` label. This is because the  `acm-volsync-source` creates a set of configuration ConfigMaps defining the PVCs for which a snapshot is stored. These ConfigMaps have the `cluster.open-cluster-management.io/backup` backup label so thy are backed up by the hub credentials backup. They are used to recreate the PVCs on the restore hub.


### Policies 

![Volsync Policies](images/policies.png)


### Configuration Policy

The `acm-volsync-config` Policy validates the configuration for both types of hubs ( backup or restore ). If any PVC is found with the cluster.open-cluster-management.io/volsync label, it installs the volsync addon and verifies the user had created the restic-secret used to connect to the storage where the snapshot are saved.


![Volsync Config Policy](images/config_policy.png)

### Backup Hub Policies

Volsync Source Policy:

![Volsync Source Policy](images/backup_source_policy.png)

Volsync Source Policy Templates:

![Volsync Source Policy](images/backup_source_policy_1.png)

Policy acm-volsync-destination is not running since this is identified as a backup hub :

![Volsync Destination Policy](images/backup_dest_policy.png)

### Restore Hub Policies

Volsync Destination Policy:

![Volsync Destination Policy](images/restore_dest_policy.png)

Volsync Destination Policy Templates:

![Volsync Destination Policy Templates](images/restore_dest_policy_1.png)

Policy acm-volsync-source is not running since this is identified as a restore hub : 

![Volsync Destination Policy](images/restore_source_policy.png)

## Policies configuration files


volsync label cluster.open-cluster-management.io/volsync set on PVC

```
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
 name: mongo-storage
 namespace: pacman-restore
 finalizers:
   - kubernetes.io/pvc-protection
 labels:
   cluster.open-cluster-management.io/volsync: pacman-restore
spec:
 accessModes:
   - ReadWriteOnce
 resources:
   requests:
     storage: 8Gi
 volumeName: pvc-3b5b2975-77a4-452f-b14f-8eefed7454a5
 storageClassName: gp3-csi
 volumeMode: Filesystem
```


### Created by the ACM user

#### volsync-config

Created by the user on the backup hub. 
Used to define the volsync ReplicationSource configuration, as defined [here](https://access.redhat.com/login?redirectTo=https%3A%2F%2Faccess.redhat.com%2Fdocumentation%2Fen-us%2Fred_hat_advanced_cluster_management_for_kubernetes%2F2.8%2Fhtml%2Fbusiness_continuity%2Fbusiness-cont-overview%23restic-backup-volsync)


```
kind: ConfigMap
apiVersion: v1
metadata:
 name: volsync-config
 namespace: open-cluster-management-backup
 labels:
   cluster.open-cluster-management.io/backup: cluster-activation
data:
 cacheCapacity: 1Gi
 copyMethod: Snapshot
 pruneIntervalDays: '2'
 repository: restic-secret-vb
 retain_daily: '2'
 retain_hourly: '3'
 retain_monthly: '1'
 trigger_schedule: 0 */2 * * *
```


#### restic-secret

Created by the user

Used to define the volsync ReplicationSource configuration, as defined [here](https://access.redhat.com/login?redirectTo=https%3A%2F%2Faccess.redhat.com%2Fdocumentation%2Fen-us%2Fred_hat_advanced_cluster_management_for_kubernetes%2F2.8%2Fhtml%2Fbusiness_continuity%2Fbusiness-cont-overview%23restic-backup-volsync)


```
kind: Secret
apiVersion: v1
metadata:
 name: restic-secret
 namespace: open-cluster-management-backup
 labels:
   cluster.open-cluster-management.io/backup: volsync
data:
 AWS_ACCESS_KEY_ID: a2V5
 AWS_SECRET_ACCESS_KEY: a2V5
 RESTIC_PASSWORD: a2V5
 RESTIC_REPOSITORY: >-
 czM6aHR0cDovL21pbmlvLm1pbmlvLnN2Yy5jbHVzdGVyLmxvY2FsOjkwMDAvbXktYnVja2V0
type: Opaque
```


### Generated by the policy 

#### volsync-config-info-<pvc_name>

Created by the volsync policy on the backup hub, for each PVC; uses the PVCs settings
This resource is backed up and used by the volsync ReplicationDestination to recreate the PV on the restore hub.

```
kind: ConfigMap
apiVersion: v1
metadata:
 name: volsync-config-info-mongo-storage
 namespace: pacman-ns
 labels:
   cluster.open-cluster-management.io/backup: cluster-activation
data:
 resources.accessModes: ReadWriteOnce
 resources.requests.storage: 8Gi
 storageClassName: gp3-csi
 volumeMode: Filesystem
```

 
#### volsync-config-pvcs

Created by the policy on the backup hub; lists all PVCs that need to be restored. This resource is backed up

```
kind: ConfigMap
apiVersion: v1
metadata:
 name: volsync-config-pvcs
 namespace: open-cluster-management-backup
 labels:
   app: volsync-config-pvcs
   cluster.open-cluster-management.io/backup: cluster-activation
 data:
 pvcs: 'pacman-restore#mongo-storage##pacman-vb#mongo-storage##pacman#mongo-storage'
```




## Scenario

ACM components installed on the hub.
User adds the cluster.open-cluster-management.io/volsync  label to the PVC to be backed up.


ACM user, on Primary hub:
1. Enables backup on MultiClusterHub. This installs the hub backup component
2. The user manually installs the policy from the community project
3. Creates a BackupSchedule 
  - The volsync policy informs the user if missing the volsync restic-secret secret and volsync-config ConfigMap 
3. User creates the restic-secret secret and volsync-config ConfigMap 
4. Policy installs volsync addon on hub and creates the volsync `ReplicationSources` for all PVCs with the volsync label


ACM user, on Restore hub:
5. Enables backup on MultiClusterHub. This installs the hub backup component
  - The user manually installs the policy from the community project
6. Creates an ACM Restore resource and restores active data
  - The policy creates the volsync `ReplicationDestination` for all PVCs defined in the restored volsync-config-pvcs ConfigMap
  - the app using the PVC must be restored after the PVC is created 

## References
- [Volsync](https://access.redhat.com/login?redirectTo=https%3A%2F%2Faccess.redhat.com%2Fdocumentation%2Fen-us%2Fred_hat_advanced_cluster_management_for_kubernetes%2F2.8%2Fhtml%2Fbusiness_continuity%2Fbusiness-cont-overview%23restic-backup-volsync)


       

