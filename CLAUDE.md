# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the **policy-collection** repository for Open Cluster Management (OCM). It contains a collection of governance policies that can be deployed to Kubernetes/OpenShift clusters through OCM's policy framework. Policies are used to enforce security, compliance, and configuration standards across managed clusters.

## Repository Structure

Policies are organized in two primary ways:

### By Support Level
- **stable/** - Policies supported by the Open Cluster Management Policy SIG
- **community/** - Policies contributed by the open source community (contributions start here)
- **3rd-party/** - Policies supported by third parties (not by OCM Policy SIG)

### By NIST 800-53 Security Control Families
Within each support level folder, policies are organized by NIST Special Publication 800-53 control families:
- **AC-Access-Control/** - RBAC, authentication, authorization policies
- **CA-Security-Assessment-and-Authorization/** - Compliance operator installation
- **CM-Configuration-Management/** - Operators, deployments, cluster configuration
- **SC-System-and-Communications-Protection/** - Certificates, encryption, security contexts
- **SI-System-and-Information-Integrity/** - Container scanning, runtime security
- **AU-Audit-and-Accountability/** - Logging and audit configurations

### Policy Generator Projects
- **policygenerator/** - Contains Policy Generator examples and PolicySet projects
  - **policy-sets/stable/** - Tested and supported PolicySets (e.g., openshift-plus, acm-hardening)
  - **policy-sets/community/** - Community-contributed PolicySets (e.g., gatekeeper, kyverno, ocp-best-practices)
  - **kustomize/** - Example manifests demonstrating Policy Generator usage

## Policy Architecture

### Policy Anatomy
Policies in this repository follow the OCM policy structure:

```yaml
apiVersion: policy.open-cluster-management.io/v1
kind: Policy
metadata:
  name: policy-name
  annotations:
    policy.open-cluster-management.io/standards: NIST SP 800-53
    policy.open-cluster-management.io/categories: <Control Family>
    policy.open-cluster-management.io/controls: <Specific Control>
spec:
  remediationAction: inform  # or enforce
  disabled: false
  policy-templates:
    - objectDefinition:
        apiVersion: policy.open-cluster-management.io/v1
        kind: ConfigurationPolicy
        # ... policy definition
```

### Policy Distribution
Policies are distributed to managed clusters using four components (all in same namespace):
1. **Policy** - Groups policy templates, smallest deployable unit on hub
2. **Placement** - Selects target managed clusters (replaces deprecated PlacementRule)
3. **PlacementBinding** - Binds Placement to Policy/PolicySet
4. **ManagedClusterSetBinding** - Makes cluster sets available for Placement selection

### Policy Engines
The repository supports multiple policy engines:
- **OCM ConfigurationPolicy** - Native OCM configuration enforcement
- **Gatekeeper** - OPA-based admission control (policies auto-expanded by generator)
- **Kyverno** - Kubernetes-native policy engine (policies auto-expanded by generator)

## Policy Generator

The Policy Generator is a Kustomize plugin that automatically wraps Kubernetes manifests in OCM policies. Key features:
- Converts standard Kubernetes YAML into OCM Policy resources
- Auto-expands Gatekeeper/Kyverno policies with additional compliance detection
- Configured via `policyGenerator.yaml` files in Kustomize directories
- Binary located at: `bin/policy-generator-plugin/PolicyGenerator`

### Policy Generator Workflow
1. Place manifests in a directory (e.g., `policygenerator/kustomize/policy1_deployment/`)
2. Create `policyGenerator.yaml` defining policy name and manifest paths
3. Create `kustomization.yaml` referencing the generator
4. Generate: `kustomize build --enable-alpha-plugins`

## GitOps Deployment

### Using Application Lifecycle (default)
```bash
cd deploy
./deploy.sh -u <git-url> -b <branch> -p <path> -n <namespace>
```

Parameters:
- `-u` - Git repository URL (default: policy-collection main repo)
- `-b` - Branch name (default: main)
- `-p` - Path to policies subdirectory (default: stable)
- `-n` - Target namespace (default: policies)
- `-s` - Sync rate: high/medium/low/off (default: medium)
- `--deploy-app` - Create Application resource for UI visibility

**Important**: You must be a Subscription Administrator. Add yourself to the `open-cluster-management:subscription-admin` ClusterRoleBinding if needed.

### Using ArgoCD
```bash
cd deploy
./argoDeploy.sh -u <git-url> -b <branch> -p <path> -n <namespace>
```

## Validation and Testing

### Validate Policies Locally
Run the validation script to check policy syntax:
```bash
./build/validate-policies.sh
```

This script:
1. Installs kubeconform for YAML validation
2. Downloads OCM CRD schemas for validation
3. Validates all policies in stable/ and community/
4. Installs kustomize and Policy Generator plugin
5. Validates all PolicySet projects by building them

### CI/CD Validation
- GitHub Actions workflow: `.github/workflows/validate.yml`
- Runs on all PRs and pushes to main
- Executes `./build/validate-policies.sh`

## Contributing Policies

### Contribution Workflow
1. Fork the repository
2. Create feature branch: `git checkout -b <policy-name>`
3. Add policy YAML to appropriate `community/<NIST-Category>/` folder
4. Update the community README table with policy details
5. Set policy to `remediationAction: inform` by default (unless creating resources)
6. Test policy on an OCM cluster
7. Add DCO sign-off: `git commit -s -m "message"`
8. Create PR to `policy-collection` repository
9. Add OWNERS as reviewers

### Policy Requirements
- Must include NIST 800-53 annotations in metadata
- Must start in community folder (can be promoted to stable later)
- Enforcement policies should only create resources (operators, etc.)
- Configuration policies should default to `inform` mode
- Never include secrets/credentials in policy YAML - use hub templates
- Must validate using `./build/validate-policies.sh`

### Required Annotations
```yaml
metadata:
  annotations:
    policy.open-cluster-management.io/standards: NIST SP 800-53
    policy.open-cluster-management.io/categories: <Control Family>
    policy.open-cluster-management.io/controls: <Control ID>
```

### README Updates
When adding a policy, update the corresponding README.md table:
- `stable/README.md` for stable policies
- `community/README.md` for community policies
- Include: policy name (linked), description, prerequisites

## Policy Templatization

Policies support Go template functions for dynamic configuration:

### Hub Templates
Retrieve data from hub cluster resources:
```yaml
'{{hub fromConfigMap "namespace" "configmap" "key" hub}}'
'{{hub .ManagedClusterName hub}}'
```

### Managed Cluster Templates
Retrieve data from target managed cluster:
```yaml
'{{fromClusterClaim "claim-name"}}'
'{{fromSecret "namespace" "secret" "key"}}'
'{{lookup "v1" "Namespace" "" "default"}}'
```

### Template Functions
- `fromConfigMap`, `fromSecret` - Retrieve values from resources
- `fromClusterClaim` - Get cluster claim values
- `lookup` - Query Kubernetes API
- `base64enc`, `base64dec` - Encoding functions
- `toBool`, `toInt` - Type conversion
- Standard Go template functions (`eq`, `ne`, `if`, etc.)

## Key Concepts

### Placement vs PlacementRule
- **PlacementRule** - DEPRECATED, unrestricted cluster access
- **Placement** - Current approach, requires ManagedClusterSetBinding for security
- Placement uses `spec.predicates.requiredClusterSelector.labelSelector` for cluster selection

### PolicySets
Group related policies for easier management:
- Located in `policygenerator/policy-sets/`
- Examples: openshift-plus (ACS, Compliance, Quay), acm-hardening
- Built using Policy Generator with multiple policy inputs

### Remediation Actions
- **inform** - Report compliance, don't modify cluster (default for config policies)
- **enforce** - Automatically remediate non-compliant resources
- Can be set at Policy level (overrides template level) or ConfigurationPolicy level

## Common Operations

### Deploy Policies via GitOps
```bash
# Create policies namespace
kubectl create ns policies

# Deploy from this repository (stable policies)
cd deploy
./deploy.sh -u https://github.com/open-cluster-management-io/policy-collection.git \
            -b main -p stable -n policies

# Deploy from a fork
./deploy.sh -u https://github.com/<your-org>/policy-collection.git \
            -b main -p community -n policies
```

### Generate Policies Locally
```bash
cd policygenerator/kustomize
kustomize build --enable-alpha-plugins
```

### Remove Deployed Policies
```bash
cd deploy
./remove.sh -n <namespace> -a <resource-prefix>
```

### Test Policy on Cluster
```bash
kubectl create -f <policy-file.yaml> -n <namespace>
kubectl get policy -n <namespace>
kubectl describe policy <policy-name> -n <namespace>
```

## Important Notes

- **Never** commit credentials, API keys, or secrets to policies
- Policies in stable/ are officially supported; community/ policies may require additional controllers
- Some policies require operators (Gatekeeper, Kyverno, Compliance Operator) to be installed first
- Policy Generator auto-expands Gatekeeper/Kyverno policies with violation detection
- Use `--enable-alpha-plugins` flag when running kustomize with Policy Generator
- Hub templates require OCM 2.4+ (RHACM 2.6+); standalone hub templating requires 2.13+
