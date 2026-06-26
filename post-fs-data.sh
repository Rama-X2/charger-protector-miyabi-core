#!/system/bin/sh

BASE=/data/adb/miyabi-core/charger

mkdir -p $BASE

if [ ! -f $BASE/config.conf ]; then
cp $MODPATH/config/default.conf $BASE/config.conf
fi

chmod 644 $BASE/config.conf