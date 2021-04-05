#!/bin/bash

export UPDATE_GOLDENS=1

exec ./tool/test.sh --plain-name=Golden --update-goldens "$@"
