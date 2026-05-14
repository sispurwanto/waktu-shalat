import 'package:flutter/material.dart';
import '../models/models.dart';

class DataProvider with ChangeNotifier {
  final AppConfig _config = AppConfig.defaultConfig();
  AppConfig get config => _config;

  final List<Advice> _advices = [
    Advice(
      id: '1',
      text:
          '“Barangsiapa yang menempuh suatu jalan untuk menuntut ilmu, maka Allah Swt akan memudahkan baginya jalan menuju surga.” (HR. Muslim)',
    ),
    Advice(
      id: '2',
      text:
          '“Shalat adalah tiang agama, barangsiapa mendirikannya maka ia telah mendirikan agama, dan barangsiapa meninggalkannya maka ia telah merobohkan agama.” (HR. Baihaqi)',
    ),
  ];
  List<Advice> get advices => _advices;

  final List<MosqueInfo> _mosqueInfos = [
    MosqueInfo(
      id: '1',
      title: 'Kajian Rutin Ahad Pagi',
      content:
          'Tafsir Jalalain bersama Ustadz Fulan. Waktu: Ba\'da Subuh s.d. Syuruq.',
    ),
    MosqueInfo(
      id: '2',
      title: 'Laporan Keuangan',
      content:
          'Saldo Kas Masjid per 1 Mei 2026: Rp 15.000.000. Pengeluaran operasional bulan lalu: Rp 3.500.000.',
    ),
  ];
  List<MosqueInfo> get mosqueInfos => _mosqueInfos;

  // In the future, these methods will listen to Firestore and update the state
  void loadMockData() {
    // This is already loaded synchronously for mock purposes.
    notifyListeners();
  }
}
