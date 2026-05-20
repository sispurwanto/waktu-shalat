# jadwal_shalat
Spesifikasi APP:
- menggunakan library jadwal shalat dari adhan (library standar industri untuk Flutter).
- bisa Online dan Offline Mode
- jika online maka bisa update data lewat firebase
- jika offline / tidak ada koneksi internet maka bisa menggunakan data yang ada di local di setting di [jadwal_shalat/lib/constants.dart]
- tampilan UI bisa di setting lewat firebase
- di main_view ada 3 mode :
  - DefaultView
  - IqomahTimer
  - PrayerView

### run dan build
#### run
Menjalankan aplikasi langsung ke emulator/device.
Biasanya untuk development/testing.
```bash
flutter run --dart-define=MASJID_ID={MASJID_ID}
```

### Build Android APK
File .apk dipakai dipakai di install ke perangkat via: file transfer, google drive, dropbox, dll. dan dipakai untuk debugging.  
```bash
flutter build apk --target-platform android-arm64 --dart-define=MASJID_ID={MASJID_ID}
```
output nya akan ada di : build/app/outputs/flutter-apk/app-release.apk
Penjelasan tambahan :
--target-platform android-arm64
- APK hanya dibuat untuk device ARM64.
- keuntungan : ukuran APK lebih kecil, lebih optimal.
- tetapi : tidak support emulator x86 lama.

### Build Android App Bundle (.aab)
File .aab dipakai upload ke: Google Play
```bash
flutter build appbundle --target-platform android-arm64 --dart-define=MASJID_ID={MASJID_ID}
```

```bash
flutter build appbundle --release --target-platform android-arm64 --dart-define=MASJID_ID={MASJID_ID}
```
ini hampir sama dengan sebelumnya, tapi eksplisit memakai mode release.
--release
Artinya:
- optimasi aktif
- debug dimatikan
- performa lebih cepat
- ukuran lebih kecil

### notes: serba serbi flutter
- Best Practice
Biasanya dipakai untuk:
- API_URL
- APP_NAME
- CLIENT_ID
- ENV
- FEATURE_FLAG

Contoh: pemakaian --dart-define
```bash
flutter run --dart-define=ENV=dev --dart-define=API_URL=https://dev-api.com
```

### Perbedaan APK vs AAB
| | APK | AAB |
|----------|-----|-----|
| Langsung install | ✓ | ✗ |
| upload ke Play Store | ✗ | ✓ |
| ukuran lebih besar | ✓ | ✗ |
| universal package | ✓ | ✗ |
| Play Store generate otomatis | ✗ | ✓ |
| cocok testing | ✓ | ✗ |
| cocok production | ✗ | ✓ |

### Ringkasan Sederhana
Command | Fungsi
------- | -----
flutter run | jalankan app
build apk | buat file APK
build appbundle | buat file AAB
--dart-define | kirim variable config
--target-platform android-arm64 | hanya untuk ARM64
--release | mode production


