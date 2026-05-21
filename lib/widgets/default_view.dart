import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:adhan/adhan.dart';
import '../providers/data_provider.dart';
import '../providers/schedule_provider.dart';
import '../constants.dart';

class DefaultView extends StatefulWidget {
  const DefaultView({super.key});

  @override
  State<DefaultView> createState() => _DefaultViewState();
}

class _DefaultViewState extends State<DefaultView> {
  int _adviceIndex = 0;
  int _infoIndex = 0;
  Timer? _adviceTimer;
  Timer? _infoTimer;

  static const int _itemRotationSeconds = 20;

  @override
  void initState() {
    super.initState();
    _startTimers();
  }

  void _startTimers() {
    _adviceTimer = Timer.periodic(
      const Duration(seconds: _itemRotationSeconds),
      (_) {
        final dp = Provider.of<DataProvider>(context, listen: false);
        if (dp.advices.isNotEmpty) {
          setState(() {
            _adviceIndex = (_adviceIndex + 1) % dp.advices.length;
          });
        }
      },
    );
    _infoTimer = Timer.periodic(
      const Duration(seconds: _itemRotationSeconds),
      (_) {
        final dp = Provider.of<DataProvider>(context, listen: false);
        if (dp.mosqueInfos.isNotEmpty) {
          setState(() {
            _infoIndex = (_infoIndex + 1) % dp.mosqueInfos.length;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _adviceTimer?.cancel();
    _infoTimer?.cancel();
    super.dispose();
  }

  String _getPrayerName(Prayer? prayer) {
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
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final dataProvider = Provider.of<DataProvider>(context);

    // Clamp indices in case data changes from Firestore
    final adviceIdx = dataProvider.advices.isNotEmpty
        ? _adviceIndex % dataProvider.advices.length
        : 0;
    final infoIdx = dataProvider.mosqueInfos.isNotEmpty
        ? _infoIndex % dataProvider.mosqueInfos.length
        : 0;

    return Column(
      children: [

        // ── Header ──────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4), // Minimized from 8
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Mosque name & location
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dataProvider.config.mosqueName,
                    style: const TextStyle(
                      fontSize: 32, // Reduced from 42
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    dataProvider.config.mosqueLocation,
                    style: const TextStyle(fontSize: 18, color: Colors.white70), // Reduced from 24
                  ),
                ],
              ),
              // Right: Clock & date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    scheduleProvider.formattedCurrentTime,
                    style: const TextStyle(
                      fontSize: 34, // Reduced from 40
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${scheduleProvider.formattedCurrentDate} | ${scheduleProvider.formattedHijriDate}',
                    style: const TextStyle(fontSize: 18, color: Colors.greenAccent), // Reduced from 22
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Main Carousel (Advice ↔ Info Masjid) ────────────────────
        Expanded(
          child: _buildCarousel(dataProvider, adviceIdx, infoIdx),
        ),

        // ── Footer: Countdown + Prayer Schedule ─────────────────────
        _buildFooterSchedule(scheduleProvider),
      ],
    );
  }

  Widget _buildCarousel(DataProvider dataProvider, int adviceIdx, int infoIdx) {
    final slideMinutes = dataProvider.config.slideIntervalMinutes;

    // Build two slides: one for Advice, one for MosqueInfo
    final List<Widget> slides = [];

    // Slide 1: Nasehat
    if (dataProvider.advices.isNotEmpty) {
      final advice = dataProvider.advices[adviceIdx];
      slides.add(
        _CarouselSlide(
          key: ValueKey('advice_$adviceIdx'),
          backgroundUrl: advice.urlSlide,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                advice.isi,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32, // Further reduced
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '— ${advice.dalil}',
                style: const TextStyle(
                  fontSize: 22, // Further reduced
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Slide 2: Info Masjid
    if (dataProvider.mosqueInfos.isNotEmpty) {
      final info = dataProvider.mosqueInfos[infoIdx];
      slides.add(
        _CarouselSlide(
          key: ValueKey('info_$infoIdx'),
          backgroundUrl: info.urlSlide,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                info.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 42, // Further reduced
                  fontWeight: FontWeight.w900,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                info.content,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30, // Further reduced
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (slides.isEmpty) {
      return const Center(
        child: Text('Tidak ada informasi saat ini.',
            style: TextStyle(color: Colors.white70)),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(minutes: slideMinutes),
        viewportFraction: 1.0,
        height: double.infinity,
      ),
      items: slides,
    );
  }

  Widget _buildFooterSchedule(ScheduleProvider scheduleProvider) {
    final pt = scheduleProvider.prayerTimes;
    if (pt == null) return const SizedBox.shrink();

    final dateFormat = DateFormat('HH:mm');

    String countdownText = '';
    if (scheduleProvider.nextPrayerTime != null &&
        scheduleProvider.nextPrayer != null) {
      final diff = scheduleProvider.nextPrayerTime!.difference(
        scheduleProvider.currentTime,
      );
      if (!diff.isNegative) {
        final hours = diff.inHours.toString().padLeft(2, '0');
        final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
        final nextName = _getPrayerName(scheduleProvider.nextPrayer);
        if (nextName == 'Syuruq') {
          countdownText = '$hours:$minutes:$seconds menuju $nextName';
        } else {
          countdownText = '$hours:$minutes:$seconds menuju shalat $nextName';
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10), // Minimized from 6
      color: const Color(0xFF092920),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (countdownText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                countdownText,
                style: const TextStyle(
                  fontSize: 24, // Reduced from 28
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ScheduleItem(
                'Subuh',
                dateFormat.format(pt.fajr),
                scheduleProvider.nextPrayer == Prayer.fajr,
              ),
              _ScheduleItem(
                'Syuruq',
                dateFormat.format(pt.sunrise),
                scheduleProvider.nextPrayer == Prayer.sunrise,
              ),
              _ScheduleItem(
                'Dzuhur',
                dateFormat.format(pt.dhuhr),
                scheduleProvider.nextPrayer == Prayer.dhuhr,
              ),
              _ScheduleItem(
                'Ashar',
                dateFormat.format(pt.asr),
                scheduleProvider.nextPrayer == Prayer.asr,
              ),
              _ScheduleItem(
                'Maghrib',
                dateFormat.format(pt.maghrib),
                scheduleProvider.nextPrayer == Prayer.maghrib,
              ),
              _ScheduleItem(
                'Isya',
                dateFormat.format(pt.isha),
                scheduleProvider.nextPrayer == Prayer.isha,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Helper: Carousel slide with AnimatedSwitcher ──────────────────────────────
class _CarouselSlide extends StatelessWidget {
  final Widget child;
  final String? backgroundUrl;

  const _CarouselSlide({
    super.key,
    required this.child,
    this.backgroundUrl,
  });

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    // Fallback logic for background
    String bgPath = backgroundUrl ?? '';
    if (bgPath.isEmpty || bgPath == '-') {
      bgPath = dataProvider.config.backgroundUrl;
    }
    if (bgPath.isEmpty || bgPath == '-') {
      bgPath = AppConstants.defaultBackgroundPath;
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: bgPath.startsWith('http')
              ? NetworkImage(bgPath) as ImageProvider
              : AssetImage(bgPath),
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: SingleChildScrollView(key: key, child: child),
          ),
        ),
      ),
    );
  }
}

// ── Schedule Item in footer ────────────────────────────────────────────────────
class _ScheduleItem extends StatelessWidget {
  final String name;
  final String time;
  final bool isNext;

  const _ScheduleItem(this.name, this.time, this.isNext);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: isNext ? 12 : 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
        color: isNext ? Colors.amber[400] : const Color(0xFF144D3E),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isNext ? Colors.white : Colors.teal[700]!,
          width: isNext ? 3 : 1,
        ),
        boxShadow: isNext
            ? [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.6),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: isNext ? 24 : 18,
              fontWeight: FontWeight.bold,
              color: isNext ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(height: 2), // Reduced from 5
          Text(
            time,
            style: TextStyle(
              fontSize: isNext ? 36 : 28,
              fontWeight: FontWeight.w600,
              color: isNext ? Colors.black : Colors.green[100],
            ),
          ),
        ],
      ),
    ),
    );
  }
}
