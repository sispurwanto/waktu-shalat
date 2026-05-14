import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:adhan/adhan.dart';
import '../providers/data_provider.dart';
import '../providers/schedule_provider.dart';

class DefaultView extends StatelessWidget {
  const DefaultView({super.key});

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

    return Column(
      children: [
        // Header Time
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dataProvider.config.mosqueName,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    dataProvider.config.mosqueLocation,
                    style: const TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${scheduleProvider.formattedCurrentTime}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${scheduleProvider.formattedCurrentDate} | ${scheduleProvider.formattedHijriDate}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Main Content (Carousel of Advices and Info)
        Expanded(child: _buildCarousel(dataProvider)),

        // Footer Prayer Schedule
        _buildFooterSchedule(scheduleProvider),
      ],
    );
  }

  Widget _buildCarousel(DataProvider dataProvider) {
    List<Widget> carouselItems = [];

    for (var advice in dataProvider.advices) {
      carouselItems.add(
        Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: SingleChildScrollView(
              child: Text(
                advice.text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 36,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }

    for (var info in dataProvider.mosqueInfos) {
      carouselItems.add(
        Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    info.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    info.content,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (carouselItems.isEmpty) {
      return const Center(child: Text("Tidak ada informasi saat ini."));
    }

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_masjid.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
      ),
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          autoPlayInterval: Duration(
            minutes: dataProvider.config.slideIntervalMinutes,
          ),
          viewportFraction: 1.0,
          height: double.infinity,
        ),
        items: carouselItems,
      ),
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
        String nextName = _getPrayerName(scheduleProvider.nextPrayer);
        countdownText = '$hours:$minutes:$seconds menuju shalat $nextName';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      color: const Color(0xFF092920), // Darker green for footer
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (countdownText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                countdownText,
                style: const TextStyle(
                  fontSize: 28,
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

class _ScheduleItem extends StatelessWidget {
  final String name;
  final String time;
  final bool isNext;

  const _ScheduleItem(this.name, this.time, this.isNext);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(10),
      width: isNext ? 130 : 110, // slightly wider if active
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
                  color: Colors.amber.withOpacity(0.6),
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
              fontSize: isNext ? 22 : 18,
              fontWeight: FontWeight.bold,
              color: isNext ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            time,
            style: TextStyle(
              fontSize: isNext ? 26 : 22,
              fontWeight: FontWeight.w600,
              color: isNext ? Colors.black : Colors.green[100],
            ),
          ),
        ],
      ),
    );
  }
}
