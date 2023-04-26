#!/bin/bash

cd /usr/src/linux
cp .config .config.bak
make allmodconfig
cd -

fgrep NET_VENDOR /usr/src/linux/.config | sed 's:# ::g;s:[= ].*:=n:g' | sort > cfg/10_disable_all_net_vendors.config.tmp
fgrep WLAN_VENDOR /usr/src/linux/.config | sed 's:# ::g;s:[= ].*:=n:g' | sort >> cfg/10_disable_all_net_vendors.config.tmp
fgrep CONFIG_TOUCHSCREEN /usr/src/linux/.config | sed 's:# ::g;s:[= ].*:=n:g' | sort >> cfg/10_disable_all_touchscreen.config.tmp
