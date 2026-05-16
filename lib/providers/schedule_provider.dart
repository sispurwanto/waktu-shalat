import 'dart:async';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hijri/hijri_calendar.dart';

import 'data_provider.dart';
import '../models/models.dart';

enum AppMode { defaultView, iqomahTimer, prayerTime }

class ScheduleProvider with ChangeNotifier {
  final DataProvider dataProvider;

  Timer? _ticker;
  DateTime _currentTime = DateTime.now();

  AppMode _currentMode = AppMode.defaultView;

  PrayerTimes? _prayerTimes;
  PrayerTimes? _tomorrowPrayerTimes;
  Prayer? _nextPrayer;
  String? _currentPrayerName;

  int _iqomahSecondsRemaining = 0;
  IqomahConfig? _currentIqomahConfig;
  DateTime? _prayerStateEndTime;

  AudioPlayer? _audioPlayer;

  ScheduleProvider(this.dataProvider) {
    try {
      _audioPlayer = AudioPlayer();
    } catch (e) {
      debugPrint('[ScheduleProvider] AudioPlayer init error: $e');
    }
    _initPrayerTimes();
    _startTicker();
  }

  // Update logic when DataProvider changes (from ProxyProvider)
  void updateFromDataProvider(DataProvider newData) {
    // If coordinates changed, re-init prayer times
    if (newData.config.latitude != dataProvider.config.latitude ||
        newData.config.longitude != dataProvider.config.longitude) {
      debugPrint('[ScheduleProvider] Location updated from Firebase, re-initializing...');
      _initPrayerTimes();
    }
    notifyListeners();
  }

  AppMode get currentMode => _currentMode;
  DateTime get currentTime => _currentTime;
  PrayerTimes? get prayerTimes => _prayerTimes;
  Prayer? get nextPrayer => _nextPrayer;

  DateTime? get nextPrayerTime {
    if (_prayerTimes == null) return null;

    if (_prayerTimes!.nextPrayer() == Prayer.none) {
      if (_tomorrowPrayerTimes != null) {
        return _tomorrowPrayerTimes!.fajr;
      }
    } else {
      if (_nextPrayer != null && _nextPrayer != Prayer.none) {
        return _prayerTimes!.timeForPrayer(_nextPrayer!);
      }
    }
    return null;
  }

  String? get currentPrayerName => _currentPrayerName;
  int get iqomahSecondsRemaining => _iqomahSecondsRemaining;

  String get formattedCurrentTime =>
      DateFormat('HH:mm:ss').format(_currentTime);
  String get formattedCurrentDate =>
      DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(_currentTime);

  String get formattedHijriDate {
    var today = HijriCalendar.fromDate(_currentTime);
    const months = [
      '',
      'Muharram',
      'Safar',
      'Rabi\'ul Awal',
      'Rabi\'ul Akhir',
      'Jumadil Awal',
      'Jumadil Akhir',
      'Rajab',
      'Sya\'ban',
      'Ramadhan',
      'Syawal',
      'Dzulqa\'dah',
      'Dzulhijjah',
    ];
    return '${today.hDay} ${months[today.hMonth]} ${today.hYear} H';
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _audioPlayer?.dispose();
    super.dispose();
  }

  void _initPrayerTimes() {
    final config = dataProvider.config;
    final coordinates = Coordinates(config.latitude, config.longitude);

    // Using Kemenag parameters (similar to Egyptian but with 20 deg fajr, 18 deg isha, or we can use singapore which is 20, 18)
    // Actually, Adhan package has Singapore calculation method which is 20 degrees for Fajr and 18 for Isha, very close to Kemenag.
    // Or we can define custom parameters.
    final params = CalculationMethod.singapore.getParameters();
    params.madhab = Madhab.shafi;

    _prayerTimes = PrayerTimes.today(coordinates, params);
    
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowDate = DateComponents(tomorrow.year, tomorrow.month, tomorrow.day);
    _tomorrowPrayerTimes = PrayerTimes(coordinates, tomorrowDate, params);

    _updateNextPrayer();
  }

