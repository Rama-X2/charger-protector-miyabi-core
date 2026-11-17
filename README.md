# 🌸 Charger Protector Miyabi Core

Universal Battery Charge Protection Engine for Android (Magisk / KernelSU Module), designed to prevent battery degradation through intelligent charge capping, offering low overhead, accurate hardware verification, and zero system lag.

## Key Features

- **Lightweight Daemon**: Written in pure POSIX-compliant shell script with tiny memory footprint, boot-completion sync (`sys.boot_completed`), and single-instance PID locking.
- **Anti-Loop & Anti-Freeze Protection (v2.5.0+)**: Strictly filters external charger ports (`usb`, `ac`, `wireless`, `mtk_charger_type`) while ignoring internal BMS/main/fuel-gauge nodes, AND continuously synchronizes live battery level during `dumpsys` icon hiding so the status bar percentage never freezes while plugged in or after unplugging.
- **Smart Hardware Verification & Auto-Failover (v2.5.0+)**: Verifies real kernel `/sys/class/power_supply/battery/status` after cutting charging and automatically fails over across Qualcomm, MediaTek (Helio / Dimensity), and HyperOS/MIUI thermal overrides (`mi_thermald`) until a working hardware node is confirmed.
- **Strict Hysteresis & Replug Blocking**: Tracks charge pause state persistently so charging stays blocked even if the cable is unplugged and plugged back in—resuming only when capacity drops to or below the resume threshold.
- **Instant Configuration Application**: Uses Unix signals (`SIGUSR1`) to immediately interrupt daemon sleep cycles and apply new thresholds in milliseconds when updated via terminal or app.
- **Smart Sleep Engine**: Uses dynamic polling frequencies (`15s` when plugged in, `45s` when unplugged) to conserve device resources.
- **Interactive CLI Dashboard**: Terminal dashboard with live battery diagnostics (temperature, voltage, current), manual overrides, logs, and node toggle testing.
- **RFC 8259 JSON API Support**: Valid JSON status output (even on multi-word MediaTek nodes and unavailable sensors) for companion/monitoring applications.

---

## Installation

1. Download or package the module `.zip` archive (contains `config/`, `system/`, `customize.sh`, `module.prop`, `post-fs-data.sh`, `service.sh`, `uninstall.sh` — do not include repository files like `.git`, `README.md`, `changelog.txt`, or `update.json`).
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

# Manually force charge (ignores limit temporarily; alias: force-resume)
su -c miyabi-charger force-charge

# Manually force stop charging (keeps charging suspended)
su -c miyabi-charger force-stop

# Revert manual override back to automatic protection mode
su -c miyabi-charger auto
```

---

## Custom Charging Node

By default, the engine automatically detects and verifies the most compatible charge control node on your device (supporting Qualcomm `qcom-battery`/`battery`, MediaTek `mtk-master-charger`/`mtk_battery_cmd`, Xiaomi `night_charging`, `constant_charge_current_max` fallback, etc.). If you want to manually select or test a specific node:

1. Open the interactive dashboard: `su -c miyabi-charger`.
2. Select Option `[5] Diagnose / Select Charge Node`.
3. Choose one of the detected compatible nodes from the list, run `[T]` to test if Status changes out of `Charging` and current drops, or select option `[C] Custom Node Path Input` to enter an absolute path.
   - *Example Qualcomm path*: `/sys/class/power_supply/battery/input_suspend` or `/sys/class/qcom-battery/input_suspend`
   - *Example MediaTek path*: `/sys/class/power_supply/mtk-master-charger/charging_enabled` or `/proc/mtk_battery_cmd/current_cmd`

Alternatively, you can configure it manually by adding `NODE_PATH="/your/custom/node/path"` to `/data/adb/miyabi-core/charger/config.conf`.

---

## JSON API Output Sample

Calling `su -c miyabi-charger status-json` returns a lightweight JSON payload:

```json
{
  "battery_level": 85,
  "battery_status": "Discharging",
  "temperature_c": 34.2,
  "voltage_v": 4.150,
  "current_ma": -240,
  "cycle_count": 120,
  "node_path": "/sys/class/power_supply/battery/input_suspend",
  "node_value": 1,
  "charging_state": "Disabled",
  "protection_enabled": 1,
  "stop_level": 90,
  "resume_level": 70,
  "manual_control": 0,
  "manual_state": 1,
  "daemon_running": 1,
  "plugged_in": 1,
  "hide_icon": 1
}
```

---

## File Structure

- [`system/bin/miyabi-charger`](system/bin/miyabi-charger) : Main CLI and background daemon executable.
- [`config/default.conf`](config/default.conf) : Default configuration template.
- [`customize.sh`](customize.sh) : Magisk/KernelSU installer script.
- [`service.sh`](service.sh) : Starts the background daemon during late_start service boot.
- [`post-fs-data.sh`](post-fs-data.sh) : Initializes directories, cleans stale runtime flags, and creates default configuration under `/data/adb/miyabi-core/charger/`.
- [`uninstall.sh`](uninstall.sh) : Restores BatteryService state and removes module data directory on uninstall.
