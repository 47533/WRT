#!/bin/bash
# 京东云亚瑟 专属私有扩展脚本 - SWAP + 内置 AdGuardHome & OpenClash 核心

echo "==== 执行私有扩展：亚瑟专用配置（SWAP + 内置核心）===="

# -------------------------- 原有 SWAP 配置（保留不动） --------------------------
SWAP_SIZE_MB=4096    # SWAP大小，可改成2048或8192
PARTITION="/dev/mmcblk0p27"
MOUNT_POINT="/mnt/mmc27"
SWAP_FILE="$MOUNT_POINT/swapfile"

mkdir -p ./files/etc/init.d
mkdir -p ./files/etc/hotplug.d/block

cat > ./files/etc/init.d/swap_mmc27 << EOF
#!/bin/sh /etc/rc.common
START=50
start() {
    if [ ! -b "$PARTITION" ]; then exit 0; fi
    mount $PARTITION $MOUNT_POINT 2>/dev/null
    if [ -f "$SWAP_FILE" ]; then
        swapon $SWAP_FILE
        echo "mmcblk0p27 SWAP 已加载"
    fi
}
EOF

cat > ./files/etc/hotplug.d/block/99-swap-mmc27 << EOF
#!/bin/sh
if [ "\$ACTION" = "add" ] && [ "\$DEVICENAME" = "mmcblk0p27" ]; then
    mkdir -p $MOUNT_POINT
    mount $PARTITION $MOUNT_POINT
    if [ ! -f "$SWAP_FILE" ]; then
        echo "创建 ${SWAP_SIZE_MB}MB SWAP..."
        dd if=/dev/zero of=$SWAP_FILE bs=1M count=$SWAP_SIZE_MB
        chmod 600 $SWAP_FILE
        mkswap $SWAP_FILE
    fi
    swapon $SWAP_FILE
    sync
fi
EOF

chmod +x ./files/etc/init.d/swap_mmc27
chmod +x ./files/etc/hotplug.d/block/99-swap-mmc27
# ---------------------------------------------------------------------------

# ====================== 内置 AdGuardHome 核心 (aarch64) ======================
echo "正在下载 AdGuardHome 核心..."
mkdir -p ./files/usr/bin
wget -qO- https://static.adguard.com/adguardhome/release/AdGuardHome_linux_arm64.tar.gz | \
tar -xz -C ./files/usr/bin --strip-components=2 AdGuardHome/AdGuardHome
chmod +x ./files/usr/bin/AdGuardHome

# ====================== 内置 OpenClash 核心 (mihomo - 推荐) ======================
echo "正在下载 OpenClash mihomo 核心..."
mkdir -p ./files/etc/openclash/core

# 获取最新 mihomo arm64 版本（alpha 版性能更好）
LATEST_MIHOMO=$(curl -s https://api.github.com/repos/MetaCubeX/mihomo/releases/latest | grep "browser_download_url" | grep "linux-arm64" | head -n1 | cut -d '"' -f 4)

wget -q "$LATEST_MIHOMO" -O - | gunzip > ./files/etc/openclash/core/mihomo
chmod +x ./files/etc/openclash/core/mihomo

# 可选：同时内置 clash_meta（更稳定）
# wget -q https://github.com/MetaCubeX/mihomo/releases/latest/download/mihomo-linux-arm64-v1.x.x.gz -O - | gunzip > ./files/etc/openclash/core/clash_meta

echo "AdGuardHome 和 OpenClash 核心已内置完成！"
echo "==== 私有扩展执行完毕 ===="
