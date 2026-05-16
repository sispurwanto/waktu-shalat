/// Pusat Kendali Data Default Aplikasi
/// Ubah data di sini untuk menyesuaikan aplikasi saat mode offline
class AppConstants {
  // --- Identitas Masjid ---
  static const String defaultMasjidId = 'al_muhajirin_yiami';
  static const String defaultMosqueName = 'Mushola Al Muhajirin Yiami';
  static const String defaultMosqueLocation = 'Cileungsi - Bogor';
  static const String defaultBackgroundPath = 'assets/images/bg_masjid.jpg';
  
  // --- Koordinat (Penting untuk perhitungan waktu shalat) ---
  static const double defaultLatitude = -6.4023;
  static const double defaultLongitude = 106.9705;

  // --- Pengaturan Slide ---
  static const int defaultSlideIntervalMinutes = 5;

  // --- Pengaturan Iqomah (Menit) ---
  static const int iqomahSubuh = 20;
  static const int iqomahDzuhur = 20;
  static const int iqomahAshar = 20;
  static const int iqomahMaghrib = 10;
  static const int iqomahIsya = 15;

  // --- Pengaturan Durasi Shalat (Menit) ---
  static const int durasiShalat = 15;

  // --- Data Nasehat Default ---
  static const List<Map<String, String>> defaultAdvices = [
    {
      'id': '1',
      'dalil': 'HR. Muslim',
      'isi': '"Barangsiapa yang menempuh jalan untuk mencari ilmu, maka Allah akan mudahkan baginya jalan menuju surga."',
    },
    {
      'id': '2',
      'dalil': 'HR. Baihaqi',
      'isi': '"Shalat adalah tiang agama, barangsiapa mendirikannya maka ia telah mendirikan agama, dan barangsiapa meninggalkannya maka ia telah merobohkan agama."',
    },
    {
      'id': '3',
      'dalil': 'HR. Bukhari & Muslim',
      'isi': '"Sebaik-baik manusia adalah yang paling bermanfaat bagi manusia lainnya."',
    },
  ];

  // --- Data Informasi Masjid Default ---
  static const List<Map<String, String>> defaultMosqueInfos = [
    {
      'id': '1',
      'title': 'Kajian Rutin Ahad Pagi',
      'content': "Tafsir Jalalain bersama Ustadz Fulan.\nWaktu: Ba'da Subuh s.d. Syuruq.",
    },
    {
      'id': '2',
      'title': 'Laporan Keuangan',
      'content': 'Saldo Kas Masjid per 1 Mei 2026: Rp 15.000.000\nPengeluaran operasional bulan lalu: Rp 3.500.000.',
    },
  ];
}
