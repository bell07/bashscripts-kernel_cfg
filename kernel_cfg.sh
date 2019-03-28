#!/bin/sh

APPL_DIR=$(dirname "$(readlink -f "$0")")

if [ -n "$1" ]; then
	SETTINGS_FILE="$(realpath "$1")"
else
	SETTINGS_FILE="$APPL_DIR"/settings.env
fi

if ! [ -f "$SETTINGS_FILE" ]; then
	echo "Settings file \"$SETTINGS_FILE\" not found. Please use the example file template"
	exit 1
fi

echo "Use settings file $SETTINGS_FILE"

source "$SETTINGS_FILE"

CFG_PATH="${CFG_PATH:-"$APPL_DIR"/cfg}"
KERNEL_SOURCE_PATH="${KERNEL_SOURCE_PATH:-/usr/src/linux}"

BASE_DEFCONFIG="${BASE_DEFCONFIG:-arch/x86/configs/x86_64_defconfig}"

CFG_MODULES="${CFG_MODULES:-*}"

cd "$CFG_PATH" || exit 1

echo "apply $BASE_DEFCONFIG"
cp "$KERNEL_SOURCE_PATH"/"$BASE_DEFCONFIG" "$KERNEL_SOURCE_PATH"/.config

if [ -n "$KERNEL_LOCALVERSION" ]; then
	echo "Set CONFIG_LOCALVERSION to $KERNEL_LOCALVERSION"
	echo "CONFIG_LOCALVERSION=\"$KERNEL_LOCALVERSION\"" >> "$KERNEL_SOURCE_PATH"/.config
fi

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
