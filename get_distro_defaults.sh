APPL_DIR=$(dirname "$(readlink -f "$0")")

wget 'https://gitweb.gentoo.org/proj/genkernel.git/plain/defaults/kernel-generic-config' -O "$APPL_DIR"/distro/gentoo.config
wget 'https://raw.githubusercontent.com/archlinux/svntogit-packages/packages/linux/trunk/config' -O "$APPL_DIR"/distro/archlinux.config
