#!/bin/bash

# 定义颜色代码
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # 用于重置颜色

# 检查是否以root权限运行
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}请以root权限运行此脚本${NC}"
  exit 1
fi
if [ "$#" -eq 7 ];then
  node_id="$1"
  node_type="$2"
  api_host="$3"
  api_key="$4"
  device_online_min_traffic="$5"
  enable_audit="$6"
  optimize_connection_config="$7"

  # 执行对接节点配置
  if [ -n "$node_id" ] && [ -n "$node_type" ] && [ -n "$device_online_min_traffic" ] && [ -n "$api_host" ] && [ -n "$api_key" ]; then
    # 根据是否开启审计设置配置项
    if [ "$enable_audit" == "yes" ]; then
      route_config_path="/etc/XrayR/route.json"
      outbound_config_path="/etc/XrayR/custom_outbound.json"
    else
      route_config_path=""
      outbound_config_path=""
    fi

    # 修改配置文件
    echo "修改配置文件..."
    config_file="/etc/XrayR/config.yml"

    # 使用sed命令修改相应的配置项
    sed -i "s/NodeID: .*/NodeID: $node_id/" $config_file
    sed -i "s/NodeType: .*/NodeType: $node_type/" $config_file
    sed -i "s/DeviceOnlineMinTraffic: .*/DeviceOnlineMinTraffic: $device_online_min_traffic/" $config_file
    sed -i "s|RouteConfigPath: .*|RouteConfigPath: $route_config_path|" $config_file
    sed -i "s|OutboundConfigPath: .*|OutboundConfigPath: $outbound_config_path|" $config_file
    sed -i "s|ApiHost: .*|ApiHost: \"$api_host\"|" $config_file
    sed -i "s|ApiKey: .*|ApiKey: \"$api_key\"|" $config_file

    # 根据用户选择优化 ConnectionConfig 配置
    if [ "$optimize_connection_config" == "yes" ]; then
      sed -i "s/Handshake: .*/Handshake: 8/" $config_file
      sed -i "s/ConnIdle: .*/ConnIdle: 10/" $config_file
      sed -i "s/UplinkOnly: .*/UplinkOnly: 4/" $config_file
      sed -i "s/DownlinkOnly: .*/DownlinkOnly: 4/" $config_file
      sed -i "s/BufferSize: .*/BufferSize: 64/" $config_file
    fi

    # 启动XrayR
    echo -e "${BLUE}重启XrayR...${NC}"
    systemctl restart XrayR
    sleep 5
    # 检查 XrayR 是否运行
    if systemctl is-active --quiet XrayR; then
      echo -e "${GREEN}XrayR重启成功${NC}"
    else
      echo -e "${RED}XrayR重启失败 请检查配置{NC}"
    fi
  fi
  exit 0
