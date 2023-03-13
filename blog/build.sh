# 打包
hugo --baseUrl="/"
rm -rf ../nginx/html/*
# 移动文件到 nginx/html 下
mv -f public/* ../nginx/html/