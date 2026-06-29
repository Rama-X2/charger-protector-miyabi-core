# Charger Protector Miyabi Core

Universal Battery Charge Protection Engine for Android (Magisk Module), designed to prevent battery degradation through intelligent charge capping, offering premium performance, low overhead, and no system lag.

## Key Features

- **Lightweight Daemon**: Written in pure POSIX-compliant shell script with low memory footprint and zero CPU overhead.
- **Qualcomm Snapdragon Loop Prevention**: Uses hardware-level VBUS voltage and USB present status sensors to prevent infinite disconnect/connect loops when charging is cut off.
- **Strict Replug Blocking**: Once charge limit is reached, charging remains blocked even if the charger is unplugged and plugged back in, unless the battery level drops below the resume threshold.
- **Instant Configuration Application**: Uses Unix signals (`SIGUSR1`) to immediately interrupt daemon sleep cycles and apply new thresholds in milliseconds when updated via terminal or app.
- **Smart Sleep Engine**: Uses dynamic polling frequencies (15s when plugged in, 45s when unplugged) to conserve device resources.
- **Interactive CLI Dashboard**: Beautifully formatted terminal dashboard with battery diagnostics (temperature, voltage, current) and control settings.
- **JSON API Support**: Out-of-the-box JSON status formatting for seamless integration with custom Android companion/monitoring applications.

---

## Installation

1. Package the module files into a standard `.zip` archive (do not include development files like `.git`, `README.md`, `changelog.txt`, or `update.json`).
2. Transfer the `.zip` archive to your Android device.
3. Flash the package via **Magisk App** or **KernelSU**.
4. Reboot your device to start the daemon service.

---

## CLI Usage

Gain root shell access and run `miyabi-charger` with the following parameters:

```bash
# Open the interactive visual dashboard
su -c miyabi-charger

# Get current status in raw JSON format (ideal for companion apps)
su -c miyabi-charger status-json

# Set charging stop threshold (e.g. 90%)
su -c miyabi-charger set-stop 90

# Set charging resume threshold (e.g. 70%)
su -c miyabi-charger set-resume 70

# Enable automatic charge protection engine
su -c miyabi-charger enable

# Disable automatic charge protection engine
su -c miyabi-charger disable

# Manually force charge (ignores limit temporarily)
su -c miyabi-charger force-charge

# Manually force stop charging (keeps charging suspended)
su -c miyabi-charger force-stop

# Revert manual override back to automatic protection mode
su -c miyabi-charger auto
```

---

## JSON API Output Sample

Calling `su -c miyabi-charger status-json` returns a lightweight JSON payload:

```json
{
  "battery_level": 85,
  "battery_status": "Discharging",
  "temperature_c": 34,
  "voltage_v": 4.15,
  "current_ma": -240,
  "cycle_count": 120,
  "node_path": "/sys/class/power_supply/battery/input_suspend",
  "node_value": 1,
  "charging_state": "Disabled",
  "protection_enabled": 1,
  "stop_level": 90,
  "resume_level": 70,
  "manual_control": 0,
  "manual_state": 0,
  "daemon_running": 1,
  "plugged_in": 1,
  "hide_icon": 0
}
```

---

## File Structure

- [system/bin/miyabi-charger](file:///C:/Ghost%20Toolbox/Video/charger-protector-miyabi-core/system/bin/miyabi-charger) : Main CLI and background daemon executable.
- [config/default.conf](file:///C:/Ghost%20Toolbox/Video/charger-protector-miyabi-core/config/default.conf) : Default configuration template.
- [service.sh](file:///C:/Ghost%20Toolbox/Video/charger-protector-miyabi-core/service.sh) : Starts the background daemon during boot.
- [post-fs-data.sh](file:///C:/Ghost%20Toolbox/Video/charger-protector-miyabi-core/post-fs-data.sh) : Initializes directories and default configuration under `/data/adb/miyabi-core/charger/`.