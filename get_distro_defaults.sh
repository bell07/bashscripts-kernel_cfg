APPL_DIR=$(dirname "$(readlink -f "$0")")

wget 'https://gitweb.gentoo.org/proj/genkernel.git/plain/defaults/kernel-generic-config' -O "$APPL_DIR"/distro/gentoo-genkernel.config
wget 'https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/raw/main/config?inline=false' -O "$APPL_DIR"/distro/archlinux.config
wget 'https://raw.githubusercontent.com/projg2/fedora-kernel-config-for-gentoo/6.8.2-gentoo/kernel-x86_64-fedora.config' -O "$APPL_DIR"/distro/gentoo-fedora-x86_64.config

cd 3rdparty/gentoo-kernel-config
git fetch
git checkout origin/master


for file in *; do
	cp -v "$file" ../../cfg/01_gentoo_"$file"
done
