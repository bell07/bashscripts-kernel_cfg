APPL_DIR=$(dirname "$(readlink -f "$0")")

wget 'https://gitlab.com/evlaV/jupiter-PKGBUILD/-/raw/master/linux-neptune-615/config-neptune?inline=false' -O "$APPL_DIR"/cfg/30_enable_steamdeck_device.config.new

wget 'https://gitweb.gentoo.org/proj/genkernel.git/plain/defaults/kernel-generic-config' -O "$APPL_DIR"/distro/gentoo-genkernel.config
wget 'https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/raw/main/config.x86_64?inline=false' -O "$APPL_DIR"/distro/archlinux.config
wget 'https://raw.githubusercontent.com/projg2/fedora-kernel-config-for-gentoo/6.19.2-gentoo/kernel-x86_64-fedora.config' -O "$APPL_DIR"/distro/gentoo-fedora-x86_64.config

cd 3rdparty/gentoo-kernel-config
git fetch
git checkout origin/master


for file in *; do
	cp -v "$file" ../../cfg/01_gentoo_"$file"
done
