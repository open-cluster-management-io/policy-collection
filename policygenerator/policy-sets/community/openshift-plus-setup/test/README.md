# Test files for validation

## Using the dryrun command

The Policy Framework has a policytools command that includes a dryrun ability to process
ConfigurationPolicy resources to make sure templates work as expected.  This test 
directory contains resources to test the machine set policy for aws and vsphere
environments, without requiring a cluster to be installed.

## Procedure

Download the `policytools` command.  It is available from the OpenShift console when
Red Hat Advanced Cluster Management for kubernetes is installed. After downloading,
extract the downloaded file and add the command to your path.

To begin offline testing, first make sure you also have `kustomize` installed and that
you have installed the `PolicyGenerator` plugin.  See 
[Policy Generator](https://github.com/open-cluster-management-io/policy-collection/tree/main/policygenerator)
for more details.

- Generate the project and save the output: `kustomize build --enable-alpha-plugins > test/generated-content.yaml`
- In the test directory, edit the generated file and remove all content until you get to the policy being tested.  In this case we want to test the Policy named `policy-opp-prereq-machines`
- Perform the policy dryrun from the test directory: `policytools dryrun -p generated-content.yaml --mappings-file mappings.yaml  vsphere`

Note: Only pass in either the `aws` or the `vsphere` subdirectory as the parameter to the dryrun command which provides 
the cluster resources used to resolve the templates. These test files should return a result indicating the policy is
Compliant.
