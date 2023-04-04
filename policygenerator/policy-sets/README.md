# What are `PolicySets`

A `PolicySet` is a collection of policies that can be placed together instead of having to manage
their placement individually. The intent of a particular `PolicySet` can be specified in the
`description` field and the `status` of the `PolicySet` reflects the status of the policies that it
contains.

# Stable `PolicySets`

A stable `PolicySet` is a `PolicySet` that is tested and supported by the Open Cluster Management Policy SIG. These `PolicySets`
work with little or no modifications.

# 3rd-party `PolicySets`

A 3rd-party `PolicySet` is a `PolicySet` that is supported by a 3rd-party contributor. The extent of support provided
is documented with the contributed `PolicySet`.

# Community `PolicySets`

A community `PolicySet` is a `PolicySet` that has been contributed by the community. Community
contributions provide value but could be specific to certain environments and may need modifications
to apply the solution to your environment. Some community `PolicySets` provide samples showing how a
problem can be solved for one user of the policy framework, which may or may not apply to other
users.
