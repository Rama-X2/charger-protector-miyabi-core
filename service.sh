#!/system/bin/sh

CONFIG_FILE="/data/adb/chargeprotector/config.conf"
LOGFILE="/data/adb/chargeprotector/log.txt"

sleep 20

if [ -f "$CONFIG_FILE" ]; then
    . "$CONFIG_FILE"
else
    STOP_LEVEL=90
    RESUME_LEVEL=70
    CHECK_INTERVAL=30
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOGFILE"
}

find_charge_node() {

for NODE in \
"/sys/class/power_supply/battery/input_suspend" \
"/sys/class/power_supply/battery/charging_enabled" \
"/sys/class/power_supply/battery/battery_charging_enabled" \
"/sys/class/power_supply/battery/charge_disable" \
"/sys/class/qcom-battery/input_suspend"
do

    if [ -e "$NODE" ]; then
        echo "$NODE"
        return
    fi

done

find /sys -type f 2>/dev/null | grep -E \
"input_suspend|charging_enabled|charge_disable|battery_charging_enabled" \
| head -n 1

}

CHARGE_NODE=$(find_charge_node)

if [ -z "$CHARGE_NODE" ]; then
    log "No compatible charging node found"
    exit 1
fi

log "Using node: $CHARGE_NODE"

disable_charge() {

    case "$(basename "$CHARGE_NODE")" in

        input_suspend)
            echo 1 > "$CHARGE_NODE"
        ;;

        charging_enabled)
            echo 0 > "$CHARGE_NODE"
        ;;

        battery_charging_enabled)
            echo 0 > "$CHARGE_NODE"
        ;;

        charge_disable)
            echo 1 > "$CHARGE_NODE"
        ;;

    esac

}

enable_charge() {

    case "$(basename "$CHARGE_NODE")" in

        input_suspend)
            echo 0 > "$CHARGE_NODE"
        ;;

        charging_enabled)
            echo 1 > "$CHARGE_NODE"
        ;;

        battery_charging_enabled)
            echo 1 > "$CHARGE_NODE"
        ;;

        charge_disable)
            echo 0 > "$CHARGE_NODE"
        ;;

    esac

}

STATE="UNKNOWN"

while true
do

BATTERY=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null)

if [ -z "$BATTERY" ]; then
    sleep "$CHECK_INTERVAL"
    continue
fi

if [ "$BATTERY" -ge "$STOP_LEVEL" ]; then

    if [ "$STATE" != "STOPPED" ]; then

        disable_charge

        log "Charging disabled at ${BATTERY}%"

        STATE="STOPPED"

    fi

elif [ "$BATTERY" -le "$RESUME_LEVEL" ]; then

    if [ "$STATE" != "CHARGING" ]; then

        enable_charge

        log "Charging enabled at ${BATTERY}%"

        STATE="CHARGING"

    fi

fi

sleep "$CHECK_INTERVAL"

done