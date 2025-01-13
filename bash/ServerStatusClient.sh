#!/bin/bash

# 检查是否以 root 用户运行
if [[ $EUID -ne 0 ]]; then
    echo "请以 root 用户运行此脚本。"
    exit 1
fi

# 提示用户输入 SERVER IP
read -p "请输入服务端 SERVER IP 地址: " SERVER_IP
if [[ -z "$SERVER_IP" ]]; then
    echo "SERVER IP 不能为空，请重新运行脚本并输入有效的 IP。"
    exit 1
fi

# 提示用户输入 USER 值
read -p "请输入客户端 USER 名称: " USER
if [[ -z "$USER" ]]; then
    echo "USER 不能为空，请重新运行脚本并输入有效的 USER。"
    exit 1
fi

# 提示用户输入 PASSWORD 值
read -p "请输入客户端 PASSWORD 值 (可选): " PASSWORD
if [[ -z "$PASSWORD" ]]; then
    PASSWORD=""
fi

# 定义安装路径
INSTALL_DIR="/opt/ServerStatus/client"
SERVICE_FILE="/etc/systemd/system/serverstatus-client.service"

# 创建目录并下载脚本
echo "创建目录并下载 client-linux.py..."
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR" || exit
wget --no-check-certificate -qO client-linux.py 'https://raw.githubusercontent.com/cppla/ServerStatus/master/clients/client-linux.py'
if [[ $? -ne 0 ]]; then
    echo "下载 client-linux.py 失败，请检查网络连接。"
    exit 1
fi

# 先停止服务
SERVER_NAME=$(basename "$SERVICE_FILE")
systemctl stop "$SERVER_NAME"
# 设置 Systemd 服务文件
echo "配置 Systemd 服务..."
cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Start or stop the ServerStatus client
After=network.target
Wants=network.target

[Service]
Type=simple
User=root
Group=root
WorkingDirectory=$INSTALL_DIR
ExecStart=/usr/bin/python3 $INSTALL_DIR/client-linux.py SERVER=$SERVER_IP USER=$USER $(if [ -n "$PASSWORD" ]; then echo "PASSWORD=$PASSWORD"; fi)
Restart=always
LimitNOFILE=512000

[Install]
WantedBy=multi-user.target
EOF

# 重新加载 Systemd 配置
echo "重新加载 Systemd 配置..."
systemctl daemon-reload

# 设置服务开机自启
echo "设置服务开机自启..."
systemctl enable serverstatus-client

# 启动服务
echo "启动服务..."
systemctl start serverstatus-client

# 检查服务状态
echo "服务状态如下："
systemctl status serverstatus-client --no-pager

echo "安装完成！服务已启动并配置为开机自启。"
