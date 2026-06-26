#!/system/bin/sh

MODDIR=${0%/*}

chmod 755 $MODDIR/system/bin/miyabi-charger

nohup $MODDIR/system/bin/miyabi-charger daemon >/dev/null 2>&1 &