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

CFG_PATH="${CFG_PATH:-/etc/kernel/config.d}"
KERNEL_SOURCE_PATH="${KERNEL_SOURCE_PATH:-/usr/src/linux}"

CFG_DEFCONFIG="${CFG_DEFCONFIG:-arch/x86/configs/x86_64_defconfig}"
[ -f "$KERNEL_SOURCE_PATH"/"$CFG_DEFCONFIG" ] && CFG_DEFCONFIG="$KERNEL_SOURCE_PATH"/"$CFG_DEFCONFIG"
[ -f /usr/share/kernel_cfg/"$CFG_DEFCONFIG" ] && CFG_DEFCONFIG=/usr/share/kernel_cfg/"$CFG_DEFCONFIG"
[ -f "$APPL_DIR"/"$CFG_DEFCONFIG" ] && CFG_DEFCONFIG="$APPL_DIR"/"$CFG_DEFCONFIG"

CFG_MODULES="${CFG_MODULES:-*}"

echo "use config snippets from $CFG_PATH"
cd "$CFG_PATH" || exit 1

echo "apply $CFG_DEFCONFIG"
cp "$CFG_DEFCONFIG" "$KERNEL_SOURCE_PATH"/.config

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
