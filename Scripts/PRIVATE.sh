#!/bin/bash
# 京东云亚瑟 专属私有扩展脚本 - mmcblk0p27 SWAP配置
# 编译时会被主脚本自动调用，无需修改主脚本

echo "==== 执行私有扩展：配置 mmcblk0p27 SWAP ===="

# -------------------------- 配置参数（可自行修改） --------------------------
SWAP_SIZE_MB=4096    # SWAP大小：4096=4G，2048=2G，1024=1G
PARTITION="/dev/mmcblk0p27"
MOUNT_POINT="/mnt/mmc27"
SWAP_FILE="$MOUNT_POINT/swapfile"
# ---------------------------------------------------------------------------

# 1. 创建挂载目录和固件内文件结构
mkdir -p ./files/etc/init.d
mkdir -p ./files/etc/hotplug.d/block

# 2. 生成开机自动挂载+SWAP自启服务
cat > ./files/etc/init.d/swap_mmc27 << EOF
#!/bin/sh /etc/rc.common
START=50
start() {
    # 挂载27分区
    if [ ! -b "$PARTITION" ]; then
        exit 0
    fi
    mount $PARTITION $MOUNT_POINT 2>/dev/null

    # 启用SWAP
    if [ -f "$SWAP_FILE" ]; then
        swapon $SWAP_FILE
        echo "mmcblk0p27 SWAP 已加载"
    fi
}
EOF

# 3. 生成首次初始化脚本（自动创建swapfile）
cat > ./files/etc/hotplug.d/block/99-swap-mmc27 << EOF
#!/bin/sh
if [ "\$ACTION" = "add" ] && [ "\$DEVICENAME" = "mmcblk0p27" ]; then
    mkdir -p $MOUNT_POINT
    mount $PARTITION $MOUNT_POINT
    
    if [ ! -f "$SWAP_FILE" ]; then
        echo "创建 $SWAP_SIZE_MB MB SWAP虚拟内存..."
        dd if=/dev/zero of=$SWAP_FILE bs=1M count=$SWAP_SIZE_MB
        chmod 600 $SWAP_FILE
        mkswap $SWAP_FILE
    fi
    
    swapon $SWAP_FILE
    sync
fi
EOF

# 4. 赋予执行权限
chmod +x ./files/etc/init.d/swap_mmc27
chmod +x ./files/etc/hotplug.d/block/99-swap-mmc27

echo "==== 私有扩展：mmcblk0p27 SWAP配置完成 ===="
