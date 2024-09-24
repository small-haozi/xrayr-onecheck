```
# 克隆仓库
git clone https://github.com/small-haozi/xrayr-onecheck.git

# 进入该文件夹
cd xrayr-onecheck

# 给脚本添加执行权限
chmod +x haha.sh
```
```
# 执行脚本
./haha.sh
```

或

```
# 克隆仓库
git clone https://github.com/small-haozi/xrayr-onecheck.git

# 进入该文件夹
cd xrayr-onecheck

# 给脚本添加执行权限
chmod +x haha.sh
```
```
# 携带参数执行脚本
./haha.sh 节点id 节点类型 "对接域名" "对接密钥" 上报阈值 是否开启审计 是否优化连接配置 解锁类型 "解锁项目 以空格隔开"
```
示例：./haha.sh 1 Shadowsocks "example.com" "your_secret_key" 2000 yes yes 1 "1 2 3"<br>
如果只是对接节点   最后两个参数可不写！！！本脚本目前仅支持Shadowsocks  Vmess   其他协议自行修改其他参数

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

解锁项目：<br>
       "1) YouTube                 21) LineTV             41) Watcha"<br>
       "2) Netflix                 22) CatchPlay          42) SpotvNow"<br>
       "3) Disney+                 23) Niconico           43) Discovery+"     <br>
       "4) Bilibili                24) FOD                44) ESPN+"<br>
       "5) TikTok                  25) DAM                45) Fox"<br>
       "6) DAZN                    26) UNEXT              46) FuboTV"<br>
       "7) Abema                   27) Music.JP           47) Paramount+"     <br>   
       "8) Bahamut                 28) Radiko             48) PeacockTV"<br>
       "9) HBO Max                 29) Telasa             49) Star+"<br>
       "10) ChatGPT                30) Hulu               50) BritBox"<br>
       "11) Steam                  31) WOWOW              51) FXNOW"<br>
       "12) AmazonPrimeVideo       32) J-OnDemand         52) Philo"<br>
       "13) TVBAnywhere            33) DMM                53) Shudder"<br>
       "14) Spotify                34) JapaneseGames      54) TLCGO"<br>
       "15) VIU                    35) Wavve              55) BBC"<br>
       "16) MyTvSuper              36) Tving"<br>
       "17) NowE                   37) CoupangPlay"<br>
       "18) HboGOAsia              38) NaverTV"<br>
       "19) KKTV                   39) AfreecaTV"<br>
       "20) LiTV                   40) KBSDomestic"<br>
 填前面的序号就行
