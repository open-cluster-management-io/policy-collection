## Operator Guardrails

**Name**: Operator Guardrails for OpenShift  
**Type**: RHACM PolicySet Implementation  
**Purpose**: Centralized operator compliance audit enforcement  
**Technology Stack**: Kubernetes, OpenShift, RHACM, PolicyGenerator  

---

## 📁 Repository Structure

```
guardrails-main/
└── guardrails/
    ├── README.md                                      # Original project documentation
    ├── kustomization.yml                              # Kustomize configuration
    ├── policyGenerator.yaml                           # Policy definitions
    ├── placement.yaml                                 # Cluster targeting
    └── input/
        └── auditoperators/
            ├── auditpolicy.yaml                       # Operator audit logic for ACM Policy
            ├── configmaps.yaml                        # Allowlist/denylist configs
            └── vap.yaml                               # Validating Admission Policy
```

---

## File Breakdown

### 1. **policyGenerator.yaml** 
**Purpose**: Central PolicyGenerator manifest that drives all policy generation

**Key Elements**:
- Policy Namespace: `policies`
- Placement Binding: `operator-guardrails-binding`
- Policies:
  - `audit-operator-guardrails-inform` (audit-only)
  - `audit-operator-guardrails-enforce` (enforcement)
- PolicySet: `operator-guardrails`
- interval: every 1h for non-compliant policies, every 12 h for compliant policies.
- Severity: `critical`

**Policy Generation**:
```
PolicyGenerator → Policy Objects → Placement Bindings → Managed Clusters
```

### 2. **placement.yaml** 
**Purpose**: Define which clusters receive the policies

**Configuration**:
- Kind: `Placement`
- Namespace: `policies`
- Selection Criteria: Clusters labeled with `OKE`
- Can be **modified** for environment-specific targeting

**Selector Options**:
- Label-based (current)
- Expression-based
- Namespace-based
- Custom rules

### 3. **auditpolicy.yaml** 
**Purpose**: Audit existing operators without blocking

**Architecture**:
1. **Configuration Retrieval**:
   - Reads `operator-allowlist` from hub ConfigMap
   - Reads `operator-denylist` from hub ConfigMap

2. **Operator Discovery**:
   - Scans all `Subscription` objects cluster-wide
   - Uses Kubernetes lookup functionality

3. **Compliance Logic** (Default-Deny):
   - Operator must be IN allowlist
   - Operator must NOT be IN denylist
   - If violates: generate `mustnothave` rule

4. **Output**:
   - Dummy ConfigMap (placeholder for policy)
   - Violations for non-compliant subscriptions

**Template Variables**:
- `$allowlist` - Allowlist packages
- `$denylist` - Denylist packages
- `$subscriptions` - All operator subscriptions
- `$allowedPackages` - Array of allowed names
- `$deniedPackages` - Array of denied names

### 4. **configmaps.yaml** 
**Purpose**: Store operator allowlist and denylist

**Structure**:

```yaml
# ConfigMap 1: Allowlist
Name: operator-allowlist
Namespace: policies
Data:
  packages: "web-terminal, openshift-gitops-operator"

# ConfigMap 2: Denylist
Name: operator-denylist
Namespace: policies
Data:
  packages: "cluster-logging, compliance-operator"
```

**Default Operators**:
- **Allowed**: web-terminal, openshift-gitops-operator
- **Denied**: cluster-logging, compliance-operator

**Format**: Comma-separated values (CSV)

### 5. **vap.yaml** 
**Purpose**: Enforce operator restrictions via Validating Admission Policy

**Policy Details**:

