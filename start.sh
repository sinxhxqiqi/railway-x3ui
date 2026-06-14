#!/bin/bash
set -e

echo "🚀 Starting..."

# Start SSH
service ssh start

# Create config for X-UI if not exists
if [ ! -f /etc/x-ui/config.json ]; then
    mkdir -p /etc/x-ui
    cat > /etc/x-ui/config.json << 'EOF'
{
    "webPort": 54321,
    "webBasePath": "/",
    "webCertFile": "",
    "webKeyFile": "",
    "webListen": "0.0.0.0",
    "logLevel": "info",
    "xrayConfig": "/usr/local/x-ui/bin/config.json",
    "database": "/etc/x-ui/x-ui.db"
}
EOF
fi

# Start X-UI
nohup /usr/local/x-ui/x-ui > /var/log/x-ui.log 2>&1 &

# Start wetty
exec wetty \
  --port ${PORT:-3000} \
  --host 0.0.0.0 \
  --ssh-host localhost \
  --ssh-port 22 \
  --ssh-user root \
  --title "Arvin VPS" \
  --base /
