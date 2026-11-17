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
