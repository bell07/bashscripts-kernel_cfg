# kernel_cfg.sh

Simple script to generate linux kernel config file.
Known working environment: gentoo-sources for x86_64

## How it works

  1. Basically there is an assumption the kernel developers does set usefull default values in kernel tree.
Therefore the file arch/x86/configs/x86_64_defconfig is used for the config base.

  2. The provided configuration modifiers `cfg/*.config` contains the additional settings and is able to override the defconfig values. At least it is possible to enhance own configuration in `cfg/99*.config` own files
  
  3. In step 2 the files are just concatenated. To get proper config file the `make olddefconfig` is called
  
 ## How to use
 
  1. Backup your current /usr/src/.linux config file
  2. Create settings.txt from example. Check the settings
  3. Check if you need all configuration modules in cfg folder. Adjust the setting in settings.txt
  4. If you know settings you need, create new 99* file (like `cfg/99_my_settings.config`)
  5. run `sh kernel_cfg.sh`
  6. Check the config / compare with your backup
  7. Create issue in case of issues or new usefull pre-setting
  8. Build the kernel and enjoy