**Kind**: `ValidatingAdmissionPolicy`
- **Name**: `operator-guardrails-vap`
- **Failure Policy**: Ignore (warns, doesn't block)
- **API Groups**: `operators.coreos.com`
- **Operations**: CREATE, UPDATE
- **Resources**: subscriptions

**Validation Rules**:
```
operator.spec.name IN allowedPackages 
  AND 
operator.spec.name NOT IN deniedPackages
```

**Variables**:
- `operatorName` - Operator being created/updated
- `allowedPackages` - Split from allowlist ConfigMap
- `deniedPackages` - Split from denylist ConfigMap

**Binding**:
```yaml
Kind: ValidatingAdmissionPolicyBinding
Name: operator-guardrails-vap-binding
ValidationActions: ["Warn"]
MatchResources: All namespaces
```

**User Experience**:
- When user creates disallowed operator
- API returns warning message
- Request succeeds (non-blocking) could be configured
- Message: `"The operator "X" is either not on the allowlist or is explicitly denied."`
- you will see Policy Violation highlighting operator name 

### 6. **kustomization.yml** 
**Purpose**: Kustomize build configuration

**Generators**:
- Specifies `policyGenerator.yaml` as generator
- Enables `kustomize build` workflow

**Build Flow**:
```
$ kustomize build .
  ↓
Processes policyGenerator.yaml
  ↓
Generates Policy objects
  ↓
Creates Placement bindings
  ↓
Outputs Kubernetes manifests
```

---

## 🎯 Key Features Analysis

### 1. **Default-Deny Security Model**
- ✅ Whitelist-first approach
- ✅ Explicit denylist for exceptions
- ✅ Prevents unauthorized operator installation
- ✅ Reduces attack surface

### 2. **Dual-Mode Operation**
- ✅ **Audit Mode** (Inform): Monitor without blocking
- ✅ **Enforce Mode**: Active policy enforcement
- ✅ Transition from audit → enforce safely

### 3. **Dynamic Configuration**
- ✅ ConfigMap-based allowlist/denylist
- ✅ No policy redeployment for updates
- ✅ Changes sync automatically
- ✅ Hub-centric management

### 4. **Admission Control**
- ✅ Kubernetes-native VAP
- ✅ Real-time operator validation
- ✅ User-friendly warning messages
- ✅ Non-blocking enforcement option

---

## 🔄 Workflow Summary

### Deployment Flow

```
1. Update ConfigMaps (allowlist/denylist)
   ↓
2. Deploy policyGenerator.yaml
   ↓
3. Kustomize generates Policies & PolicySet
   ↓
4. Placement applies to labeled clusters
   ↓
5. Hub sends policies to managed clusters
   ↓
6. Policy agent evaluates compliance
   ↓
7. VAP prevents unauthorized operators (by default it just shown a warning!)
   ↓
8. RHACM dashboard shows compliance status with the operator which violates to cluster
```

### Operator Installation Attempt

```
User tries to create Subscription
  ↓
VAP intercepts CREATE request
  ↓
Check: operator IN allowlist?
Check: operator NOT IN denylist?
  ↓
If Valid: ✅ Creation succeeds
If Invalid: ⚠️ Warning issued, creation proceeds
```

---

## 🔐 Security Considerations

1. **Default-Deny**: Only approved operators allowed
2. **Centralized Control**: Single source of truth on hub
3. **Audit Trail**: All decisions logged
4. **Non-Blocking**: Can be easily configured


### Recommendations
1. Monitor VAP warnings regularly
2. Regularly audit allowlist/denylist
3. Document operator approval process
4. Implement approval workflow for allowlist changes
5. Set up alerts for policy violations

---

## 🚀 Extension Points

### Possible Enhancements


1. Integration with **OperatorPolicy** feature

2. **Automated Compliance Reporting**
   - Weekly compliance summaries
   - Trend analysis
   - Risk scoring

---

## 📚 Technology Stack

| Component | Version | Purpose |
|-----------|---------|---------|
| Kubernetes | 1.26+ | Base platform |
| OpenShift | 4.10+ | Container platform |
| RHACM | 2.4+ | Policy management |
| PolicyGenerator | 1.x | Policy generation |
| VAP | v1 | Admission control |
| Kustomize | 3.x+ | Build tool |

---

## 🔗 Dependencies

### Required
- RHACM 
- OpenShift Operator Framework
- Kubernetes Validating Admission Policies 

### Optional
- Git (for version control)
- Kustomize CLI (for builds)
- kubectl (for testing)

---

## 📋 Use Cases

### Enterprise Governance
✅ Control operator sprawl across clusters  
✅ Enforce security policies organization-wide  
✅ Compliance with regulatory requirements  

### Development Teams
✅ Provide safe operator installation  
✅ Prevent misconfiguration  
✅ Audit operator usage  

### Operations Teams
✅ Centralized operator management  
✅ Reduce support overhead  
✅ Consistent cluster configuration  

---

## 💡 Next Steps

1. **Customize** operator allowlist/denylist
2. **Test** in non-production clusters
3. **Deploy** to production with audit mode
4. **Monitor** compliance dashboard
5. **Transition** to enforce mode when ready
6. **Automate** allowlist updates via GitOps

---

## Support & Documentation

- **RHACM Docs**: https://access.redhat.com/documentation/rhacm/
- **PolicyGenerator**: PolicyGenerator documentation in RHACM
- ** community policy not officially supported by RedHat
- **VAP Docs**: Kubernetes admission control documentation
- **OpenShift**: https://docs.openshift.com/

---
