#!/bin/bash
echo "==== 47533 私有脚本执行 ===="

# ====================== 【已修复】AdGuardHome 核心 正确路径 ======================
echo "内置 AdGuardHome 核心..."
mkdir -p ./files/usr/bin/AdGuardHome
wget -q --no-check-certificate -O- https://static.adguard.com/adguardhome/release/AdGuardHome_linux_arm64.tar.gz | tar -xz -C ./files/usr/bin/AdGuardHome --strip-components=1
chmod +x ./files/usr/bin/AdGuardHome/AdGuardHome

# ====================== OpenClash 核心（正常） ======================
echo "内置 Clash 核心..."
mkdir -p ./files/etc/openclash/core
wget -q --no-check-certificate -O- https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz | tar -xz -C ./files/etc/openclash/core/
chmod +x ./files/etc/openclash/core/clash_meta

echo "==== 执行完成 ===="
