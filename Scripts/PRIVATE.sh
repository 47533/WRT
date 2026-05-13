#!/bin/bash
# 京东云亚瑟 专属 - mmcblk0p27 分区 SWAP 自动配置脚本
# 独立运行，编译时一键调用

# 配置参数（可自行修改）
SWAP_SIZE_MB=4096    # SWAP大小 4096=4G，2048=2G，1024=1G
PARTITION="/dev/mmcblk0p27"
MOUNT_POINT="/mnt/mmc27"
SWAP_FILE="$MOUNT_POINT/swapfile"
INIT_FILE="/etc/init.d/swap_auto_mount"

echo "==== 开始配置 mmcblk0p27 SWAP 虚拟内存 ===="

# 1. 创建挂载目录
mkdir -p $MOUNT_POINT
mkdir -p ./files/etc/init.d
mkdir -p ./files/etc/hotplug.d/block

# 2. 生成开机自动挂载+SWAP自启服务
cat > ./files/$INIT_FILE << EOF
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
        echo "SWAP 已加载"
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

# 4. 赋予权限
chmod +x ./files/$INIT_FILE
chmod +x ./files/etc/hotplug.d/block/99-swap-mmc27

echo "==== SWAP 脚本嵌入固件完成！开机自动启用 ===="
