import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';

class PrayerView extends StatelessWidget {
  const PrayerView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final String prayerName = scheduleProvider.currentPrayerName ?? '';

    return Container(
      color: const Color(0xFF0D3B2E),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              prayerName == 'Syuruq' ? 'Waktu $prayerName' : 'Shalat $prayerName',
              style: const TextStyle(
                fontSize: 120,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Lurus dan Rapatkan Shaf',
              style: TextStyle(fontSize: 60, color: Colors.amber),
            ),
            const SizedBox(height: 40),
            const Text(
              'Mohon Nonaktifkan Alat Komunikasi',
              style: TextStyle(fontSize: 40, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
