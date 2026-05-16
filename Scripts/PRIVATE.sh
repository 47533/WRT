#!/bin/bash
echo "==== 47533 私有脚本执行 ===="

# ====================== AdGuardHome 核心 ======================
echo -e "\n[1] 创建 AdGuardHome 目录..."
mkdir -p ./files/usr/bin/AdGuardHome
echo "[√] AdGuardHome 目录创建成功"

echo "[2] 开始内置 AdGuardHome 核心..."
wget -q --no-check-certificate -O- https://static.adguard.com/adguardhome/release/AdGuardHome_linux_arm64.tar.gz | tar -xz -C ./files/usr/bin/AdGuardHome --strip-components=1
chmod +x ./files/usr/bin/AdGuardHome/AdGuardHome
echo "[√] AdGuardHome 核心内置并授权成功"

# ====================== OpenClash 官方核心 ======================
echo -e "\n[3] 创建 OpenClash 核心目录..."
mkdir -p ./files/etc/openclash/core
echo "[√] OpenClash 目录创建成功"

echo "[4] 开始内置 OpenClash 官方核心..."
wget -q --no-check-certificate -O- https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz | tar -xz -O > ./files/etc/openclash/core/clash_meta
chmod +x ./files/etc/openclash/core/clash_meta
echo "[√] OpenClash 核心内置并授权成功"

echo -e "\n==== 所有核心内置完成，脚本执行完毕 ===="
