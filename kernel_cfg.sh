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

cd "$CFG_PATH" || exit 1

echo "apply arch/x86/configs/x86_64_defconfig"
cp "$KERNEL_SOURCE_PATH"/arch/x86/configs/x86_64_defconfig "$KERNEL_SOURCE_PATH"/.config

for file in $CFG_MODULES; do
	if [ -z "${file##*.config}" ]; then
		echo "apply $file"
		cat "$file" >> "$KERNEL_SOURCE_PATH"/.config
	else
		echo "skip $file"
	fi
done

make -C "$KERNEL_SOURCE_PATH" olddefconfig 2> /dev/null
echo "Config done in $KERNEL_SOURCE_PATH/.config"
