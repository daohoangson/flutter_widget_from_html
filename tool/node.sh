#!/bin/bash

set -e

cd "$( dirname $( dirname ${BASH_SOURCE[0]}))"
_pwd=$( pwd )

exec docker run --rm -it \
  -v "$_pwd:/project" -w /project \
  node:lts /bin/bash
