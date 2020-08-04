#!/bin/bash

GH_URL=$1
GH_PATH=$2
NAMESPACE=$3

URL_CFG=$(cat "url_template.json" | sed "s%##GH_URL##%${1:-https://github.com/open-cluster-management/policy-collection.git}%g")
echo "$URL_CFG" > url_patch.json
PATH_CFG=$(cat "path_template.json" | sed "s/##GH_PATH##/${2:-stable}/g")
echo "$PATH_CFG" > dir_patch.json
CHANNEL_CFG=$(cat "channel_template.json" | sed "s/##NAMESPACE##/${3:-policies}/g")
echo "$CHANNEL_CFG" > channel_patch.json
KUST_CFG=$(cat "kustomization_template.yaml" | sed "s/##NAMESPACE##/${3:-policies}/g")
echo "$KUST_CFG" > kustomization.yaml

kustomize build . > resources.yaml
kubectl apply -f resources.yaml

rm dir_patch.json
rm url_patch.json
rm channel_patch.json
rm kustomization.yaml
rm resources.yaml
