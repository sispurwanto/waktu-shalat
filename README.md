# jadwal_shalat

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

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
```bash
flutter run --dart-define=MASJID_ID={MASJID_ID}
flutter build apk --target-platform android-arm64 --dart-define=MASJID_ID={MASJID_ID}

flutter build appbundle --target-platform android-arm64 --dart-define=MASJID_ID={MASJID_ID}
flutter build appbundle --release --target-platform android-arm64 --dart-define=MASJID_ID={MASJID_ID}
```

