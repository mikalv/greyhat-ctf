#!/bin/bash
# cd $(dirname "$0"); . ./common.sh; cd -
script_dir=$(dirname "$0")

source $script_dir/functions.sh

setup_jail_rootfs
setup_jail_etc

$script_dir/install_binaries.sh


