# Charger Protector Miyabi Core

Universal Battery Charge Protection Engine untuk Android (Magisk Module) yang dirancang agar hemat daya dan performa tinggi tanpa menyebabkan lag pada sistem.

## Fitur Utama

- **Lightweight Daemon**: Menggunakan shell builtins (`read -r`) untuk memantau kapasitas baterai tanpa memicu spawn process eksternal (`cat`) terus menerus.
- **Smart State Writer**: Hanya menulis ke file sysfs jika status pengisian daya berubah, menjaga kestabilan kernel dan meminimalkan logcat spam.
- **Hysteresis Protection**: Otomatis menghentikan pengisian daya saat mencapai batas atas (default: 90%) dan melanjutkan pengisian setelah turun ke batas bawah (default: 70%).
- **Interactive CLI Dashboard**: Tampilan visual dashboard premium langsung dari Terminal Android (Termux/Terminal Emulator).
- **Manual Control Override**: Memungkinkan pengguna memaksa charging aktif/nonaktif secara manual (seperti fitur Scene 5).
- **JSON Status API**: Output JSON satu baris yang siap di-parse oleh aplikasi monitoring buatan Anda sendiri.

---

## Cara Install

1. Pilih semua file dalam folder project ini, lalu kompres/zip menjadi sebuah file zip (misalnya `miyabi-charger.zip`).
2. Kirim zip tersebut ke perangkat Android Anda.
3. Buka aplikasi **Magisk**, masuk ke menu **Modules**, ketuk **Install from storage**, lalu pilih file zip tersebut.
4. Reboot/restart HP Anda.

---

## Cara Menggunakan via Terminal Android

Buka aplikasi terminal pilihan Anda (Termux atau Terminal Emulator), ketik `su` untuk meminta hak akses root, lalu jalankan perintah `miyabi-charger`.

### 1. Dashboard Interaktif (Menu Visual)
Cukup ketik perintah berikut tanpa argumen tambahan:
```bash
su -c miyabi-charger
```
Anda akan disuguhkan menu interaktif untuk memantau kondisi baterai, mengaktifkan/menonaktifkan engine, mengatur persentase batas pengisian, melakukan uji coba toggle node charging, dan melihat log engine.

### 2. Mengatur Custom Stop & Resume Limit (CLI Command)
Anda bisa mengatur batas pengisian secara langsung lewat baris perintah:

- **Mengatur batas stop charging** (misalnya di 85%):
  ```bash
  su -c miyabi-charger set-stop 85
  ```
- **Mengatur batas resume charging** (misalnya di 65%):
  ```bash
  su -c miyabi-charger set-resume 65
  ```
*Catatan: Nilai Stop harus lebih besar dari nilai Resume.*

### 3. Kontrol Manual (Manual Override)
Jika ingin mengabaikan mode otomatis dan mengontrol pengisian daya secara paksa:
- **Paksa stop charging (tidak mengisi daya)**:
  ```bash
  su -c miyabi-charger force-stop
  ```
- **Paksa charging aktif kembali**:
  ```bash
  su -c miyabi-charger force-resume
  ```
- **Kembali ke mode otomatis (berdasarkan batas persentase)**:
  ```bash
  su -c miyabi-charger auto
  ```

### 4. Mengaktifkan / Menonaktifkan Proteksi
- **Mengaktifkan sistem proteksi**:
  ```bash
  su -c miyabi-charger enable
  ```
- **Menonaktifkan sistem proteksi** (HP akan dicharge seperti biasa sampai 100%):
  ```bash
  su -c miyabi-charger disable
  ```

---

## Integrasi dengan Aplikasi Monitoring (JSON API)

Jika Anda ingin membuat aplikasi monitor (GUI) Android untuk menghubungkannya ke modul ini, aplikasi Anda cukup mengeksekusi perintah berikut untuk mendapatkan data baterai dan status modul secara lengkap:

```bash
su -c miyabi-charger status-json
```

**Contoh Response JSON:**
```json
{
  "battery_level": 71,
  "battery_status": "Discharging",
  "temperature_c": 35.8,
  "voltage_v": 4.055,
  "current_ma": -351,
  "cycle_count": 421,
  "node_path": "/sys/class/power_supply/battery/charging_enabled",
  "node_value": 1,
  "charging_state": "Enabled",
  "protection_enabled": 1,
  "stop_level": 90,
  "resume_level": 70,
  "manual_control": 0,
  "manual_state": 1,
  "daemon_running": 1,
  "plugged_in": 1
}
```
Aplikasi Anda tinggal melakukan parsing pada string JSON satu baris di atas untuk memperbarui tampilan UI aplikasi monitor Anda secara real-time.