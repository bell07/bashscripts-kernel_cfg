# kernel_cfg.sh

Simple script to generate linux kernel config file.
Known working environment: gentoo-sources

 License: GPL-3+
 
 Gentoo Forum thread: https://forums.gentoo.org/viewtopic-t-1090188.html

## How kernel_cfg.sh script works

  1. Basically there is an assumption the kernel developers does set useful default values. The kernel-tree config file `arch/x86/configs/*_defconfig` or provided distro config files in `kernel_cfg/distro` can be used as starting base.

  2. The provided configuration modifiers `cfg/*.config` contains the additional settings and is able to override the defconfig values. It is possible to enhance the configuration by own files placed in cfg folder. If you create own files, please contribute them to the project if useful for other users.
  
  3. In step 2 the files are just concatenated. To get proper config file the `make olddefconfig` is called. 

  
## How to use
 
  1. Backup your current /usr/src/linux/.config config file
  2. Create settings.env from example
  3. Choose your base configuration (archlinux, gentoom or kernel-provided) from `CFG_DEFCONFIG="distro/??.config"` to your preferred one.
  3.1. Check which configuration modules in cfg folder you need. Adjust the  CFG_MODULES in settings.env (see settings.env.example)
  4. If you know additional settings you need, create new 99* files (like `cfg/99_my_settings.config`)
  5. run `sh kernel_cfg.sh`
  6. Check the config comparing with your backup. Hint: for easier comparing the files could be sorted ;-)
  7. Create issue in case of issues or new usefull pre-setting
  8. Build and install the kernel using `sh kernel_build.sh`
  9. Reboot and and enjoy

### Enhanced usage
The kernel_cfg can handle different profiles using different settings.env files. Just call the kernel_cfg with the other env file as parameter `./kernel_cfg config_second.env`.
I recommend to utilize CONFIG_LOCALVERSION for different kernels in custom config snippet. Set the "KERNEL_LOCALVERSION" parameter in second setting.env file to adjust the CONFIG_LOCALVERSION.


If the distro config is not uptodate, the script `./get_distro_defaults.sh` can be used for update.
Please create issue on github


## Configuration files
File(s) | Use-case
-----| -----
**Default settings** | 
00_defaults.config | Default configuration adjustments that **should be in any kernel**. Some parameters are overriden in next settings files
10_disable_*.config | Disable stuff to get the kernel smaller by default. Useful for non-universal kernels bound to a hardware. Some parameters are re-activated in other config files.

**Enable boot capability inintramfs** |
20_enable_boot_mmc_sdhci_root.config | Boot from SSD type MMC on PCI Secure Digital Host Controller (SDHCI_PCI) 
20_enable_boot_nvme_root.config | Boot from NVMe SSD
20_enable_boot_usb_root.config | Boot from USB storage disk

**Additional Hardware
30_enable_hw_xpad.config | X-BOX Gamepad

**Services support**  | **useful if you like to run this services**
50_docker.config | Docker server support
50_lxc.config | LXC server support
50_virtualbox_guest.config | All required configuration needed for Virtualbox guest
50_vmware_guest.config | All required configuration needed for Vmware guest

**Custom **  | **Additional configuration**
99_*.config | It's yours! The files are ignored by git. Create your own settings
