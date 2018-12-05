# kernel_cfg.sh

Simple script to generate linux kernel config file.
Known working environment: gentoo-sources for x86_64

 License: GPL-3+
 
 Gentoo Forum thread: https://forums.gentoo.org/viewtopic-t-1090188.html

## How kernel_cfg.sh script works

  1. Basically there is an assumption the kernel developers does set useful default values in kernel tree.
Therefore the file arch/x86/configs/x86_64_defconfig is used for the config base.

  2. The provided configuration modifiers `cfg/*.config` contains the additional settings and is able to override the defconfig values. It is possible to enhance the configuration by own files `cfg/99*.config`. If you create own files, please contribute them to the project if useful for other users.
  
  3. In step 2 the files are just concatenated. To get proper config file the `make olddefconfig` is called. 

  
 ## How to use
 
  1. Backup your current /usr/src/.linux config file
  2. Create settings.env from example. Check the settings
  3. Check if you need all configuration modules in cfg folder. Adjust the setting in settings.env
  4. If you know additional settings you need, create new 99* file (like `cfg/99_my_settings.config`)
  5. run `sh kernel_cfg.sh`
  6. Check the config comparing with your backup
  7. Create issue in case of issues or new usefull pre-setting
  8. Build the kernel and enjoy

## Configuration files
File(s) | Use-case
-----| -----
**Default settings** | 
00* | Default configuration adjustments that **should be in any kernel**
10* | Disable stuff to get the kernel smaller by default. Useful for non-universal kernels bound to a hardware. Some parameters are re-activated in other config files
20* | Try to support all hardware. Useful for live-media kernels that should work with any hardware
**Hardware class support** | **useful if you have such hardware**
30_hwsupport_bluetooth.config | Support the bluetooth stack
30_hwsupport_uefi_boot.config | UEFI boot and framebuffer
30_hwsupport_wifi.config | WIFI stack (Driver needs to be enabled in addition)
**Hardware support** | **useful if you have such hardware**
30_hardware_intel_MEI.config | Support for Intel managemen Engine found on modern Intel devices
40_hardware_mmc_card.config | Support for MMC card, found in modern devices
40_hardware_vmware_guest.config | All required configuration needed for Vmware guest
**Services support**  | **useful if you like to run this services**
50_docker.config | Docker server support
50_lxc.config | LXC server support
**Firewall support** | **useful if the system is such firewall**
80_net_ebtables.config | EBTables Bridge filtering, useful with LXC for example
