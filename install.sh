#!/bin/bash

# 定义颜色
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 安装必要的软件包
echo -e "${GREEN}安装必要的软件包...${NC}"
apt update && apt install -y curl jq

# 检查 jq 是否安装成功
if ! command -v jq &> /dev/null; then
  echo -e "${RED}jq 安装失败，请手动执行 sudo apt-get install -y jq  安装jq。${NC}"
  exit 1
fi

# 检查是否已安装 XrayR
if ! command -v XrayR &> /dev/null; then
  echo -e "${GREEN}XrayR 未安装，正在下载并安装 XrayR...${NC}"
  wget -N https://raw.githubusercontent.com/wyx2685/XrayR-release/master/install.sh && bash install.sh
else
  echo -e "${GREEN}XrayR 已安装，跳过安装步骤。${NC}"
fi

# 定义目标路径
TARGET_DIR="/etc/xrayr-onecheck"

# 创建目标路径（如果不存在）
mkdir -p "$TARGET_DIR/scripts/default"
mkdir -p "$TARGET_DIR/scripts/custom"
mkdir -p "$TARGET_DIR/templates"

# 检查 config.yml 是否存在
if [ -f "$TARGET_DIR/config.yml" ]; then
    echo "config.yml 已存在，跳过下载。"
else
    # 下载 config.yml
    curl -o "$TARGET_DIR/config.yml" "https://raw.githubusercontent.com/small-haozi/xrayr-onecheck/refs/heads/main/config.yml"
    echo "config.yml 已成功下载到 $TARGET_DIR"
fi

# 下载其他文件
echo -e "${GREEN}下载脚本文件中.....${NC}"
curl --progress-bar -o "$TARGET_DIR/haha.sh" "https://raw.githubusercontent.com/small-haozi/xrayr-onecheck/refs/heads/main/haha.sh"
curl --progress-bar -o "$TARGET_DIR/templates/route_templates.json" "https://raw.githubusercontent.com/small-haozi/xrayr-onecheck/refs/heads/main/templates/route_templates.json"
curl --progress-bar -o "$TARGET_DIR/templates/custom_route_templates.json" "https://raw.githubusercontent.com/small-haozi/xrayr-onecheck/refs/heads/main/templates/custom_route_templates.json"
curl --progress-bar -o "$TARGET_DIR/scripts/default/projects.sh" "https://raw.githubusercontent.com/small-haozi/xrayr-onecheck/refs/heads/main/scripts/default/projects.sh"
curl --progress-bar -o "$TARGET_DIR/scripts/default/unlock_map.sh" "https://raw.githubusercontent.com/small-haozi/xrayr-onecheck/refs/heads/main/scripts/default/unlock_map.sh"
curl --progress-bar -o "$TARGET_DIR/scripts/custom/projects.sh" "https://raw.githubusercontent.com/small-haozi/xrayr-onecheck/refs/heads/main/scripts/custom/projects.sh"
curl --progress-bar -o "$TARGET_DIR/scripts/custom/unlock_map.sh" "https://raw.githubusercontent.com/small-haozi/xrayr-onecheck/refs/heads/main/scripts/custom/unlock_map.sh"

# 设置文件权限
chmod +x "$TARGET_DIR/haha.sh"

# 创建符号链接
ln -sf "$TARGET_DIR/haha.sh" "/usr/local/bin/haha"
echo -e "------------------------------------------------"
echo -e ""
echo -e "${GREEN}文件已成功下载并放置到 $TARGET_DIR，你可以随时输入 haha 唤起脚本${NC}"
echo -e ""
echo -e "${GREEN}或使用 haha 节点id 节点类型 \"对接域名\" \"对接密钥\" 上报阈值 是否开启审计 是否优化连接配置 解锁类型 \"解锁项目 以空格隔开\" ${NC}"
echo -e ""
echo -e "------------------------------------------------"

# 删除自身
rm -- "$0"
