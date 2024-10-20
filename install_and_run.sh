#!/bin/bash

# 使用 curl 下载并直接运行安装脚本
curl -s https://raw.githubusercontent.com/small-haozi/xrayr-onecheck/main/install.sh | bash

# 执行 haha 脚本并传递参数
haha "$1" "$2" "$3" "$4" "$5" "$6" "$7"
