#!/bin/bash

export UPDATE_GOLDENS=1

exec ./tool/test.sh --update-goldens --tags=golden "$@"
