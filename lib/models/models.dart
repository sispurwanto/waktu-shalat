class Advice {
  final String id;
  final String text;

  Advice({required this.id, required this.text});
}

class MosqueInfo {
  final String id;
  final String title;
  final String content;

  MosqueInfo({required this.id, required this.title, required this.content});
}

class AppConfig {
  final String mosqueName;
  final String mosqueLocation;
  final int iqomahDurationMinutes;
  final int prayerDurationMinutes;
  final int slideIntervalMinutes;
  final double latitude;
  final double longitude;

  AppConfig({
    required this.mosqueName,
    required this.mosqueLocation,
    required this.iqomahDurationMinutes,
    required this.prayerDurationMinutes,
    required this.slideIntervalMinutes,
    required this.latitude,
    required this.longitude,
  });

  factory AppConfig.defaultConfig() {
    return AppConfig(
      mosqueName: 'Mushola Al Muhajirin Yiami',
      mosqueLocation: 'Cileungsi - Bogor',
      iqomahDurationMinutes: 10,
      prayerDurationMinutes: 15,
      slideIntervalMinutes: 5,
      latitude: -6.4023, // Cileungsi
      longitude: 106.9705, // Cileungsi
    );
  }
}
