```
# 创建一个名为 xrayr-onecheck 的文件夹
mkdir -p xrayr-onecheck

# 进入该文件夹
cd xrayr-onecheck

# 下载 haha.sh 脚本到当前文件夹
curl -O https://raw.githubusercontent.com/small-haozi/xrayr-onecheck/main/haha.sh

# 给脚本添加执行权限
chmod +x haha.sh

#执行脚本
./haha.sh
```

或

```
# 创建一个名为 xrayr-onecheck 的文件夹
mkdir -p xrayr-onecheck

# 进入该文件夹
cd xrayr-onecheck

# 下载 haha.sh 脚本到当前文件夹
curl -O https://raw.githubusercontent.com/small-haozi/xrayr-onecheck/main/haha.sh

# 给脚本添加执行权限
chmod +x haha.sh

#携带参数执行脚本
./haha.sh 节点id 节点类型 "对接域名" "对接密钥" 上报阈值 是否开启审计 是否优化连接配置 解锁类型 "解锁项目 以空格隔开"
```
示例：./haha.sh 1 Shadowsocks "example.com" "your_secret_key" 200 yes yes 1 "1 2 3"

```
./haha.sh
```
或
```
./haha.sh 节点id 节点类型 "对接域名" "对接密钥" 上报阈值 是否开启审计 是否优化连接配置 解锁类型（自有分流或NF分流） "解锁项目 以空格隔开"
```

解锁类型：<br>
1.为NF解锁的配置<br>
2.为自建分流节点的配置

解锁项目：
1)  "YouTube" ;;
2)  "Netflix" ;;
3)  "Disney+" ;;
4)  "Bilibili" ;;
5)  "TikTok" ;;
6)  "DAZN" ;;
7)  "Abema" ;;
8)  "Bahamut" ;;
9)  "HBO Max" ;;
10)  "ChatGPT" ;;
11)  "Steam" ;;
 填前面的序号就行
