#!/bin/bash

signer="$1"
dir="$2"

find $dir -type f -name "*.yaml" | while read file;
do
  echo Signing  $file
  curl -s https://raw.githubusercontent.com/open-cluster-management/integrity-shield/master/scripts/gpg-annotation-sign.sh | bash -s $signer "$file"
done
