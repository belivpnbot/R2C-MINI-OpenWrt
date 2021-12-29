# NanoPi-R2C's OpenWrt mini list firmware

Based on [nicholas-opensource/OpenWrt-Autobuild](https://github.com/nicholas-opensource/OpenWrt-Autobuild/tree/main) to [openwrt/openwrt v21.02](https://github.com/openwrt /openwrt/tree/openwrt-21.02) for custom compilation

## Features

1. Default hostname: `NanoPi-R2C`

2. Default LAN IP: `192.168.2.1`

3. Default user and password: `root` `none`

4. 插件清单：

    - application：[`SSRPlus`](https://github.com/fw876/helloworld/tree/master)
    
    - theme：[`Argon (default)`](https://github.com/jerrykuku/luci-theme-argon/tree/master) [`Bootstrap`](https://github.com/openwrt/luci/tree/openwrt-21.02/themes/luci-theme-bootstrap)

5. Turn off `IPv6` by default, remove upstream components such as [`fuck`](https://github.com/nicholas-opensource/OpenWrt-Autobuild/blob/main/PATCH/new/script/fuck)

## grateful

Thanks to all the big guys who provided the upstream project code and helped, especially [nicholas-opensource](https://github.com/nicholas-opensource).

secrets.DESC OpenWrt v21.02.1 Stable Release
secrets.TG_TOKEN
secrets.TGID