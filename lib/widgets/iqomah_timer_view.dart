import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';

class IqomahTimerView extends StatelessWidget {
  const IqomahTimerView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);

    final int remainingSeconds = scheduleProvider.iqomahSecondsRemaining;
    final int minutes = remainingSeconds ~/ 60;
    final int seconds = remainingSeconds % 60;

    final String timeString =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    final String prayerName = scheduleProvider.currentPrayerName ?? '';

    return Container(
      color: const Color(0xFF0D3B2E),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              prayerName == 'Syuruq' ? 'Waktu Tunggu' : 'Menuju Iqomah',
              style: TextStyle(
                fontSize: 48,
                color: Colors.amber[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              timeString,
              style: const TextStyle(
                fontSize: 180,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              prayerName == 'Syuruq' ? prayerName : 'Shalat $prayerName',
              style: const TextStyle(fontSize: 48, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
