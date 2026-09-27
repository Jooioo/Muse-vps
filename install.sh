#!/bin/bash
# 🛰️ VPS 探针一键安装脚本（对标哪吒 install.sh）
# 用法: sudo bash install.sh
# 功能: 交互式安装面板端或探针端，自动生成密钥/密码并配置 systemd 常驻
set -u

if [ "$(id -u)" -ne 0 ]; then
  echo "请用 root 运行: sudo bash install.sh"
  exit 1
fi

INSTALL_DIR="/opt/vps-probe"
TMPD="$(mktemp -d)"
trap 'rm -rf "$TMPD"' EXIT

echo "[1/4] 解包安装文件…"
echo "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" | base64 -d | tar -xz -C "$TMPD"
[ -f "$TMPD/server.py" ] && [ -f "$TMPD/agent.py" ] || { echo "解包失败，请重新下载 install.sh"; exit 1; }

rand_hex() { openssl rand -hex "$1" 2>/dev/null || head -c "$1" /dev/urandom | od -An -tx1 | tr -d ' \n'; }
local_ip() { hostname -I 2>/dev/null | awk '{print $1}'; }

install_panel() {
  echo ""
  echo "—— 安装面板端 ——"
  read -p "面板端口 [8000]: " PORT; PORT="${PORT:-8000}"
  read -p "面板登录密码（回车自动生成）: " PP
  [ -z "${PP:-}" ] && PP="$(rand_hex 12)"
  TOKEN="$(rand_hex 16)"

  echo "[2/4] 写入文件到 $INSTALL_DIR…"
  mkdir -p "$INSTALL_DIR"
  cp "$TMPD/server.py" "$INSTALL_DIR/"

  echo "[3/4] 配置 systemd 服务…"
  cat > /etc/systemd/system/vps-probe-server.service <<EOF
[Unit]
Description=VPS Probe Dashboard
After=network.target

[Service]
Type=simple
Environment=TOKEN=$TOKEN
Environment=PORT=$PORT
Environment=PANEL_USER=admin
Environment=PANEL_PASSWORD=$PP
# 可选：服务监控（名称|类型tcp/http/https|目标，分号分隔）
#Environment=SERVICES=博客|http|https://blog.example.com;网关|tcp|1.2.3.4:22
# 可选：告警 Webhook（POST JSON {"text": "消息"}）
#Environment=ALERT_WEBHOOK=https://example.com/webhook
ExecStart=/usr/bin/python3 $INSTALL_DIR/server.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
  systemctl daemon-reload
  systemctl enable --now vps-probe-server >/dev/null 2>&1
  sleep 2

  if systemctl is-active --quiet vps-probe-server; then
    IP="$(local_ip)"; [ -z "$IP" ] && IP="<本机IP>"
    echo "[4/4] 安装成功！"
    echo "=============================="
    echo "面板地址: http://$IP:$PORT"
    echo "用户名:   admin"
    echo "密码:     $PP"
    echo "通信密钥: $TOKEN"
    echo "=============================="
    echo "请在防火墙/安全组放行 $PORT 端口。"
    echo "探针端安装：在被监控的机器上同样运行本脚本，选 2，"
    echo "填入上面的面板地址和通信密钥即可。"
  else
    echo "服务启动失败，查看日志: journalctl -u vps-probe-server -n 50"
    exit 1
  fi
}

install_agent() {
  echo ""
  echo "—— 安装探针端 ——"
  read -p "面板地址（如 http://1.2.3.4:8000）: " URL
  [ -z "${URL:-}" ] && { echo "面板地址不能为空"; exit 1; }
  read -p "通信密钥 TOKEN: " TOKEN
  [ -z "${TOKEN:-}" ] && { echo "TOKEN 不能为空"; exit 1; }
  read -p "本机显示名 [$(hostname)]: " NAME; NAME="${NAME:-$(hostname)}"
  read -p "分组名（可空）: " GROUP

  echo "[2/4] 写入文件到 $INSTALL_DIR…"
  mkdir -p "$INSTALL_DIR"
  cp "$TMPD/agent.py" "$INSTALL_DIR/"

  echo "[3/4] 配置 systemd 服务…"
  cat > /etc/systemd/system/vps-probe-agent.service <<EOF
[Unit]
Description=VPS Probe Agent
After=network.target

[Service]
Type=simple
Environment=TOKEN=$TOKEN
Environment=DASHBOARD_URL=$URL
Environment=NAME=$NAME
Environment=GROUP=${GROUP:-}
Environment=INTERVAL=10
ExecStart=/usr/bin/python3 $INSTALL_DIR/agent.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
  systemctl daemon-reload
  systemctl enable --now vps-probe-agent >/dev/null 2>&1
  sleep 2

  if systemctl is-active --quiet vps-probe-agent; then
    echo "[4/4] 安装成功！探针正在上报至 $URL，稍后在面板查看「$NAME」。"
  else
    echo "服务启动失败，查看日志: journalctl -u vps-probe-agent -n 50"
    exit 1
  fi
}

uninstall_probe() {
  echo ""
  echo "—— 卸载 ——"
  for svc in vps-probe-server vps-probe-agent; do
    if [ -f "/etc/systemd/system/$svc.service" ]; then
      echo "停止并移除服务: $svc"
      systemctl stop "$svc" >/dev/null 2>&1
      systemctl disable "$svc" >/dev/null 2>&1
      rm -f "/etc/systemd/system/$svc.service"
    fi
  done
  systemctl daemon-reload 2>/dev/null
  read -p "是否删除安装目录 $INSTALL_DIR？[y/N]: " DEL
  if [[ "${DEL:-}" =~ ^[Yy]$ ]]; then
    rm -rf "$INSTALL_DIR"
    echo "已删除 $INSTALL_DIR"
  else
    echo "保留 $INSTALL_DIR（可手动删除）"
  fi
  echo "卸载完成"
}

echo "=============================="
echo "   🛰️ VPS 探针一键安装"
echo "=============================="
echo "1) 安装面板端 (Dashboard)"
echo "2) 安装探针端 (Agent)"
echo "3) 卸载"
read -p "请选择 [1/2/3]: " CHOICE

case "${CHOICE:-}" in
  1) install_panel ;;
  2) install_agent ;;
  3) uninstall_probe ;;
  *) echo "无效选择，退出"; exit 1 ;;
esac
