#!/system/bin/sh

dumpsys battery reset -f >/dev/null 2>&1 || dumpsys battery reset >/dev/null 2>&1
rm -rf /data/adb/miyabi-core/charger
