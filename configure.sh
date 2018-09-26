#!/bin/sh

APPL_DIR=$(dirname "$(readlink -f "$0")")

if ! [ -f "$APPL_DIR"/settings.txt ]; then
	echo "$APPL_DIR"/settings.txt not found. Please use the example file template
	exit 1
fi

source "$APPL_DIR"/settings.txt

CFG_PATH="${CFG_PATH:-"$APPL_DIR"/cfg}"
KERNEL_SOURCE_PATH="${KERNEL_SOURCE_PATH:-/usr/src/linux}"

cd $KERNEL_SOURCE_PATH
echo "Apply config patches from $CFG_PATH to $KERNEL_SOURCE_PATH"
cat arch/x86/configs/x86_64_defconfig "$CFG_PATH"/*.config > .config
make olddefconfig
