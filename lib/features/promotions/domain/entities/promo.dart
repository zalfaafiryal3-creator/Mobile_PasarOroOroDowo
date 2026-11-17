class Promo {
  const Promo({
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
