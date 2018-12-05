#!/bin/sh

APPL_DIR=$(dirname "$(readlink -f "$0")")

if ! [ -f "$APPL_DIR"/settings.env ]; then
	echo "$APPL_DIR"/settings.env not found. Please use the example file template
	exit 1
fi

source "$APPL_DIR"/settings.env

CFG_PATH="${CFG_PATH:-"$APPL_DIR"/cfg}"
KERNEL_SOURCE_PATH="${KERNEL_SOURCE_PATH:-/usr/src/linux}"

CFG_MODULES="${CFG_MODULES:-*}"

echo "Apply config patches from $CFG_PATH to $KERNEL_SOURCE_PATH"

cd "$CFG_PATH"
ALL_MODULES=$(eval ls -1 $CFG_MODULES | grep '.config$')

echo "Selected configuration modules:" $ALL_MODULES

cat "$KERNEL_SOURCE_PATH"/arch/x86/configs/x86_64_defconfig $ALL_MODULES > "$KERNEL_SOURCE_PATH"/.config

make -C "$KERNEL_SOURCE_PATH" olddefconfig 2> /dev/null
echo "Config done in $KERNEL_SOURCE_PATH/.config"
