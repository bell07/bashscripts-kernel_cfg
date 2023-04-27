#!/bin/sh

## Handle Settings
if [ -n "$1" ]; then
	SETTINGS_FILE="$(realpath "$1")"
elif [ -f "/etc/kernel-cfg.env" ]; then
	SETTINGS_FILE="/etc/kernel-cfg.env"
else
	SETTINGS_FILE="$(dirname "$(readlink -f "$0")")"/settings.env
fi

if ! [ -f "$SETTINGS_FILE" ]; then
	echo "Settings file \"$SETTINGS_FILE\" not found. Please use the example file template"
	exit 1
fi

echo "Use settings file $SETTINGS_FILE"
. "$SETTINGS_FILE"

KERNEL_SOURCE_PATH="${KERNEL_SOURCE_PATH:-/usr/src/linux}"
INSTALL_TARGET="${INSTALL_TARGET:-/boot}"

## Handle boot mount
BOOTMOUNT=0
if ! mountpoint -q "$INSTALL_TARGET" ; then
	mount -v "$INSTALL_TARGET" && BOOTMOUNT=1
fi

## Take the installation steps
cd "$KERNEL_SOURCE_PATH"

make -j$(($(nproc)+1)) && make modules_install

echo '>>' "Install files to $INSTALL_TARGET"
INSTALL_PATH="$INSTALL_TARGET" make install

if [ -n "$INSTALL_POST_ACTION" ]; then
	echo ">>> Post installation: $INSTALL_POST_ACTION"
	$INSTALL_POST_ACTION
fi

## Umount boot
if [ "$BOOTMOUNT" == 1 ]; then
	umount -v "$INSTALL_TARGET"
fi
