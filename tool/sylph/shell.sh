#!/bin/bash

set -e
cd $( dirname $( dirname $( dirname ${BASH_SOURCE[0]})))

_awsAccessKeyId=$( head -n 1 ./tool/aws.txt )
_awsSecretAccessKey=$( head -n 2 ./tool/aws.txt | tail -n 1 )

exec docker run --rm -it \
  -e "AWS_ACCESS_KEY_ID=${_awsAccessKeyId}" \
  -e "AWS_DEFAULT_REGION=us-west-2" \
  -e "AWS_SECRET_ACCESS_KEY=${_awsSecretAccessKey}" \
  -v "$PWD:$PWD" -w "$PWD" \
  -v "/tmp:/tmp" \
  cirrusci/flutter ${1:-'./tool/sylph/cmd.sh'}
