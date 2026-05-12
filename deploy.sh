#!/bin/bash

# 检查是否安装了 Docker
if ! [ -x "$(command -v docker)" ]; then
  echo '检测到未安装 Docker，正在安装...'
  curl -fsSL https://get.docker.com | bash
  systemctl enable --now docker
fi

# 获取用户输入
read -p "请输入你的 TUNNEL_TOKEN: " TOKEN
read -p "请输入你的 UUID [默认: c67e108d-b135-4acd-b0b4-33f2d18dff44]: " UUID
UUID=${UUID:-c67e108d-b135-4acd-b0b4-33f2d18dff44}
read -p "请输入你的 XPATH [默认: /GEdhhrQEkzaq]: " XPATH
XPATH=${XPATH:-/GEdhhrQEkzaq}

# 新增：询问或默认 IPv6 优先
# 默认 UseIPv6，这样没 6 的机器也能跑
DOMAIN_STRATEGY="UseIPv6"

IMAGE="ghcr.io/caojiaxia/xray-tunnel:main"

echo "正在清理环境..."
docker rm -f xray-tunnel 2>/dev/null

echo "正在拉取镜像..."
docker pull $IMAGE

echo "正在启动容器 (开启 Host 模式以提速)..."
# 注意：这里改用了 --network host，彻底解决 Docker Bridge 带来的隧道性能损耗
docker run -d \
  --name xray-tunnel \
  --restart always \
  --network host \
  -e TUNNEL_TOKEN=$TOKEN \
  -e UUID=$UUID \
  -e XPATH=$XPATH \
  -e DOMAIN_STRATEGY=$DOMAIN_STRATEGY \
  $IMAGEE
