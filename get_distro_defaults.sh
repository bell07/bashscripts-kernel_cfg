APPL_DIR=$(dirname "$(readlink -f "$0")")

wget 'https://gitweb.gentoo.org/proj/genkernel.git/plain/defaults/kernel-generic-config' -O "$APPL_DIR"/distro/gentoo-genkernel.config
wget 'https://raw.githubusercontent.com/archlinux/svntogit-packages/packages/linux/trunk/config' -O "$APPL_DIR"/distro/archlinux.config
wget 'https://raw.githubusercontent.com/projg2/fedora-kernel-config-for-gentoo/6.2.6-gentoo/kernel-x86_64-fedora.config' -O "$APPL_DIR"/distro/gentoo-fedora-x86_64.config
