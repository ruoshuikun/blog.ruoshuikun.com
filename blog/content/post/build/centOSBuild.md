---
title: "CentOSBuild"
date: 2023-03-14T16:26:20+08:00
draft: true
---

```sh
<<'COMMENT'
 * @desc: centOS 打包脚本
 * @author: zhang lin
 * @update: 2022-05-11
COMMENT
fileName=business
npm i
npm run build:test
echo -e "\033[32m打包完成\033[0m"

funcBuild() {
  time=$(date "+%Y%m%d-%H:%M:%S")
  # 备份
  mv /root/shortcut/html/${fileName} /root/shortcut/html/${fileName}-${time}
  # 部署，把 dist 的内容移动到 demo/${fileName} 目录下
  mv dist /root/shortcut/html/${fileName}
}

echo -e "\033[33m是否部署？[Y/n]\033[0m"
read aNum
case $aNum in
y)
  echo -e "\033[1;32m正在备份……\033[0m"
  funcBuild
  ;;
n)
  echo -e "\033[31m不部署\033[0m"
  ;;
*)
  echo -e "\033[35m您没有输入，默认为部署\033[0m"
  funcBuild
  ;;
esac
echo -e "\033[1;32m部署完毕\033[0m"

```