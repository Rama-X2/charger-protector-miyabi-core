#!/system/bin/sh

MODDIR=${0%/*}

CONFIG_DIR="/data/adb/chargeprotector"
CONFIG_FILE="$CONFIG_DIR/config.conf"

mkdir -p "$CONFIG_DIR"

if [ ! -f "$CONFIG_FILE" ]; then
cat > "$CONFIG_FILE" <<EOF
STOP_LEVEL=90
RESUME_LEVEL=70
CHECK_INTERVAL=30
EOF
fi

chmod 755 "$CONFIG_DIR"
chmod 644 "$CONFIG_FILE"