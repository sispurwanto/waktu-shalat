import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import '../widgets/default_view.dart';
import '../widgets/iqomah_timer_view.dart';
import '../widgets/prayer_view.dart';

class MainDisplayScreen extends StatelessWidget {
  const MainDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ScheduleProvider>(
        builder: (context, schedule, child) {
          switch (schedule.currentMode) {
            case AppMode.defaultView:
              return const DefaultView();
            case AppMode.iqomahTimer:
              return const IqomahTimerView();
            case AppMode.prayerTime:
              return const PrayerView();
          }
        },
      ),
    );
  }
}
