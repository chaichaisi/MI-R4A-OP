#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part3.sh
# Description: OpenWrt DIY script part 3 (Before Update feeds)
#

mv MI-R4A/favicon.ico openwrt/package/lean/luci-theme-argon_armygreen/htdocs/luci-static/argon_armygreen/favicon.ico
mv MI-R4A/2019-10-07_13.36-540p.jpg openwrt/feeds/kenzo/luci-theme-ifit/files/htdocs/images/main_bg.jpg
rm openwrt/feeds/kenzo/luci-theme-ifit/files/htdocs/images/main_bg_5k.jpg
mv MI-R4A/banner openwrt/package/base-files/files/etc/banner
