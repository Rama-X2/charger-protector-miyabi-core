#!/system/bin/sh

MODDIR=${0%/*}
BASE=/data/adb/miyabi-core/charger

mkdir -p "$BASE"
rm -f "$BASE/node.cache" "$BASE/node.bad" "$BASE/mock.state" "$BASE/paused.state" "$BASE/orig_current.state" "$BASE/daemon.pid"

if [ ! -f "$BASE/config.conf" ]; then
    cp "$MODDIR/config/default.conf" "$BASE/config.conf"
fi

chmod 644 "$BASE/config.conf"
