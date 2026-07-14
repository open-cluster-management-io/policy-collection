#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

typeset -i exitCode=0

# Check for yamllint CLI
if ! command -v yamllint &> /dev/null; then
  echo "ERROR: yamllint CLI not found. Install yamllint before running this script."
  echo "       See https://yamllint.readthedocs.io/en/stable/quickstart.html#installing-yamllint"
  exit 1
fi

# Check for template-resolver CLI
if ! command -v "$(go env GOPATH)/bin/template-resolver" &> /dev/null; then
  echo "ERROR: template-resolver CLI not found. Install template-resolver before running this script by running:"
  echo "  go install github.com/stolostron/go-template-utils/v7/cmd/template-resolver@main"
  exit 1
fi

typeset -a yamlFilesArr=()
while read -r file; do
  yamlFilesArr+=("${file}")
done < <(find . -type f \( -name "*.yaml" -or -name "*.yml" \) | sed 's|^./||')

echo "* Lint YAML with yamllint"
yamllint "${yamlFilesArr[@]}" --format github || exitCode=2

echo "* Lint Go Templates with template-resolver (from https://github.com/stolostron/go-template-utils)"
for file in "${yamlFilesArr[@]}"; do
  typeset sarifFile="sarif_${file//\//_}.sarif"
  typeset lintResults=""
  lintResults=$("$(go env GOPATH)/bin/template-resolver" lint "${file}" --sarif "${sarifFile}" 2>&1) ||
    case $? in
      0|2|3) exitCode=$? ;;
      *) exit $? ;;
    esac
  if [[ -n "${lintResults}" ]]; then
    echo "::group::${file}"
    echo "${lintResults}"
    echo "::endgroup::"
  fi
done

echo "* Merge SARIF files"
# Construct SARIF template from the first SARIF file
typeset firstSarif=""
firstSarif=$(find . -type f -name "*.sarif" -print -quit)
typeset sarifTemplate=""
sarifTemplate=$(jq -cM '.runs[] |= (.artifacts = [] | .results = [] | .tool.driver.rules = [])' "${firstSarif}")
# Merge SARIF files, keeping only the runs with rules
jq -s 'reduce (.[] | select(.runs[].results | length > 0).runs[]) as $item (
    '"${sarifTemplate}"';
    .runs[] |= (
    .artifacts += $item.artifacts |
    .results += $item.results |
    .tool.driver.rules += $item.tool.driver.rules)
  ) | .runs[].tool.driver.rules |= unique_by(.id)' ./*.sarif >merged.sarif
# Clean up individual SARIF files
find . -type f -name "*.sarif" -not -name "merged.sarif" -delete

exit "${exitCode}"
