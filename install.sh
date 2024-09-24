#!/bin/bash

# 定义目标路径
TARGET_DIR="/etc/xrayr-onecheck"

# 创建目标路径（如果不存在）
mkdir -p "$TARGET_DIR"

# 检查 config.yml 是否存在
if [ -f "$TARGET_DIR/config.yml" ]; then
    echo "config.yml 已存在，跳过下载。"
else
    # 下载 config.yml
    curl -o "$TARGET_DIR/config.yml" "https://raw.githubusercontent.com/small-haozi/xrayr-onecheck/refs/heads/main/config.yml"
    echo "config.yml 已成功下载到 $TARGET_DIR"
fi

# 下载其他文件
curl -o "$TARGET_DIR/otherfile" "http://example.com/path/to/otherfile"

# 设置文件权限（如果需要）
chmod +x "$TARGET_DIR/otherfile"

echo "文件已成功下载并放置到 $TARGET_DIR"
