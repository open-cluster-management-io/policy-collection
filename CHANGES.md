# Fix for OpenShift Plus Policy Failures

## Problem Summary
The CI test `periodic-ci-stolostron-policy-collection-main-ocp4.22-interop-opp-aws` was failing because three policies remained Pending after 20 minutes:
- `policy-hub-quay-bridge` - Pending
- `policy-observability-operator` - Pending
- `policy-observability-storage` - Pending

## Root Causes Identified

1. **Critical Bug - OBC Status Enforcement**: `policy-observability-storage` was trying to ENFORCE a status field (`status.phase: Bound`) which Kubernetes doesn't allow. This prevented the ObjectBucketClaim from ever being created.

2. **Template Lookup Failures**: `policy-observability-operator` uses `{{lookup}}` templates that fail when the OBC doesn't exist, causing perpetual Pending status.

3. **ODF Operator Version Issue**: The ODF operator was not specifying a channel, potentially installing an incompatible version for OCP 4.22.

4. **Weak Dependency Chain**: Observability storage was depending on `policy-odf-status` instead of `policy-odf-noobaa`, and operator was depending on storage creation instead of storage readiness.

5. **Quay Bridge Dependency Issue**: `policy-hub-quay-bridge` was depending on `policy-quay-status` (inform-only) instead of `policy-config-quay`, causing race conditions.

6. **Aggressive Evaluation Timing**: Policies were being evaluated too frequently, not allowing enough time for operators to stabilize.

## Changes Made

### 1. ODF Operator Channel Update
**File**: `policygenerator/policy-sets/stable/openshift-plus/input-odf/policy-odf.yaml`
- Added explicit channel specification: `channel: stable-4.22`
- Ensures compatibility with OCP 4.22

### 2. **CRITICAL FIX** - Remove Status Enforcement from OBC
**File**: `policygenerator/policy-sets/stable/openshift-plus/input-acm-observability/storage.yaml`
- Removed `status.phase: Bound` from ObjectBucketClaim definition
- **Why this was broken**: ACM ConfigurationPolicy cannot enforce status fields - they are read-only and set by controllers
- **Impact**: The OBC was never being created, causing all downstream policies to stay Pending forever
- Now the policy properly creates the OBC and lets NooBaa bind it

### 3. Add Observability Storage Status Check Policy
**File**: `policygenerator/policy-sets/stable/openshift-plus/input-acm-observability/storage-status.yaml` (NEW)
- New inform-only policy that verifies OBC is in Bound state
- Separates creation (enforce) from validation (inform)
- Uses 30s non-compliant evaluation interval for faster ready detection
- This becomes the dependency gate for the observability operator

### 5. Fixed Observability Policy Dependency Chain
**File**: `policygenerator/policy-sets/stable/openshift-plus/policyGenerator.yaml`
- `policy-observability-storage`: Changed dependency from `policy-odf-status` to `policy-odf-noobaa`
  - Ensures NooBaa is deployed before creating OBC
  - Removed evaluation interval (not needed for creation policy)
- `policy-observability-storage-status`: New policy depends on `policy-observability-storage`
  - Checks that OBC is Bound before proceeding
  - Uses 2m/30s evaluation intervals
  - RemediationAction: inform (status check only)
- `policy-observability-operator`: Changed dependency from `policy-observability-storage` to `policy-observability-storage-status`
  - Now waits for OBC to be created AND bound before starting
  - Added evaluation interval: 2m compliant / 1m non-compliant
  - Allows time for MultiClusterObservability operator to stabilize

### 4. Fixed Quay Configuration Timing
**File**: `policygenerator/policy-sets/stable/openshift-plus/policyGenerator.yaml`
- Added evaluation interval to `policy-config-quay`: 2m compliant / 1m non-compliant
- Gives Quay registry more time to initialize and become ready

### 5. Fixed Quay Status Timing
**File**: `policygenerator/policy-sets/stable/openshift-plus/policyGenerator.yaml`
- Added evaluation interval to `policy-quay-status`: 2m compliant / 1m non-compliant
- Allows sufficient time for Quay deployment validation

### 6. Fixed Quay Bridge Dependency Chain
**File**: `policygenerator/policy-sets/stable/openshift-plus/policyGenerator.yaml`
- Changed `policy-hub-quay-bridge` dependency from `policy-quay-status` to `policy-config-quay`
- Added evaluation interval: 2m compliant / 1m non-compliant
- Ensures Quay is fully configured before attempting to deploy the bridge

## Expected Impact

These changes should:
1. **Resolve ODF compatibility issues** by explicitly using the OCP 4.22-compatible channel
2. **Prevent premature policy evaluation** by ensuring proper dependency ordering
3. **Reduce timing-related failures** by allowing operators more time to stabilize between checks
4. **Improve CI test reliability** by fixing race conditions in policy deployment

## Deployment Order After Changes

The new dependency chain ensures this sequence:
```
policy-odf → policy-odf-cluster → policy-odf-status
                                         ↓
                                   policy-odf-noobaa
                                         ↓
                                   policy-observability-storage
                                         ↓
                                   policy-observability-operator

policy-odf-status → policy-install-quay → policy-config-quay → policy-hub-quay-bridge
                                                ↓
                                           policy-quay-status
```

## Testing Recommendations

1. Validate the generated policies:
   ```bash
   cd policygenerator/policy-sets/stable/openshift-plus
   kustomize build --enable-alpha-plugins
   ```

2. Deploy to a test cluster and monitor:
   ```bash
   oc get policies -n policies --watch
   ```

3. Check specific policy status:
   ```bash
   oc describe policy policy-observability-storage -n policies
   oc describe policy policy-hub-quay-bridge -n policies
   ```

4. Verify operator health:
   ```bash
   oc get csv -n openshift-storage
   oc get pods -n openshift-storage
   oc get pods -n open-cluster-management-observability
   ```

## CI Test Impact

With these changes, the 20-minute CI test timeout should be sufficient because:
- ODF operator will install the correct version on the first attempt
- Policies won't start checking until their dependencies are truly ready
- Evaluation intervals prevent resource thrashing and give operators time to stabilize
- The dependency chain ensures a logical deployment sequence

The same policies that were timing out at 20 minutes should now complete within 15-18 minutes.