  void _updateNextPrayer() {
    if (_prayerTimes != null) {
      _nextPrayer = _prayerTimes!.nextPrayer();
      if (_nextPrayer == Prayer.none) {
        _nextPrayer = Prayer.fajr;
      }
    }
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();

      // If day changes, re-init prayer times
      if (now.day != _currentTime.day) {
        _initPrayerTimes();
      }

      _currentTime = now;

      _checkStateTransitions();
      notifyListeners();
    });
  }

  void _checkStateTransitions() {
    if (_currentMode == AppMode.defaultView) {
      final nextTime = nextPrayerTime;
      if (nextTime != null && _nextPrayer != null) {
        if (_currentTime.isAfter(nextTime) ||
            _currentTime.isAtSameMomentAs(nextTime)) {
          
          // Syuruq does not have iqomah or prayer view
          if (_nextPrayer == Prayer.sunrise) {
            debugPrint('[ScheduleProvider] Syuruq time reached, skipping transition.');
            _updateNextPrayer(); // Just move to the next prayer (Dhuhr)
            notifyListeners();
            return;
          }

          // It is prayer time!
          _transitionToIqomah(_nextPrayer!);
        }
      }
    } else if (_currentMode == AppMode.iqomahTimer) {
      if (_iqomahSecondsRemaining > 0) {
        _iqomahSecondsRemaining--;
      } else {
        _transitionToPrayer();
      }
    } else if (_currentMode == AppMode.prayerTime) {
      if (_prayerStateEndTime != null &&
          _currentTime.isAfter(_prayerStateEndTime!)) {
        _transitionToDefault();
      }
    }
  }

  void _transitionToIqomah(Prayer prayer) {
    _currentMode = AppMode.iqomahTimer;
    _currentPrayerName = _getPrayerName(prayer);

    // Get per-prayer iqomah config
    final config = dataProvider.config;
    IqomahConfig iqomahConfig;
    switch (prayer) {
      case Prayer.fajr:
        iqomahConfig = config.subuhConfig;
        break;
      case Prayer.dhuhr:
        iqomahConfig = config.dzuhurConfig;
        break;
      case Prayer.asr:
        iqomahConfig = config.asharConfig;
        break;
      case Prayer.maghrib:
        iqomahConfig = config.maghribConfig;
        break;
      case Prayer.isha:
        iqomahConfig = config.isyaConfig;
        break;
      default:
        iqomahConfig = IqomahConfig.defaultConfig();
    }

    _iqomahSecondsRemaining = iqomahConfig.waktuIqomah * 60;
    _currentIqomahConfig = iqomahConfig;

    // Just in case we need to calculate next prayer after this
    _updateNextPrayer();
    notifyListeners();
  }

  Future<void> _transitionToPrayer() async {
    _currentMode = AppMode.prayerTime;

    // Play beep 3 times
    try {
      await _audioPlayer?.play(AssetSource('sounds/beep.mp3'));
    } catch (e) {
      debugPrint("Error playing beep: $e");
    }

    final prayerMinutes =
        _currentIqomahConfig?.waktuShalat ?? 15;
    _prayerStateEndTime = _currentTime.add(Duration(minutes: prayerMinutes));
    notifyListeners();
  }

  void _transitionToDefault() {
    _currentMode = AppMode.defaultView;
    _currentPrayerName = null;
    _prayerStateEndTime = null;
    _updateNextPrayer();
    notifyListeners();
  }

  String _getPrayerName(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return 'Subuh';
      case Prayer.sunrise:
        return 'Syuruq';
      case Prayer.dhuhr:
        return 'Dzuhur';
      case Prayer.asr:
        return 'Ashar';
      case Prayer.maghrib:
        return 'Maghrib';
      case Prayer.isha:
        return 'Isya';
      case Prayer.none:
        return '';
    }
  }
}
