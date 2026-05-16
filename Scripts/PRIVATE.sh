#!/bin/bash
# 京东云亚瑟 专属私有扩展脚本 - 内置 AdGuardHome & OpenClash 核心

echo "==== 执行私有扩展：亚瑟专用配置（内置核心）===="

# ====================== 内置 AdGuardHome 核心 (aarch64) ======================
echo "正在下载 AdGuardHome 核心..."
mkdir -p files/usr/bin/AdGuardHome

AGH_CORE=$(curl -sL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep /AdGuardHome_linux_${1} | awk -F '"' '{print $4}')

wget -qO- $AGH_CORE | tar xOvz > files/usr/bin/AdGuardHome/AdGuardHome

chmod +x files/usr/bin/AdGuardHome/AdGuardHome

echo "AdGuardHome核心已内置完成！"

# ====================== 内置 OpenClash 核心 (mihomo) ======================
echo "下载 Clash 核心..."
mkdir -p ./files/etc/openclash/core

wget -q --no-check-certificate -O- https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz | tar -xz -C ./files/etc/openclash/core/

chmod +x ./files/etc/openclash/core/clash

echo "==== Clash 核心已内置完成 ===="

echo "==== 私有扩展执行完毕 ===="