fi
# 检查传递的参数数量
if [ "$#" -eq 9 ];then
  node_id="$1"
  node_type="$2"
  api_host="$3"
  api_key="$4"
  device_online_min_traffic="$5"
  enable_audit="$6"
  optimize_connection_config="$7"
  unlock_method="$8"
  unlock_options="$9"

  # 执行对接节点配置
  if [ -n "$node_id" ] && [ -n "$node_type" ] && [ -n "$device_online_min_traffic" ] && [ -n "$api_host" ] && [ -n "$api_key" ]; then
    # 根据是否开启审计设置配置项
    if [ "$enable_audit" == "yes" ]; then
      route_config_path="/etc/XrayR/route.json"
      outbound_config_path="/etc/XrayR/custom_outbound.json"
    else
      route_config_path=""
      outbound_config_path=""
    fi

    # 修改配置文件
    echo "修改配置文件..."
    config_file="/etc/XrayR/config.yml"

    # 使用sed命令修改相应的配置项
    sed -i "s/NodeID: .*/NodeID: $node_id/" $config_file
    sed -i "s/NodeType: .*/NodeType: $node_type/" $config_file
    sed -i "s/DeviceOnlineMinTraffic: .*/DeviceOnlineMinTraffic: $device_online_min_traffic/" $config_file
    sed -i "s|RouteConfigPath: .*|RouteConfigPath: $route_config_path|" $config_file
    sed -i "s|OutboundConfigPath: .*|OutboundConfigPath: $outbound_config_path|" $config_file
    sed -i "s|ApiHost: .*|ApiHost: \"$api_host\"|" $config_file
    sed -i "s|ApiKey: .*|ApiKey: \"$api_key\"|" $config_file

    # 根据用户选择优化 ConnectionConfig 配置
    if [ "$optimize_connection_config" == "yes" ]; then
      sed -i "s/Handshake: .*/Handshake: 8/" $config_file
      sed -i "s/ConnIdle: .*/ConnIdle: 10/" $config_file
      sed -i "s/UplinkOnly: .*/UplinkOnly: 4/" $config_file
      sed -i "s/DownlinkOnly: .*/DownlinkOnly: 4/" $config_file
      sed -i "s/BufferSize: .*/BufferSize: 64/" $config_file
    fi

    # 启动XrayR
    echo -e "${BLUE}重启XrayR...${NC}"
    systemctl restart XrayR

    echo -e "${GREEN}XrayR配置修改完成！${NC}"
  fi

  # 执行解锁配置
  if [ "$unlock_method" == "1" ]; then
    # 分流解锁
    echo -e "${BLUE}配置分流解锁...${NC}"
    config_file="/etc/xrayr-onecheck/config.yml"

    # 修改 RouteConfigPath 和 OutboundConfigPath 配置项
    sed -i "s|RouteConfigPath: .*|RouteConfigPath: /etc/XrayR/route.json|" /etc/XrayR/config.yml
    sed -i "s|OutboundConfigPath: .*|OutboundConfigPath: /etc/XrayR/custom_outbound.json|" /etc/XrayR/config.yml

    # 提示用户去修改当前脚本所在目录中的 config 文件
    echo -e "${BLUE}请修改当前脚本所在目录中的 config.yml 文件，配置项目需要包含一个uuid，以及各个国家的分流节点域名和端口。${NC}"
    echo "例如："
    echo "  - name: US"
    echo "    uuid: <解锁项目的uuid>"
    echo "    domain: us.example.com"
    echo "    port: 443"
    echo "  - name: JP"
    echo "    uuid: <解锁项目的uuid>"
    echo "    domain: jp.example.com"
    echo "    port: 443"

    # 等待用户确认
    read -p "修改完成后按任意键继续..."

    # 引用 unlock_map.sh 和 projects.sh 文件
    source /etc/xrayr-onecheck/scripts/default/unlock_map.sh
    source /etc/xrayr-onecheck/scripts/default/projects.sh

    # 选择解锁项目
    if [ -z "$unlock_options" ]; then
      echo -e "${GREEN}请选择要解锁的项目 (用空格分隔多个选项):${NC}"
      echo ""

      # 获取项目列表并排序
      sorted_keys=($(for key in "${!project_map[@]}"; do echo $key; done | sort -n))

      # 以多列显示项目
      columns=3
      for ((i=0; i<${#sorted_keys[@]}; i+=columns)); do
        for ((j=0; j<columns; j++)); do
          index=$((i + j))
          if [ $index -lt ${#sorted_keys[@]} ]; then
            key=${sorted_keys[$index]}
            printf "%-4s %-20s" "$key)" "${project_map[$key]}"
          fi
        done
        echo ""
      done

      echo ""
      read -p "请输入解锁选项 (例如: 2 4 9): " unlock_options
    fi

    # 修改 custom_outbound.json 文件的内容
    echo "修改 /etc/XrayR/custom_outbound.json 文件..."
    cat <<EOF > /etc/XrayR/custom_outbound.json
[
  {
    "tag": "IPv4_out",
    "sendThrough": "0.0.0.0",
    "protocol": "freedom"
  }
EOF

    # 初始化一个关联数组来存储每个tag的配置信息
    declare -A outbound_map

    for option in $unlock_options; do
      country=${unlock_map[$option]}
      uuid=$(grep -A 3 "name: $country" $config_file | grep "uuid" | awk '{print $2}')
      domain=$(grep -A 3 "name: $country" $config_file | grep "domain" | awk '{print $2}')
      port=$(grep -A 3 "name: $country" $config_file | grep "port" | awk '{print $2}')
      country_lower=$(echo "$country" | tr '[:upper:]' '[:lower:]')
      outbound_map["$country_lower"]='{
    "protocol": "Shadowsocks",
    "settings": {
      "servers": [
        {
          "address": "'$domain'",
          "port": '$port',
          "method": "chacha20-ietf-poly1305",
          "password": "'$uuid'"
        }
      ]
    },
    "tag": "unlock-'$country_lower'"
  }'
    done

    # 将收集到的配置信息写入 custom_outbound.json 文件
    for tag in "${!outbound_map[@]}"; do
      echo '  ,' >> /etc/XrayR/custom_outbound.json
      echo "${outbound_map[$tag]}" >> /etc/XrayR/custom_outbound.json
    done

    # 结束 custom_outbound.json 文件
    echo ']' >> /etc/XrayR/custom_outbound.json

    echo -e "${GREEN}解锁配置完成！${NC}"
    echo -e "${BLUE}开始配置路由！${NC}"

    # 修改 route.json 文件的内容
    echo "修改 /etc/XrayR/route.json 文件..."
    echo '{
  "domainStrategy": "IPOnDemand",
  "rules": [' > /etc/XrayR/route.json

    # 初始化一个关联数组来存储每个国家的域名
    declare -A domain_map

    for option in $unlock_options; do
      country=${unlock_map[$option]}
      country_lower=$(echo "$country" | tr '[:upper:]' '[:lower:]')
      project=${project_map[$option]}
      domains=$(jq -r --arg country "$country" --arg project "$project" '.[$country].domain[$project][]' /etc/xrayr-onecheck/templates/custom_route_templates.json)
      if [ $? -ne 0 ]; then
        echo "Error: Failed to process domains for project $project"
        exit 1
      fi
      for domain in $domains; do
        domain_map["$country_lower"]+='"'$domain'",'
      done
    done

    # 将收集到的域名写入 route.json 文件
    first_rule=true
    for country in "${!domain_map[@]}"; do
      if [ "$first_rule" = true ]; then
        first_rule=false
      else
        echo '    ,' >> /etc/XrayR/route.json
      fi
      echo '    {
    "type": "field",
    "outboundTag": "unlock-'$country'",
    "domain": [' >> /etc/XrayR/route.json
      echo "${domain_map[$country]}" | sed 's/,$//' | sed 's/,/,\n      /g' >> /etc/XrayR/route.json
      echo '    ]
  }' >> /etc/XrayR/route.json
    done

    # 结束 route.json 文件
    echo '  ]
}' >> /etc/XrayR/route.json

    echo -e "${GREEN}路由配置完成！${NC}"
    systemctl restart XrayR
    # 检查 XrayR 是否运行
    if systemctl is-active --quiet XrayR; then
      echo -e "${GREEN}XrayR重启成功${NC}"
    else
      echo -e "${RED}XrayR重启失败 请检查配置{NC}"
    fi
  else
    echo -e "${RED}无效选项，请重新选择${NC}"
  fi
else
  # 显示菜单
  while true; do
    echo ""
    echo -e "${GREEN}            XrayR一键对接+解锁脚本   ${NC}"
    echo -e "${YELLOW}--- 项目地址：https://github.com/small-haozi/xrayr-onecheck ---${NC}"
    echo ""
    echo -e "${GREEN}    请选择操作：${NC}"
    echo "---------------------"
    echo ""
    echo "    1) 对接节点"
    echo ""
    echo "    2) 配置解锁"
    echo ""
    echo "---------------------"
    echo "    0) 退出脚本"
    echo ""
    read -p "请输入选项: " option

    case $option in
      1)
        # 解析命令行参数
        node_id="$1"
        node_type="$2"
        api_host="$3"
        api_key="$4"
        device_online_min_traffic="$5"
        enable_audit="$6"
        optimize_connection_config="$7"
        unlock_method="$8"
        unlock_options="$9"

        # 如果没有传递参数，则提示用户输入
        if [ -z "$node_id" ]; then
          read -p "请输入节点ID: " node_id
        fi

        if [ -z "$node_type" ]; then
          read -p "请输入节点类型 (V2ray, Vmess, Vless, Shadowsocks, Trojan, Shadowsocks-Plugin): " node_type
        fi

        if [ -z "$api_host" ]; then
          read -p "请输入对接域名 (例如: https://baidu.com): " api_host
        fi

        if [ -z "$api_key" ]; then
          read -p "请输入对接域名对接密钥: " api_key
        fi

        if [ -z "$device_online_min_traffic" ]; then
          read -p "请输入设备在线上报阈值 (单位: kB): " device_online_min_traffic
        fi

        if [ -z "$enable_audit" ]; then
          read -p "是否开启审计 (yes/no): " enable_audit
        fi

        if [ -z "$optimize_connection_config" ]; then
          read -p "是否优化 ConnectionConfig 配置 (yes/no): " optimize_connection_config
        fi

        # 对接节点配置
        if [ -n "$node_id" ] && [ -n "$node_type" ] && [ -n "$device_online_min_traffic" ] && [ -n "$api_host" ]; then
          # 根据是否开启审计设置配置项
          if [ "$enable_audit" == "yes" ]; then
            route_config_path="/etc/XrayR/route.json"
            outbound_config_path="/etc/XrayR/custom_outbound.json"
          else
            route_config_path=""
            outbound_config_path=""
          fi

          # 修改配置文件
          echo -e "${BLUE}修改配置文件...${NC}"
          config_file="/etc/XrayR/config.yml"

          # 使用sed命令修改相应的配置项
          sed -i "s/NodeID: .*/NodeID: $node_id/" $config_file
          sed -i "s/NodeType: .*/NodeType: $node_type/" $config_file
          sed -i "s/DeviceOnlineMinTraffic: .*/DeviceOnlineMinTraffic: $device_online_min_traffic/" $config_file
          sed -i "s|RouteConfigPath: .*|RouteConfigPath: $route_config_path|" $config_file
          sed -i "s|OutboundConfigPath: .*|OutboundConfigPath: $outbound_config_path|" $config_file
          sed -i "s|ApiHost: .*|ApiHost: \"$api_host\"|" $config_file
          sed -i "s|ApiKey: .*|ApiKey: \"$api_key\"|" $config_file

          # 根据用户选择优化 ConnectionConfig 配置
          if [ "$optimize_connection_config" == "yes" ]; then
            sed -i "s/Handshake: .*/Handshake: 8/" $config_file
            sed -i "s/ConnIdle: .*/ConnIdle: 10/" $config_file
            sed -i "s/UplinkOnly: .*/UplinkOnly: 4/" $config_file
            sed -i "s/DownlinkOnly: .*/DownlinkOnly: 4/" $config_file
            sed -i "s/BufferSize: .*/BufferSize: 64/" $config_file
          fi

          # 启动XrayR
          echo -e "${BLUE}重启XrayR...${NC}"
          systemctl restart XrayR

          echo -e "${GREEN}XrayR配置修改完成！${NC}"
        fi
        ;;
      2)
        # 配置解锁
        if [ -z "$unlock_method" ]; then
          echo ""
          echo -e "${GREEN}    请选择解锁方式：${NC}"
          echo "-------------------"
          echo ""
          echo "    1) 分流解锁"
          echo ""
          echo "    2) 自有分流解锁"
          echo ""
          echo "-------------------"
          read -p "请输入选项: " unlock_method
        fi

        if [ "$unlock_method" == "1" ]; then
          # 分流解锁
          echo -e "${BLUE}配置分流解锁...${NC}"
          config_file="/etc/xrayr-onecheck/config.yml"

          # 修改 RouteConfigPath 和 OutboundConfigPath 配置项
          sed -i "s|RouteConfigPath: .*|RouteConfigPath: /etc/XrayR/route.json|" /etc/XrayR/config.yml
          sed -i "s|OutboundConfigPath: .*|OutboundConfigPath: /etc/XrayR/custom_outbound.json|" /etc/XrayR/config.yml

          # 提示用户去修改当前脚本所在目录中的 config 文件
          echo "请修改当前脚本所在目录中的 config.yml 文件，配置项目需要包含一个uuid，以及各个国家的分流节点域名和端口。"
          echo "例如："
          echo "  - name: US"
          echo "    uuid: <解锁项目的uuid>"
          echo "    domain: us.example.com"
          echo "    port: 443"
          echo "  - name: JP"
          echo "    uuid: <解锁项目的uuid>"
          echo "    domain: jp.example.com"
          echo "    port: 443"

          # 等待用户确认
          read -p "修改完成后按任意键继续..."

          # 引用 unlock_map.sh 和 projects.sh 文件
          source /etc/xrayr-onecheck/scripts/default/unlock_map.sh
          source /etc/xrayr-onecheck/scripts/default/projects.sh

          # 选择解锁项目
          if [ -z "$unlock_options" ]; then
            echo -e "${GREEN}请选择要解锁的项目 (用空格分隔多个选项):${NC}"
            echo ""

            # 获取项目列表并排序
            sorted_keys=($(for key in "${!project_map[@]}"; do echo $key; done | sort -n))

            # 以多列显示项目
            columns=3
            for ((i=0; i<${#sorted_keys[@]}; i+=columns)); do
              for ((j=0; j<columns; j++)); do
                index=$((i + j))
                if [ $index -lt ${#sorted_keys[@]} ]; then
                  key=${sorted_keys[$index]}
                  printf "%-4s %-20s" "$key)" "${project_map[$key]}"
                fi
              done
              echo ""
            done

            echo ""
            read -p "请输入解锁选项 (例如: 2 4 9): " unlock_options
          fi

          # 修改 custom_outbound.json 文件的内容
          echo "修改 /etc/XrayR/custom_outbound.json 文件..."
          cat <<EOF > /etc/XrayR/custom_outbound.json
[
  {
    "tag": "IPv4_out",
    "sendThrough": "0.0.0.0",
    "protocol": "freedom"
  }
EOF

          # 初始化一个关联数组来存储每个tag的配置信息
          declare -A outbound_map

          for option in $unlock_options; do
            country=${unlock_map[$option]}
            uuid=$(grep -A 3 "name: $country" $config_file | grep "uuid" | awk '{print $2}')
            domain=$(grep -A 3 "name: $country" $config_file | grep "domain" | awk '{print $2}')
            port=$(grep -A 3 "name: $country" $config_file | grep "port" | awk '{print $2}')
            country_lower=$(echo "$country" | tr '[:upper:]' '[:lower:]')
            outbound_map["$country_lower"]='{
    "protocol": "Shadowsocks",
    "settings": {
      "servers": [
        {
          "address": "'$domain'",
          "port": '$port',
          "method": "chacha20-ietf-poly1305",
          "password": "'$uuid'"
        }
      ]
    },
    "tag": "unlock-'$country_lower'"
  }'
          done

          # 将收集到的配置信息写入 custom_outbound.json 文件
          for tag in "${!outbound_map[@]}"; do
            echo '  ,' >> /etc/XrayR/custom_outbound.json
            echo "${outbound_map[$tag]}" >> /etc/XrayR/custom_outbound.json
          done

          # 结束 custom_outbound.json 文件
          echo ']' >> /etc/XrayR/custom_outbound.json

          echo -e "${GREEN}解锁配置完成！${NC}"
          echo -e "${BLUE}开始配置路由！${NC}"

          # 修改 route.json 文件的内容
          echo "修改 /etc/XrayR/route.json 文件..."
          echo '{
  "domainStrategy": "IPOnDemand",
  "rules": [' > /etc/XrayR/route.json

          # 初始化一个关联数组来存储每个国家的域名
          declare -A domain_map

          for option in $unlock_options; do
            country=${unlock_map[$option]}
            country_lower=$(echo "$country" | tr '[:upper:]' '[:lower:]')
            project=${project_map[$option]}
            domains=$(jq -r --arg country "$country" --arg project "$project" '.[$country].domain[$project][]' /etc/xrayr-onecheck/templates/custom_route_templates.json)
            if [ $? -ne 0 ]; then
              echo "Error: Failed to process domains for project $project"
              exit 1
            fi
            for domain in $domains; do
              domain_map["$country_lower"]+='"'$domain'",'
            done
          done

          # 将收集到的域名写入 route.json 文件
          first_rule=true
          for country in "${!domain_map[@]}"; do
            if [ "$first_rule" = true ]; then
              first_rule=false
            else
              echo '    ,' >> /etc/XrayR/route.json
            fi
            echo '    {
    "type": "field",
    "outboundTag": "unlock-'$country'",
    "domain": [' >> /etc/XrayR/route.json
            echo "${domain_map[$country]}" | sed 's/,$//' | sed 's/,/,\n      /g' >> /etc/XrayR/route.json
            echo '    ]
  }' >> /etc/XrayR/route.json
          done

          # 结束 route.json 文件
          echo '  ]
}' >> /etc/XrayR/route.json

          echo -e "${GREEN}路由配置完成！${NC}"
          systemctl restart XrayR
          # 检查 XrayR 是否运行
          if systemctl is-active --quiet XrayR; then
            echo -e "${GREEN}XrayR重启成功${NC}"
          else
            echo -e "${RED}XrayR重启失败 请检查配置{NC}"
          fi
        else
          echo -e "${RED}无效选项，请重新选择${NC}"
        fi
        ;;
      0)
        echo "退出脚本"
        exit 0
        ;;
      *)
        echo "无效选项，请重新选择"
        ;;
    esac
  done
fi
echo -e "${BLUE}重启XrayR...${NC}"
systemctl restart XrayR
# 等待5秒
sleep 5
# 检查 XrayR 是否运行
if systemctl is-active --quiet XrayR; then
  echo -e "${GREEN}XrayR重启成功${NC}"
else
  echo -e "${RED}XrayR重启失败 请检查配置{NC}"
fi

echo -e "${YELLOW}脚本执行完成！${NC}"
xrayr
