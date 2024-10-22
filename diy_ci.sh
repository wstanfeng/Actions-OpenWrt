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

# 移除要替换的包
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/msd_lite
rm -rf feeds/packages/net/smartdns
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/packages/net/v2ray-geodata

# go更新
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

# mosdns
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# 在线更新
git clone --depth 1 -b CI https://github.com/wstanfeng/luci-app-gpsysupgrade package/luci-app-gpsysupgrade

# ddns-go
git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go package/ddns-go

# nezha
git clone --depth 1 https://github.com/Erope/openwrt_nezha package/nezha

# adguardhome
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome

# 家长控制
git clone --depth=1 https://github.com/destan19/OpenAppFilter package/OpenAppFilter

# 系统监控工具
git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/luci-app-netdata

# 科学上网插件
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/small
# git clone --depth=1 -b main https://github.com/fw876/helloworld package/helloworld
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash
git clone --depth=1 https://github.com/VIKINGYFY/homeproxy package/homeproxy

# Themes
#git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
#git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

# Alist
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/luci-app-alist

# 网络唤醒
git clone --depth=1 https://github.com/VIKINGYFY/luci-app-wolplus package/luci-app-wolplus

# 组网
git clone --depth=1 https://github.com/asvow/luci-app-tailscale package/luci-app-tailscale

# iStore
git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
git_sparse_clone main https://github.com/linkease/istore luci

# 网易云音乐
#git clone --depth=1 -b js https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic package/luci-app-unblockneteasemusic

# lucky
git clone --depth=1 https://github.com/gdy666/luci-app-lucky package/luci-app-lucky

./scripts/feeds update -a
./scripts/feeds install -a

# 修改版本
# 获取当前日期并格式化为 'yy.mm.dd' 格式
openwrt_version=$(date +"%y.%m.%d")
# 创建目录并确保文件存在
# mkdir -p "package/base-files/files/etc"
# touch "package/base-files/files/etc/openwrt_version"
# 使用 sed 将文件内容替换为 openwrt_version 变量的内容
sed -i "s/.*/$openwrt_version/" "package/base-files/files/etc/openwrt_version"
# 输出确认消息
echo "Version file has been customized to '$openwrt_version'."

#修复freeswitch依赖缺失
PKG_PATCH="$GITHUB_WORKSPACE/openwrt/package/"
cd $PKG_PATCH
FW_FILE=$(find ../feeds/telephony/ -maxdepth 4 -type f -wholename "*/freeswitch/Makefile")
if [ -f "$FW_FILE" ]; then
	sed -i "s/libpcre/libpcre2/g" $FW_FILE

	cd $PKG_PATCH && echo "freeswitch has been fixed!"
fi
