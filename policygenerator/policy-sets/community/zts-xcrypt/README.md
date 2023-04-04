# Zettaset Xcrypt PolicySet

**Note**: This has been tested successfully to encrypt a mariadb application pvc.

## Prerequisites

On the Managed Cluster:

Label the nodes:

Apply labels to worker nodes:

```
    % oc get nodes|grep worker
    ip-10-0-143-90.us-east-2.compute.internal    Ready      worker   110d   v1.19.0+e49167a
    ip-10-0-190-63.us-east-2.compute.internal    Ready      worker   110d   v1.19.0+e49167a
    ip-10-0-207-48.us-east-2.compute.internal    Ready      worker   110d   v1.19.0+e49167a

    Apply labels to nodes:
    $ oc label nodes ip-10-0-143-90.us-east-2.compute.internal zts-master=true
    $ oc label nodes ip-10-0-190-63.us-east-2.compute.internal zts-worker=true
    $ oc label nodes ip-10-0-207-48.us-east-2.compute.internal zts-worker=true
```

## Installation

The Zettaset PolicySet contains a single `policyset-xcrypt` that will be deployed on the Cluster Management hub cluster.  The Zettaset Xcrypt operator is deployed onto all OpenShift managed clusters with the label `dev`.

1. To install Xcrypt using this PolicySet, you must first have installed the 
   policy that installs the Zettaset Image Pull Secret and the Zettaset Configuration 
   file.
   Please contact Zettaset for this.
2. Run the command: 
```
   oc create -f policy-zts-xcrypt-version-1.yaml.
   This command installs the Xcrypt operator on the Managed Cluster and needs to be run on the Hub Cluster.
```
3. Make sure all the pods are running on the managed cluster.

```
    [docker@localhost managed]$ oc get pods -n zts-xcrypt
    NAME                                   READY   STATUS    RESTARTS   AGE
    zts-csi-controller-7576b65bf7-6gs5v    4/4     Running   0          21m
    zts-csi-node-84wlr                     3/3     Running   0          21m
    zts-csi-node-bz2sk                     3/3     Running   0          21m
    zts-masterset-ca-429bz                 1/1     Running   0          21m
    zts-masterset-hm-r4gkt                 1/1     Running   0          21m
    zts-masterset-hm-v7ss8                 1/1     Running   0          21m
    zts-masterset-kmip-fsdkr               1/1     Running   0          21m
    zts-masterset-ls-7nrn5                 1/1     Running   0          21m
    zts-xcrypt-operator-68f4d949c6-mzxqs   1/1     Running   0          21m
```
 
4.  Follow the post installation steps for Xcrypt 
```
    [docker@localhost managed]$ oc exec -it  zts-masterset-ls-64f8g -n zts-xcrypt -- /usr/share/zts/bin/edit_nodes.sh   -a zts-masterset-hm-kglph
    [docker@localhost managed]$ oc exec -it  zts-masterset-ls-64f8g -n zts-xcrypt -- /usr/share/zts/bin/edit_nodes.sh   -a zts-masterset-hm-mvsp2

    [docker@localhost managed]$ oc exec -it zts-masterset-hm-mvsp2 -n zts-xcrypt -- bash

    [root@zts-masterset-hm-mvsp2 container]# /usr/share/zts/bin/add_device.sh -d /dev/xvdf -s 15

    [docker@localhost managed]$ oc exec -it zts-masterset-hm-kglph -n zts-xcrypt -- bash
    [root@zts-masterset-hm-kglph container]#  /usr/share/zts/bin/add_device.sh -d /dev/xvdf -s 15
```

5.  Create an application from Open Cluster Management
```
    Application: mariadb
    Namespace: mariadb
    Git:        https://github.com/mahesh-zetta/rhacm-demo.git
    Branch: master
    Cluster label: environment
    Cluster label value: dev

    Note the encryption on the mariadb pod
    e.g:

    [docker@localhost managed]$ oc exec -it mariadb-5f7b6fc68d-88z4r -n mariadb -- df | grep zts

```
