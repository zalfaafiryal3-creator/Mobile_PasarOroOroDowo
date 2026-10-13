class StoreData {
  const StoreData({
    required this.id,
    required this.name,
    required this.category,
    required this.displayCategory,
    required this.badge,
    required this.rating,
    required this.products,
    required this.image,
  });

  final String id;
  final String name;
  final String category;
  final String displayCategory;
  final String badge;
  final String rating;
  final String products;
  final String image;
}

const marketStores = <StoreData>[
  StoreData(
    id: 'lumpur-kentang-27',
    name: 'Lumpur Kentang 27',
    category: 'Makanan',
    displayCategory: 'Makanan',
    badge: 'Makanan',
    rating: '4.9',
    products: '3 Produk',
    image: '4ef0e.png',
  ),
  StoreData(
    id: 'bakso-goreng-bangkit',
    name: 'Bakso Goreng Ayam Bangkit',
    category: 'Makanan',
    displayCategory: 'Makanan',
    badge: 'Makanan',
    rating: '4.8',
    products: '1 Produk',
    image: '1377a.png',
  ),
  StoreData(
    id: 'klepon-ku',
    name: 'Klepon-ku',
    category: 'Makanan',
    displayCategory: 'Makanan',
    badge: 'Makanan',
    rating: '4.8',
    products: '2 Produk',
    image: 'f52ae.png',
  ),
  StoreData(
    id: 'pangsit-mie-arema',
    name: 'Pangsit Mie Arema',
    category: 'Makanan',
    displayCategory: 'Makanan',
    badge: 'Makanan',
    rating: '4.9',
    products: '1 Produk',
    image: 'pangsit mie arema.png',
  ),
  StoreData(
    id: 'bagoplek-bakso-goreng',
    name: 'Bagoplek Bakso Goreng',
    category: 'Makanan',
    displayCategory: 'Makanan',
    badge: 'Makanan',
    rating: '4.9',
    products: '1 Produk',
    image: '1377a.png',
  ),
  StoreData(
    id: 'fresgreen-organic',
    name: 'FresGreen Organic',
    category: 'Sayur & Buah',
    displayCategory: 'Makanan & Minuman',
    badge: 'Makanan & Minuman',
    rating: '4.8',
    products: '1 Produk',
    image: '3a328.png',
  ),
  StoreData(
    id: 'sego-liwet-kemangi',
    name: 'Sego liwet Bakar Kemangi',
    category: 'Kuliner Legendaris',
    displayCategory: 'Makanan',
    badge: 'Makanan',
    rating: '4.8',
    products: '2 Produk',
    image: 'jajanan pasar.jpg',
  ),
  StoreData(
    id: 'norriture',
    name: 'Norriture',
    category: 'Daging & Ikan',
    displayCategory: 'Daging',
    badge: 'Makanan',
    rating: '4.9',
    products: '1 Produk',
    image: 'tempe segar.jpg',
  ),
  StoreData(
    id: 'wiwit-sayur',
    name: 'Wiwit Sayur',
    category: 'Sayur & Buah',
    displayCategory: 'Sayur',
    badge: 'Sayur',
    rating: '4.9',
    products: 'Produk',
    image: '3a328.png',
  ),
  StoreData(
    id: 'toko-sembako-barokah',
    name: 'Toko Sembako Barokah',
    category: 'Sembako & Perabotan',
    displayCategory: 'Sembako & Perabotan',
    badge: 'Sembako',
    rating: '4.9',
    products: '12 Produk',
    image: '204f2.png',
  ),
  StoreData(
    id: 'kios-mainan-baju',
    name: 'Kios Mainan & Baju Ceria',
    category: 'Mainan & Baju',
    displayCategory: 'Mainan & Baju',
    badge: 'Mainan & Baju',
    rating: '4.7',
    products: '8 Produk',
    image: '2312e.png',
  ),
];

const storeCategories = <String>[
  'Makanan',
  'Sayur & Buah',
  'Kuliner Legendaris',
  'Daging & Ikan',
  'Sembako & Perabotan',
  'Mainan & Baju',
];

class MarketProduct {
  const MarketProduct({
    required this.name,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.price,
  });

  final String name;
  final String image;
  final String rating;
  final String reviewCount;
  final String price;
}

const storeProducts = <MarketProduct>[
  MarketProduct(
    name: 'Kismis',
    image: '04adb.png',
    rating: '4.9',
    reviewCount: '92',
    price: 'Rp 7.000',
  ),
  MarketProduct(
    name: 'Keju',
    image: 'ef2b3.png',
    rating: '5.0',
    reviewCount: '45',
    price: 'Rp 7.000',
  ),
  MarketProduct(
    name: 'Kelapa',
    image: 'ac276.png',
    rating: '4.8',
    reviewCount: '31',
    price: 'Rp 7.000',
  ),
  MarketProduct(
    name: 'Bikang Suji',
    image: 'c2a9f.png',
    rating: '4.9',
    reviewCount: '19',
    price: 'Rp 4.000',
  ),
  MarketProduct(
    name: 'Lemper Ayam',
    image: '230db.png',
    rating: '4.9',
    reviewCount: '92',
    price: 'Rp 7.000',
  ),
];

class PromoData {
  const PromoData({
    required this.title,
    required this.image,
    required this.status,
    required this.note,
    required this.description,
    required this.period,
    this.periodLabel = 'Periode',
    required this.time,
    this.timeLabel = 'Jam',
    required this.finePrint,
    this.category = 'Zona Makanan',
    this.ongoing = false,
    this.weekend = false,
  });

  final String title;
  final String image;
  final String status;
  final String note;
  final String description;
  final String period;
  final String periodLabel;
  final String time;
  final String timeLabel;
  final String finePrint;
  final String category;
  final bool ongoing;
  final bool weekend;
}

const marketPromos = <PromoData>[
  PromoData(
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
  PromoData(
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
  PromoData(
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
  PromoData(
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
