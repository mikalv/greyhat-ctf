#!/bin/sh -e
#
# File:
# Purpose:
#

cd $(dirname "$0"); . ./common.sh; cd ..

sudo ./scripts/clean.sh

sudo ./scripts/build.sh

sudo ./scripts/pack-iso.sh

# eof
