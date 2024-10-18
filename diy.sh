#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 更换6.6内核 
#sed -i 's/KERNEL_PATCHVER:=6.1/KERNEL_PATCHVER:=6.6/g' ./target/linux/x86/Makefile

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}


# 主题
git clone --depth=1 -b js https://github.com/sirpdboy/luci-theme-kucat package/kucat
git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

# 在线更新
git clone --depth=1 https://github.com/wstanfeng/luci-app-immupdate package/luci-app-gpsysupgrade

# ddns-go
git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go package/ddns-go

# nezha
git clone --depth 1 https://github.com/Erope/openwrt_nezha package/nezha

# adguardhome
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome

# 科学上网插件
git clone --depth=1 https://github.com/VIKINGYFY/homeproxy package/homeproxy
git clone --depth=1 https://github.com/morytyann/OpenWrt-mihomo package/mihomo
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/small
# git clone --depth=1 -b main https://github.com/fw876/helloworld package/helloworld
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
# git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
# git_sparse_clone master https://github.com/vernesong/OpenClash package/luci-app-openclash

# 系统监控工具
git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/luci-app-netdata

# Alist
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/luci-app-alist

# iStore
git_sparse_clone main https://github.com/linkease/istore-ui package/app-store-ui
git_sparse_clone main https://github.com/linkease/istore package/luci

# 内网穿透
git clone --depth=1 https://github.com/asvow/luci-app-tailscale package/luci-app-tailscale

# 进价设置
git clone --depth=1 https://github.com/VIKINGYFY/luci-app-advancedplus package/luci-app-advancedplus

#网络唤醒
git clone --depth=1 https://github.com/VIKINGYFY/luci-app-wolplus package/luci-app-wolplus

# 关机
git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff

# 网易云音乐
git clone --depth=1 https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic package/luci-app-unblockneteasemusic
