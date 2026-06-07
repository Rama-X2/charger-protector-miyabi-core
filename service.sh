#!/system/bin/sh

MODDIR=${0%/*}

chmod 755 $MODDIR/bin/miyabi-charger

nohup $MODDIR/bin/miyabi-charger daemon >/dev/null 2>&1 &