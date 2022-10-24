# PolicySets -- Red Hat Telescope

Real-time Security Governance, Compliance, and Risk Automation for Enhanced DevSecOps

## PolicySet details

Policies install into the `open-cluster-management-global-set` namespace.
Telescope installs into the `telescope` namespace and the placement deploys telescope only to the hub cluster.
  - 10 GB PVC for the telescope database
  - Postgresql helm chart
  - Telescope backend helm chart
  - Telescope frontend helm chart

## Prerequisites

 - ACM 2.6 for the `open-cluster-management-global-set` namespace.

**Note**: The `PolicySet` uses cluster `Placement` and not the `PlacementRule` placement mechanism.
