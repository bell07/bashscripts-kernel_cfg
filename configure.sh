#!/bin/sh
CFGPATH="$(dirname "$(readlink -f "$0")")"/cfg
cd /usr/src/linux

echo "Apply config patches from" $CFGPATH
cat arch/x86/configs/x86_64_defconfig "$CFGPATH"/*.config > .config
make olddefconfig
