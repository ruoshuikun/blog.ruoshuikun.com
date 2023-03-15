---
title: "Build.dev"
date: 2023-03-14T16:36:02+08:00
draft: true
---

```shell
<<'COMMENT'
 * @desc: 适配不同环境的打包脚本，根据数据的标识打包【包含：删除上次打包的文件、打包、转为压缩包和打开所在文件夹】。直接复制文件即可
 * @platform: MacOS
 * @author: zhang lin
 * @update: 2022-10-10
COMMENT

identifiers=$1
suffix=':test'
name='business'

funcBuild() {
  build="npm run build$suffix"
  echo "打包命令：""\033[32m$build\033[0m"
  # 删除上次打包的文件
  rm -rf dist $name*

  # 打包
  $build
  # 压缩包
  echo "压缩包：""\033[35m$name-$identifiers.zip\033[0m"
  # 压缩文件
  zip -q -r $name-$identifiers.zip ./dist
  # 打开文件夹
  echo "\033[33m是否打开文件所在目录？[Y/n]\033[0m"
  read IsNot
  case $IsNot in
  y)
    open .
    ;;
  n)
    echo "\033[31m不打开\033[0m"
    ;;
  *)
    echo "\033[35m您没有输入，默认为打开\033[0m"
    open .
    ;;
  esac

  # 正式服务器 123
  # pnpm build && zip -q -r business-123.zip ./dist && open .
  # 测试服务器 82
  # pnpm build:test && zip -q -r business-82.zip ./dist && open .
  # 现场服务器 25
  # pnpm build:prod && zip -q -r business-25.zip ./dist && open .
}

if test "$identifiers" == '' || test "$identifiers" == '82'; then
  if test "$identifiers" == ''; then
    echo "\033[33m未输入，默认使用测试环境：82\033[0m"
  fi

  identifiers='82'
  funcBuild
elif test $identifiers == '123'; then
  identifiers='123'
  suffix=''
  funcBuild
elif test $identifiers == '25'; then
  identifiers='25'
  suffix=':prod'
  funcBuild
elif test $identifiers == 'noIP'; then
  identifiers='noIP'
  suffix=':noIP'
  funcBuild
fi

```