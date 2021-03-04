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
sed -i 's/192.168.1.1/10.10.10.1/g' package/base-files/files/bin/config_generate

#echo '修改时区'
sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

#echo '修改机器名称'
sed -i 's/OpenWrt/GL.iNet/g' package/base-files/files/bin/config_generate

#echo '修改wifi名称'
# sed -i 's/OpenWrt/iNetHotspot/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/OpenWrt/iNetHotspot/g ; s/none/psk-mixed/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/^EOF/i \            \set wireless.default_radio${devidx}.key=567890321' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF./$1$GzaZpWin$e5M.CJ2ooGgDXrbQWltbd0/g' package/lean/default-settings/files/zzz-default-settings

# cp -f ../Dir/997-hxd-ec20.patch ./target/linux/ramips/patches-5.4/997-hxd-ec20.patch

# luci-app-modeminfo
# git clone https://github.com/koshev-msk/luci-app-atinout.git package/mine/luci-app-atinout
# git clone https://github.com/koshev-msk/luci-app-mmconfig.git package/mine/luci-app-mmconfig
git clone https://github.com/koshev-msk/luci-app-modeminfo.git package/mine/luci-app-modeminfo
git clone https://github.com/koshev-msk/luci-app-smstools3.git package/mine/luci-app-smstools3

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

# echo '修改banner'
# rm -rf package/base-files/files/etc/banner
# cp -f ../banner package/base-files/files/etc/

# echo '集成diy目录'
# ln -s ../../diy ./package/openwrt-packages

# echo '修改默认主题'
# sed -i 's/config internal themes/config internal themes\n    option Argon  \"\/luci-static\/argon\"/g' feeds/luci/modules/luci-base/root/etc/config/luci

#echo 'Netgearrainbow'
# ln -s ../../../luci-theme-netgearrainbow ./package/lean/

#echo '去除默认bootstrap主题'
#sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap

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

#=================================================
# Travelmate
#pushd feeds/packages/net
#rm -rf travelmate
#svn co https://github.com/hanxd/extd/trunk/travelmate
#popd

#pushd feeds/luci/applications
#rm -rf luci-app-travelmate
#svn co https://github.com/hanxd/extd/trunk/luci-app-travelmate
#popd
#=================================================

#echo 'quectel'
ln -s ../../../quectel ./package/lean/

#echo '删除旧版argon,链接新版'
# rm -rf ./package/lean/luci-theme-argon
# ln -s ../../../luci-theme-argon ./package/lean/

# 复杂的AdGuardHome的openwrt的luci界面
# git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/mine/luci-app-adguardhome

# DiskMan for LuCI (WIP)
# git clone https://github.com/lisaac/luci-app-diskman.git package/mine/luci-app-diskman
# mkdir -p package/mine/parted && cp -i package/mine/luci-app-diskman/Parted.Makefile package/mine/parted/Makefile

# KPR plus+
# git clone https://github.com/project-openwrt/luci-app-koolproxyR.git package/mine/luci-app-koolproxyR

# Server酱
git clone https://github.com/tty228/luci-app-serverchan.git package/mine/luci-app-serverchan

# OpenClash
# git clone https://github.com/vernesong/OpenClash.git package/mine/OpenClash

# FileBrowser
# git clone https://github.com/project-openwrt/FileBrowser.git package/mine/FileBrowser

# 网易云音乐
# git clone https://github.com/project-openwrt/luci-app-unblockneteasemusic.git package/mine/luci-app-unblockneteasemusic
# 网易云音乐GoLang版本
# git clone https://github.com/project-openwrt/luci-app-unblockneteasemusic-go.git package/mine/luci-app-unblockneteasemusic-go
# 网易云音乐mini
# git clone https://github.com/project-openwrt/luci-app-unblockneteasemusic-mini.git package/mine/luci-app-unblockneteasemusic-mini

# disable usb3.0
# git clone https://github.com/rufengsuixing/luci-app-usb3disable.git package/mine/luci-app-usb3disable

# 管控上网行为
# git clone https://github.com/destan19/OpenAppFilter.git package/mine/OpenAppFilter

# Rclone-OpenWrt
# git clone https://github.com/ElonH/Rclone-OpenWrt.git package/mine/Rclone-OpenWrt

#luci-app-vssr
# git clone https://github.com/jerrykuku/luci-app-vssr.git t package/mine/luci-app-vssr
# 获取hello world和依赖
# git clone https://github.com/jerrykuku/lua-maxminddb package/diy-packages/helloworld/lua-maxminddb
# git clone https://github.com/jerrykuku/luci-app-vssr package/diy-packages/helloworld/luci-app-vssr
