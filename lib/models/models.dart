import '../constants.dart';

class Advice {
  final String id;
  final String dalil;
  final String isi;
  final String? urlSlide;

  Advice({
    required this.id,
    required this.dalil,
    required this.isi,
    this.urlSlide,
  });

  factory Advice.fromMap(Map<String, dynamic> map, String id) {
    return Advice(
      id: id,
      dalil: map['dalil'] ?? '',
      isi: map['isi'] ?? '',
      urlSlide: map['url_slide']?.toString(),
    );
  }
}

class MosqueInfo {
  final String id;
  final String title;
  final String content;
  final String? urlSlide;

  MosqueInfo({
    required this.id,
    required this.title,
    required this.content,
    this.urlSlide,
  });

  factory MosqueInfo.fromMap(Map<String, dynamic> map, String id) {
    return MosqueInfo(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      urlSlide: map['url_slide']?.toString(),
    );
  }
}



class IqomahConfig {
  final int waktuIqomah; // minutes before prayer starts
  final int waktuShalat; // minutes to show prayer screen

  const IqomahConfig({required this.waktuIqomah, required this.waktuShalat});

  static num? _parseNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }

  factory IqomahConfig.fromMap(Map<String, dynamic> map) {
    return IqomahConfig(
      waktuIqomah: _parseNum(map['waktu_iqomah'])?.toInt() ?? 10,
      waktuShalat: _parseNum(map['waktu_shalat'])?.toInt() ?? 15,
    );
  }

  static IqomahConfig defaultConfig({int? iqomah, int? shalat}) =>
      IqomahConfig(
        waktuIqomah: iqomah ?? AppConstants.iqomahSubuh,
        waktuShalat: shalat ?? AppConstants.durasiShalat,
      );
}

class AppConfig {
  final String mosqueName;
  final String mosqueLocation;
  final String backgroundUrl;
  final int slideIntervalMinutes;
  final double latitude;
  final double longitude;
  final IqomahConfig subuhConfig;
  final IqomahConfig dzuhurConfig;
  final IqomahConfig asharConfig;
  final IqomahConfig maghribConfig;
  final IqomahConfig isyaConfig;

  AppConfig({
    required this.mosqueName,
    required this.mosqueLocation,
    required this.backgroundUrl,
    required this.slideIntervalMinutes,
    required this.latitude,
    required this.longitude,
    required this.subuhConfig,
    required this.dzuhurConfig,
    required this.asharConfig,
    required this.maghribConfig,
    required this.isyaConfig,
  });

  factory AppConfig.defaultConfig() {
    return AppConfig(
      mosqueName: AppConstants.defaultMosqueName,
      mosqueLocation: AppConstants.defaultMosqueLocation,
      backgroundUrl: AppConstants.defaultBackgroundPath,
      slideIntervalMinutes: AppConstants.defaultSlideIntervalMinutes,
      latitude: AppConstants.defaultLatitude,
      longitude: AppConstants.defaultLongitude,
      subuhConfig: IqomahConfig.defaultConfig(
          iqomah: AppConstants.iqomahSubuh, shalat: AppConstants.durasiShalat),
      dzuhurConfig: IqomahConfig.defaultConfig(
          iqomah: AppConstants.iqomahDzuhur, shalat: AppConstants.durasiShalat),
      asharConfig: IqomahConfig.defaultConfig(
          iqomah: AppConstants.iqomahAshar, shalat: AppConstants.durasiShalat),
      maghribConfig: IqomahConfig.defaultConfig(
          iqomah: AppConstants.iqomahMaghrib, shalat: AppConstants.durasiShalat),
      isyaConfig: IqomahConfig.defaultConfig(
          iqomah: AppConstants.iqomahIsya, shalat: AppConstants.durasiShalat),
    );
  }

  static num? _parseNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }

  factory AppConfig.fromMap(Map<String, dynamic> map) {
    final iqomah = map['iqomah'] as Map<String, dynamic>? ?? {};
    String bgUrl = map['background_url']?.toString() ?? '';
    if (bgUrl.isEmpty || bgUrl == '-') {
      bgUrl = AppConstants.defaultBackgroundPath;
    }

    return AppConfig(
      mosqueName: map['nama'] ?? AppConstants.defaultMosqueName,
      mosqueLocation: map['lokasi'] ?? AppConstants.defaultMosqueLocation,
      backgroundUrl: bgUrl,
      slideIntervalMinutes:
          _parseNum(map['durasi_slide'])?.toInt() ?? AppConstants.defaultSlideIntervalMinutes,
      latitude: _parseNum(map['latitude'])?.toDouble() ?? AppConstants.defaultLatitude,
      longitude: _parseNum(map['longitude'])?.toDouble() ?? AppConstants.defaultLongitude,
      subuhConfig: IqomahConfig.fromMap(
          iqomah['subuh'] as Map<String, dynamic>? ?? {}),
      dzuhurConfig: IqomahConfig.fromMap(
          iqomah['dzuhur'] as Map<String, dynamic>? ?? {}),
      asharConfig: IqomahConfig.fromMap(
          iqomah['ashar'] as Map<String, dynamic>? ?? {}),
      maghribConfig: IqomahConfig.fromMap(
          iqomah['maghrib'] as Map<String, dynamic>? ?? {}),
      isyaConfig: IqomahConfig.fromMap(
          iqomah['isya'] as Map<String, dynamic>? ?? {}),
    );
  }
}
