import '../../../domain/entities/promo.dart';

const marketPromos = <Promo>[
  Promo(
    title: 'Diskon Tahu Bakso',
    image: 'promo tahu bakso.jpg',
    status: 'Sedang Berlangsung',
    note: 'Langsung di Kios',
    description: 'Lagi nyari camilan penunda lapar yang gurih dan nagih? Tahu Bakso siap nemenin waktu santai kamu! Lengkap dengan 7 varian topping lezat yang bikin makin mantap.',
    period: '1 Sep – 1 Okt 2026',
    periodLabel: 'Periode',
    time: 'Setiap pukul 06.00 – 09.00 WIB',
    timeLabel: 'Jam Khusus',
    finePrint: 'Berlaku otomatis tanpa syarat',
    ongoing: true,
  ),
  Promo(
    title: 'Diskon Cake',
    image: 'promo cake.jpg',
    status: 'Akan Datang',
    note: 'Mulai 20 Okt',
    description: 'Catat tanggalnya! Maniskan harimu dengan kelezatan slice cake pilihan dari kami dengan diskon 30%.',
    period: '1 Okt – 31 Okt 2026',
    periodLabel: 'Periode',
    time: '07.00 – 15.00 WIB (Setiap Hari)',
    timeLabel: 'Jam Buka',
    finePrint: 'Harga promo langsung di tempat',
  ),
  Promo(
    title: 'Promo Gado-Gado',
    image: 'promo gado gado.jpg',
    status: 'Setiap Akhir Pekan',
    note: 'Lantai 2 Pasar',
    description: 'Bingung mau makan apa pas weekend? Yuk, manjakan lidahmu dengan kelezatan bumbu kacang legendaris dan kesegaran bahan pilihan dari Warung Bu!',
    period: 'Sabtu & Minggu (Oktober 2026)',
    periodLabel: 'Periode',
    time: '08.00 – 16.00 WIB',
    timeLabel: 'Waktu',
    finePrint: 'Harga promo langsung di tempat',
    weekend: true,
  ),
  Promo(
    title: 'Promo Mie Ayam',
    image: 'promo mie ayam.jpg',
    status: 'Hari Pasaran Khusus',
    note: '1 Hari Saja',
    description: 'Khusus di Hari Pasaran Khusus, dapatkan penawaran terbaik untuk nikmati mangkuk mie favoritmu! Kenyal mienya, gurih kuahnya, dan melimpah toppingnya.',
    period: 'Selasa, 24 Oktober 2026',
    periodLabel: 'Tanggal',
    time: '1 hari penuh (05.00 – 16.00 WIB)',
    timeLabel: 'Durasi',
    finePrint: 'Harga promo langsung di tempat',
  ),
];

class PromoLocalDataSource {
  const PromoLocalDataSource();

  List<Promo> getPromotions() => marketPromos;
}
