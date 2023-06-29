# kernel_cfg.sh

Simple script to generate linux kernel config file.
Known working environment: gentoo

 License: GPL-3+
 
 Gentoo Forum thread: https://forums.gentoo.org/viewtopic-t-1090188.html

## How kernel_cfg.sh script works

  1. Basically there is an assumption the kernel developers does set useful default values. The kernel-tree config file `arch/x86/configs/*_defconfig` or provided distro config files in `kernel_cfg/distro` can be used as starting base.

  2. The provided configuration modifiers `cfg/*.config` contains the additional settings and is able to override the defconfig values. It is possible to enhance the configuration by own files placed in cfg folder. If you create own files, please contribute them to the project if useful for other users.

  3. In step 2 the files are just concatenated. To get proper config file the `make olddefconfig` is called.


## Howto install

In Gentoo the sys-kernel/kernel-cfg package is available in bell07 overlay
Without gentoo just checkout the repo and call the scripts from project directory


## How to use

  1. Backup your current /usr/src/linux/.config config file
  2. Create settings.env from example
  3. Choose your base configuration `CFG_DEFCONFIG="??.config"` (archlinux, gentoo-genkernel, gentoo-fedora-x86_64 or kernel-provided defconfig) in settings.env to your preferred one.
  3.1. Check which configuration modules in cfg folder you need. Adjust the `CFG_MODULES` in settings.env
  4. If you know additional settings you need, create new 99* files (like `cfg/99_my_settings.config` )
  5. run `kernel_cfg.sh`
  6. Check the config comparing with your backup. Hint: for easier comparing the files could be sorted ;-)
  7. Create issue in case of issues or new usefull pre-setting
  8. Build and install the kernel using `kernel_build.sh`
  9. Reboot and and enjoy


## Gentoo ebuild notes

The `settings.env` is installed into `/etc/kernel-cfg.env`
All cfg snippets are installed into `/etc/kernel/config.avail`
The snippets can be activated by `eselect kernel-cfg` in `/etc/kernel/config.d"`. Therefore the `CFG_PATH="/etc/kernel/config.d"` and `CFG_MODULES="*"` are the right settings.
build from `sys-kernel/*sources` can be done using `kernel_cfg.sh` and `kernel_build.sh` like described above.

The `sys-kernel/gentoo-kernel` provides own build magic and own base configuration. Therefore the `/etc/kernel-cfg.env` file and bash scripts are not used in this scenario.
However, the configuration snippets are used with the sys-kernel/gentoo-kernel, if selected by `eselect kernel-cfg`. In short:
- Select modules by `eselect kernel-cfg`.
- `emerge gentoo-kernel` uses the selected snippets in `/etc/kernel/config.d` and same source like `gentoo-fedora-x86_64.config` for the configuration base.

```
# ls -l /etc/kernel/config.d/
insgesamt 4
lrwxrwxrwx 1 root root  42  4. Jan 08:36 00_defaults.config -> /scripts/kernel_cfg/cfg/00_defaults.config
lrwxrwxrwx 1 root root  57  4. Jan 08:35 10_disable_all_net_vendors.config -> /scripts/kernel_cfg/cfg/10_disable_all_net_vendors.config
lrwxrwxrwx 1 root root  54  4. Jan 08:35 10_disable_misc_options.config -> /scripts/kernel_cfg/cfg/10_disable_misc_options.config
lrwxrwxrwx 1 root root  55  4. Jan 08:36 20_enable_boot_nvme_root.config -> /scripts/kernel_cfg/cfg/20_enable_boot_nvme_root.config
-rw-r--r-- 1 root root 524  3. Nov 17:38 99_my_hardware.config
```

Please note, since the fedora based gentoo-kernel base configuration does have the most settings enabled by default, the most 30* and 50* snippets are redundant.


### Enhanced usage

The kernel_cfg can handle different profiles using different settings.env files. Just call the kernel_cfg with the other env file as parameter `./kernel_cfg config_second.env`.
I recommend to utilize CONFIG_LOCALVERSION for different kernels in custom config snippet. Set the "KERNEL_LOCALVERSION" parameter in second setting.env file to adjust the CONFIG_LOCALVERSION.

If the distro config is not uptodate, the script `get_distro_defaults.sh` can be used for update.
Please create issue on github

The `update_disable.sh` script check for new entries for `10_disable_all_*.config` files. The script generates new `*.tmp` files for manually merge/update.
Please backup your /usr/src/linux/.config before run, because the script calls `make allmodconfig` to get full settings list.


## Configuration files

File(s) | Use-case
-----| -----
**Default settings** | 
00_defaults.config | Default configuration adjustments that **should be in any kernel**. Some parameters are overriden in next settings files
01_gentoo*.config | Gentoo base defaults from https://github.com/projg2/gentoo-kernel-config and used in sys-kernel/gentoo-kernel ebuild. No need to enable if the ebuild is used.
10_disable_\*.config | Disable stuff to get the kernel smaller by default. Useful for non-universal kernels bound to a hardware. Some parameters are re-activated in other config files.
**Enable boot capability without inintramfs** |
20_enable_boot_mmc_sdhci_root.config | Boot from SSD type MMC on PCI Secure Digital Host Controller (SDHCI_PCI) 
20_enable_boot_nvme_root.config | Boot from NVMe SSD
20_enable_boot_usb_root.config | Boot from USB storage disk
**Additional Hardware** |
30_enable_hw_xpad.config | X-BOX Gamepad
30_enable_intel_device.config | Enable usual intel hardware (realtek lan, intel wifi, intel kvm, intel iommu ...)
30_enable_amd_device.config | Enable usual AMD hardware (amd kvm, amd iommu ...)
**Services support**  | **useful if you like to run this services**
50_docker.config | Docker server support
50_lxc.config | LXC server support
50_virtualbox_guest.config | All required configuration needed for Virtualbox guest
50_vmware_guest.config | All required configuration needed for Vmware guest
**Custom**  | **Additional configuration**
99_\*.config | It's yours! The files are ignored by git. Create your own settings
