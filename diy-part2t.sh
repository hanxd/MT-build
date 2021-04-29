#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate

#echo '修改时区'
sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

#echo '修改机器名称'
sed -i 's/OpenWrt/GL.iNet/g' package/base-files/files/bin/config_generate

#echo '修改wifi名称'
sed -i 's/none/psk2/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/^EOF/i \            \set wireless.default_radio${devidx}.key=1234567890' package/kernel/mac80211/files/lib/wifi/mac80211.sh

#echo 'DHCP'
sed -i '/mwan/i uci set network.RNDIS=interface' package/lean/default-settings/files/zzz-default-settings
sed -i '/mwan/i uci set network.RNDIS.ifname=usb0' package/lean/default-settings/files/zzz-default-settings
sed -i '/mwan/i uci set network.RNDIS.proto=dhcp' package/lean/default-settings/files/zzz-default-settings
sed -i '/mwan/i uci set network.RNDISv6=interface' package/lean/default-settings/files/zzz-default-settings
sed -i '/mwan/i uci set network.RNDISv6.ifname=usb0' package/lean/default-settings/files/zzz-default-settings
sed -i '/mwan/i uci set network.RNDISv6.proto=dhcpv6' package/lean/default-settings/files/zzz-default-settings
sed -i '/mwan/i uci set network.RNDISv6.reqaddress=try' package/lean/default-settings/files/zzz-default-settings
sed -i '/mwan/i uci set network.RNDISv6.reqprefix=auto' package/lean/default-settings/files/zzz-default-settings
sed -i '/mwan/i uci commit network' package/lean/default-settings/files/zzz-default-settings
sed -i "/mwan/i uci add_list firewall.@zone[1].network='RNDIS'" package/lean/default-settings/files/zzz-default-settings
sed -i "/mwan/i uci add_list firewall.@zone[1].network='RNDISv6'" package/lean/default-settings/files/zzz-default-settings
# sed -i "/mwan/i uci set firewall.@zone[1].network='wan wan6 RNDIS RNDISv6'" package/lean/default-settings/files/zzz-default-settings
sed -i '/mwan/i uci commit firewall' package/lean/default-settings/files/zzz-default-settings

#=================================================
# 清除旧版argon主题并拉取最新版
pushd package/lean
rm -rf luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git luci-app-argon-config
popd
#=================================================

#=================================================
# EC20.patches
pushd target/linux/ramips/patches-5.4
wget https://github.com/hanxd/extd/releases/download/V1/997-hxd-ec20.patch
popd
#=================================================
