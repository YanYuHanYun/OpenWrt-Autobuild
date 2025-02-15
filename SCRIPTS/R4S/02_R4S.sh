#!/bin/bash
clear

## Custom-made
# GCC CFlags for R4S
sed -i 's,-mcpu=generic,-mcpu=cortex-a72.cortex-a53+crypto,g' include/target.mk
# Add PWM fans
#wget -P target/linux/rockchip/armv8/base-files/etc/init.d/ https://github.com/friendlyarm/friendlywrt/raw/master-v19.07.1/target/linux/rockchip-rk3399/base-files/etc/init.d/fa-rk3399-pwmfan
#wget -P target/linux/rockchip/armv8/base-files/usr/bin/ https://github.com/friendlyarm/friendlywrt/raw/master-v19.07.1/target/linux/rockchip-rk3399/base-files/usr/bin/start-rk3399-pwm-fan.sh
# Switch to rtl8169 driver
#sed -i 's,kmod-r8169,kmod-r8168,g' target/linux/rockchip/image/armv8.mk
# Addition-Trans-zh-master
cp -rf ../PATCH/duplicate/addition-trans-zh-rockchip ./package/utils/addition-trans-zh
# Add cputemp.sh and fix Apple iOS apns
cp -rf ../PATCH/script/cputemp.sh ./package/base-files/files/bin/cputemp
cp -rf ../PATCH/duplicate/files ./files

# Match Vermagic
latest_release="$(curl -s https://api.github.com/repos/openwrt/openwrt/tags | grep -Eo "22.03.+[0-9\.]" | head -n 1)"
wget https://downloads.openwrt.org/releases/${latest_release}/targets/rockchip/armv8/packages/Packages.gz
zgrep -m 1 "Depends: kernel (=.*)$" Packages.gz | sed -e 's/.*-\(.*\))/\1/' >.vermagic
sed -i -e 's/^\(.\).*vermagic$/\1cp $(TOPDIR)\/.vermagic $(LINUX_DIR)\/.vermagic/' include/kernel-defaults.mk

# Final Cleanup
chmod -R 755 ./
find ./ -name *.orig | xargs rm -f
find ./ -name *.rej | xargs rm -f

exit 0
