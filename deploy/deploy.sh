#!/bin/bash

GH_PATH=$1
NAMESPACE=$2

PATCH_CFG=$(cat "patch_template.json" | sed "s/##GH_PATH##/${1:-stable}/g")
echo "$PATCH_CFG" > dir_patch.json
KUST_CFG=$(cat "kustomization_template.yaml" | sed "s/##NAMESPACE##/${2:-policies}/g")
echo "$KUST_CFG" > kustomization.yaml

kustomize build . > resources.yaml
kubectl apply -f resources.yaml

rm dir_patch.json
rm kustomization.yaml
rm resources.yaml
