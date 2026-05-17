const admin = require('firebase-admin');

// TODO: Masukkan path ke file service account key dari Firebase Console
// (Project Settings -> Service Accounts -> Generate new private key)
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

/**
 * Fungsi untuk menambah atau mengupdate data masjid
 * @param {string} masjidId - ID dari masjid (contoh: 'al_muhajirin_yiami')
 * @param {object} data - Data masjid yang akan disimpan
 */
async function addOrUpdateMasjid(masjidId, data) {
  try {
    const masjidRef = db.collection('masjid').doc(masjidId);

    // Gunakan { merge: true } agar jika dokumen sudah ada, data lama tidak terhapus semua
    // melainkan hanya mengupdate field yang diberikan
    await masjidRef.set(data, { merge: true });

    console.log(`✅ Berhasil menyimpan data untuk masjid: ${masjidId}`);
  } catch (error) {
    console.error(`❌ Gagal menyimpan data untuk masjid: ${masjidId}`, error);
  }
}

// ==========================================
// CONTOH PENGGUNAAN (DATA SESUAI STRUKTUR)
// ==========================================
const contohDataMasjid = {
  nama: 'Mushola Al Muhajirin Yiami',
  lokasi: 'Cileungsi - Bogor',
  background_url: '',
  durasi_slide: 5,
  latitude: -6.4023,
  longitude: 106.9705,
  iqomah: {
    subuh: { waktu_iqomah: 20, waktu_shalat: 15 },
    dzuhur: { waktu_iqomah: 20, waktu_shalat: 15 },
    ashar: { waktu_iqomah: 20, waktu_shalat: 15 },
    maghrib: { waktu_iqomah: 10, waktu_shalat: 15 },
    isya: { waktu_iqomah: 15, waktu_shalat: 15 }
  },
  nasehat: [
    {
      id: '1',
      dalil: 'QS Al Baqoroh 255',
      isi: 'Allah, tidak ada Tuhan (yang berhak disembah) melainkan Dia Yang Hidup kekal lagi terus menerus mengurus (makhluk-Nya)...',
    },
    {
      id: '2',
      dalil: 'QS Al Baqoroh 256',
      isi: 'Tidak ada paksaan untuk (memasuki) agama (Islam); sesungguhnya telah jelas jalan yang benar daripada jalan yang sesat...',
    },
    {
      id: '3',
      dalil: 'QS Al Baqoroh 257',
      isi: 'Allah Pelindung orang-orang yang beriman; Dia mengeluarkan mereka dari kegelapan (kekafiran) kepada cahaya (iman)...'
    },
    {
      id: '4',
      dalil: 'QS Al-Ankabut: 45',
      isi: 'Sesungguhnya shalat itu mencegah dari perbuatan keji dan mungkar.',
    },
    {
      id: '5',
      dalil: 'QS. An-Nisa: 103',
      isi: 'Sesungguhnya shalat adalah kewajiban yang ditentukan waktunya atas orang-orang yang beriman.',
    },
    {
      id: '6',
      dalil: 'QS. Al-Mu\'minun: 1–2',
      isi: 'Beruntunglah orang-orang yang khusyuk dalam shalatnya.',
    },
    {
      id: '7',
      dalil: 'QS. Al-Baqarah: 153',
      isi: 'Dan mintalah pertolongan kepadaNya dengan sabar dan shalat, sesungguhnya Allah beserta orang-orang yang sabar',
    },
    {
      id: '8',
      dalil: 'QS. Ar-Ra\'d: 28',
      isi: 'Dengan mengingat Allah hati menjadi tenteram.',
    },
    {
      id: '9',
      dalil: 'QS. Al-Ma\'un: 4–5',
      isi: 'Maka celakalah orang-orang yang lalai dari shalatnya',
    },
    {
      id: '10',
      dalil: 'HR. Ahmad',
      isi: 'Jagalah shalat lima waktu, karena ia tiang agama.',
    },
    {
      id: '11',
      dalil: 'HR. Tirmidzi',
      isi: 'Barang siapa meninggalkan shalat dengan sengaja, maka ia telah kafir.',
    },
    {
      id: '12',
      dalil: 'HR. Al-Baihaqi',
      isi: 'Shalatlah sebelum dishalatkan.',
    },
    {
      id: '13',
      dalil: 'HR. Bukhari',
      isi: 'Dekatkanlah diri kalian kepada Allah dengan amal yang paling dicintai-Nya, yaitu shalat.',
    },
    {
      id: '14',
      dalil: 'HR. Muslim',
      isi: 'Antara seorang hamba dan kekafiran adalah meninggalkan shalat.',
    },
    {
      id: '15',
      dalil: 'HR. Muslim',
      isi: 'Shalat adalah cahaya.',
    }
  ],
  informasi: [
    {
      id: '1',
      title: 'Kajian Rutin',
      content: 'Setiap ahad pagi ba\'da subuh'
    },
    {
      id: '2',
      title: 'Laporan Keuangan',
      content: 'Saldo kas saat ini: Rp 15.000.000'
    },
    {
      id: '3',
      title: 'Kerja Bakti',
      content: 'Hari minggu depan ada kerja bakti membersihkan lingkungan masjid'
    },
    {
      id: '4',
      title: "Ustadz Abu Ukasyah Dindin Kurniawan - Adab Dan Akhlak Penuntut Ilmu",
      content: "Setiap Ahad Ba'da Shalat Subuh - selesai pekan ke-1 dan ke-4, Karya Ustadz Yazid bin Abdul Qadir Jawas"
    },
    {
      id: '5',
      title: "Ustadz Abu Arika Jamiludin, Lc. - Sifat Shalat Nabi",
      content: "Kajian Rutin Setiap Kamis Ba'da Maghrib - Selesai pekan ke-1 dan ke-3, Karya Syaikh Al-Albani"
    },
    {
      id: '6',
      title: "Ustadz Wukir Saputro, Lc. M.Pd - Aqidah (Penjabaran Asmaul Husna)",
      content: "Setiap Sabtu Ba'da Shalat Maghrib - selesai pekan ke-2 dan ke-4"
    },
    {
      id: '7',
      title: "Ustadz Muhammad Alpen Hidayatullah Lc. - Al Bidayah Fi Al-Aqidah",
      content: "Setiap Senin Ba'da Shalat Maghrib - selesai, Karya Syaikh Muhammad bin Shalih Al Utsaimin"
    },
    {
      id: '8',
      title: "Ustadz Ahmad Munawar, S.Pd Hafidzahullah - Kajian Bahasa Arab",
      content: "Setiap Sabtu Ba'da Subuh - selesai"
    },
    {
      id: '9',
      title: "Ustadzah Linda - Asmaul Husna (Al Akhir) Ummahat",
      content: "Setiap Ahad Pukul 08.30 - 10.30 pekan ke-2 dan ke-4"
    },
    {
      id: '10',
      title: "Ustadzah Lisa - Kajian Tahsin Al-Qur'an Ummahat",
      content: "Setiap Rabu pukul 09.00 - menjelang shalat Dzuhur"
    }
  ]
};

// Jalankan fungsi
// addOrUpdateMasjid('al_muhajirin_yiami', contohDataMasjid);
