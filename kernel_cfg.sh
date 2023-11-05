#!/bin/sh

APPL_DIR=$(dirname "$(readlink -f "$0")")

if [ -n "$1" ]; then
	SETTINGS_FILE="$(realpath "$1")"
elif [ -f "/etc/kernel-cfg.env" ]; then
	SETTINGS_FILE="/etc/kernel-cfg.env"
else
	SETTINGS_FILE="$APPL_DIR"/settings.env
fi

if ! [ -f "$SETTINGS_FILE" ]; then
	echo "Settings file \"$SETTINGS_FILE\" not found. Please use the example file template"
	exit 1
fi

echo "Use settings file $SETTINGS_FILE"

. "$SETTINGS_FILE"

CFG_PATH="${CFG_PATH:-/etc/kernel/config.avail}"
KERNEL_SOURCE_PATH="${KERNEL_SOURCE_PATH:-/usr/src/linux}"
KBUILD_OUTPUT="${KBUILD_OUTPUT:-/usr/src/linux}"

CFG_DEFCONFIG="${CFG_DEFCONFIG:-/usr/src/linux/arch/x86/configs/x86_64_defconfig}"
if [ "$(echo "$CFG_DEFCONFIG" | cut -c 1)" != "/" ]; then
	if [ -f /usr/share/kernel_cfg/distro/"$CFG_DEFCONFIG" ]; then
		CFG_DEFCONFIG=/usr/share/kernel_cfg/distro/"$CFG_DEFCONFIG"
	elif [ -f "$APPL_DIR"/"$CFG_DEFCONFIG" ]; then
		CFG_DEFCONFIG="$APPL_DIR"/"$CFG_DEFCONFIG"
	else
		echo "$CFG_DEFCONFIG not found"
		exit1
	fi
fi

CFG_MODULES="${CFG_MODULES:-*}"

echo "use config snippets from $CFG_PATH"
cd "$CFG_PATH" || exit 1

echo "apply $CFG_DEFCONFIG"
cp "$CFG_DEFCONFIG" "$KBUILD_OUTPUT"/.config

if [ -n "$KERNEL_LOCALVERSION" ]; then
	echo "Set CONFIG_LOCALVERSION to $KERNEL_LOCALVERSION"
	echo "CONFIG_LOCALVERSION=\"$KERNEL_LOCALVERSION\"" >> "$KBUILD_OUTPUT"/.config
fi

for file in $CFG_MODULES; do
	if [ -z "${file##*.config}" ]; then
		echo "apply $file"
		cat "$file" >> "$KBUILD_OUTPUT"/.config
	else
		echo "skip $file"
	fi
done

make -C "$KBUILD_OUTPUT" olddefconfig 2> /dev/null
echo "Config done in $KBUILD_OUTPUT/.config"
