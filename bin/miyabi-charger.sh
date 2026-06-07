#!/system/bin/sh

BASE=/data/adb/miyabi-core/charger

CONFIG=$BASE/config.conf
LOG=$BASE/log.txt
CACHE=$BASE/node.cache

load_config() {
    . $CONFIG
}

log() {
    echo "$(date) $1" >> $LOG
}

find_node() {

for node in \
/sys/class/power_supply/battery/input_suspend \
/sys/class/power_supply/battery/charging_enabled \
/sys/class/power_supply/battery/battery_charging_enabled \
/sys/class/power_supply/battery/charge_disable
do

    [ -e "$node" ] && {
        echo "$node"
        return
    }

done

}

disable_charge() {

NODE=$(cat $CACHE)

case $(basename "$NODE") in

input_suspend)
echo 1 > "$NODE"
;;

charging_enabled)
echo 0 > "$NODE"
;;

battery_charging_enabled)
echo 0 > "$NODE"
;;

charge_disable)
echo 1 > "$NODE"
;;

esac

}

enable_charge() {

NODE=$(cat $CACHE)

case $(basename "$NODE") in

input_suspend)
echo 0 > "$NODE"
;;

charging_enabled)
echo 1 > "$NODE"
;;

battery_charging_enabled)
echo 1 > "$NODE"
;;

charge_disable)
echo 0 > "$NODE"
;;

esac

}

status() {

CAP=$(cat /sys/class/power_supply/battery/capacity)

echo "Battery=$CAP"

}

daemon() {

load_config

if [ ! -f "$CACHE" ]; then
find_node > "$CACHE"
fi

while true
do

CAP=$(cat /sys/class/power_supply/battery/capacity)

if [ "$CAP" -ge "$STOP_LEVEL" ]; then
disable_charge
fi

if [ "$CAP" -le "$RESUME_LEVEL" ]; then
enable_charge
fi

sleep 60

done

}

case "$1" in

daemon)
daemon
;;

enable)
enable_charge
;;

disable)
disable_charge
;;

status)
status
;;

esac