#!/bin/bash

OP_SC_DIR=$(pwd)


################ 修改 Nick 的源码 -Start- ################
# 移除多余组件
sed -i '/coremark/d' 02_prepare_package.sh
sed -i '/autoreboot/d' 02_prepare_package.sh
sed -i '/ramfree/d' 02_prepare_package.sh
sed -i '/fuck/d' 02_prepare_package.sh

# 替换默认设置
pushd ${OP_SC_DIR}/../PATCH/duplicate/addition-trans-zh-r2s/files
  rm -f zzz-default-settings
  cp ${OP_SC_DIR}/../PATCH/zzz-default-settings ./
popd
################ 修改 Nick 的源码 -End- ################


################ 执行 02 脚本 -Start- ################
/bin/bash 02_prepare_package.sh
/bin/bash 02_R2S.sh
################ 执行 02 脚本 -End- ################


################ 自定义部分 -Start- ################
# 调整 LuCI 依赖，去除 luci-app-opkg，替换主题 bootstrap 为 argon
sed -i 's/+luci-app-opkg //' ./feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci/Makefile

# Argon 主题
rm -fr package/new/luci-theme-argon
git clone -b master --single-branch https://github.com/jerrykuku/luci-theme-argon package/new/luci-theme-argon
pushd package/new/luci-theme-argon
  pushd luasrc/view/themes/argon
    ## 移除 footer.htm 底部文字
    sed -i '/<a class=\"luci-link\" href=\"https:\/\/github.com\/openwrt\/luci\">/d' footer.htm
    sed -i '/<a href=\"https:\/\/github.com\/jerrykuku\/luci-theme-argon\">/d' footer.htm
    sed -i '/<%= ver.distversion %>/d' footer.htm
    ## 移除 footer_login.htm 底部文字
    sed -i '/<a class=\"luci-link\" href=\"https:\/\/github.com\/openwrt\/luci\">/d' footer_login.htm
    sed -i '/<a href=\"https:\/\/github.com\/jerrykuku\/luci-theme-argon\">/d' footer_login.htm
    sed -i '/<%= ver.distversion %>/d' footer_login.htm
  popd
  pushd htdocs/luci-static/argon
    ## 替换默认首页背景
    rm -f img/bg1.jpg
    cp ${OP_SC_DIR}/../PATCH/background.jpg img/bg1.jpg
    cp ${OP_SC_DIR}/../PATCH/background.jpg background/
  popd
popd

# Bootstrap 主题移除底部文字
sed -i '/<a href=\"https:\/\/github.com\/openwrt\/luci\">/d' feeds/luci/themes/luci-theme-bootstrap/luasrc/view/themes/bootstrap/footer.htm

# SSRPlus 微调
pushd package/lean/luci-app-ssr-plus
  ## 修改部分内容
  pushd luasrc/model/cbi/shadowsocksr
    sed -i 's_ShadowSocksR Plus+ Settings"), translate(.*))_SSRPlus"))_' client.lua
    sed -i 's_shadowsocksr", translate(".*")_shadowsocksr"_' servers.lua
    sed -i '/Customize Netflix IP Url/d' advanced.lua
  popd
  pushd luasrc/view/shadowsocksr
    sed -i 's_ShadowsocksR Plus+ __' status.htm
  popd
  ## 修改部分翻译
  pushd po/zh-cn/
    sed -i '/ShadowSocksR Plus+ Settings/d' ssr-plus.po
    sed -i '/ShadowSocksR Plus+ 设置/d' ssr-plus.po
    sed -i '/<h3>Support SS/d' ssr-plus.po
    sed -i '/<h3>支持 SS/d' ssr-plus.po
    sed -i '/Customize Netflix IP Url/d' ssr-plus.po
    sed -i '/自定义Netflix IP更新URL（默认项目地址：/d' ssr-plus.po
  popd
  ## 全局替换 ShadowSocksR Plus+ 为 SSRPlus
  ssfiles="$(find 2>"/dev/null")"
  for ssf in ${ssfiles}; do
    if [ -f "$ssf" ]; then
      sed -i 's/ShadowSocksR Plus+/SSRPlus/gi' "$ssf"
    fi
  done
popd

# # OpenClash
# rm -fr package/new/luci-app-openclash
# rm -fr package/new/OpenClash
# git clone -b master --depth 1 https://github.com/vernesong/OpenClash package/new/OpenClash
# mv package/new/OpenClash/luci-app-openclash package/new/luci-app-openclash
# rm -fr package/new/OpenClash
# ## 编译并使用最新的控制面板
# git clone -b master --single-branch https://github.com/haishanh/yacd.git
# pushd yacd
#   yarn
#   yarn build
# popd
# git clone -b master --single-branch https://github.com/Dreamacro/clash-dashboard.git
# pushd clash-dashboard
#   yarn
#   yarn build
# popd
# pushd package/new/luci-app-openclash/root/usr/share/openclash
#   rm -fr dashboard yacd
#   mv ${OP_SC_DIR}/yacd/public ./yacd
#   mv ${OP_SC_DIR}/clash-dashboard/dist ./dashboard
# popd
# rm -fr ${OP_SC_DIR}/yacd
# rm -fr ${OP_SC_DIR}/clash-dashboard
# ## 预置 Clash 内核
# clash_dev_url=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/Clash | grep /clash-linux-armv8 | sed 's/.*url\": \"//g' | sed 's/\"//g')
# clash_game_url=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/TUN | grep /clash-linux-armv8 | sed 's/.*url\": \"//g' | sed 's/\"//g')
# clash_premium_url=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/TUN-Premium | grep /clash-linux-armv8 | sed 's/.*url\": \"//g' | sed 's/\"//g')
# mkdir -p package/base-files/files/etc/openclash/core
# pushd package/base-files/files/etc/openclash/core
#   wget -qO- $clash_dev_url | tar xOvz > clash
#   wget -qO- $clash_game_url | tar xOvz > clash_game
#   wget -qO- $clash_premium_url | gunzip -c > clash_tun
#   chmod +x clash*
# popd

# 调整默认 LAN IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
################ 自定义部分 -End- ################


unset OP_SC_DIR

exit 0
