APPL_DIR=$(dirname "$(readlink -f "$0")")

wget 'https://gitweb.gentoo.org/proj/genkernel.git/plain/defaults/kernel-generic-config' -O "$APPL_DIR"/distro/gentoo.config
wget 'https://git.archlinux.org/svntogit/packages.git/plain/trunk/config?h=packages/linux' -O "$APPL_DIR"/distro/archlinux.config
