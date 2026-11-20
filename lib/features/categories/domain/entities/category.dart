class StoreCategory {
  const StoreCategory({
    required this.id,
    required this.name,
    this.storeCount = 0,
  });

  final int id;
  final String name;
  final int storeCount;

  factory StoreCategory.fromJson(Map<String, dynamic> json) {
    return StoreCategory(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      name: json['name'] is String ? (json['name'] as String).trim() : '',
      storeCount: json['storeCount'] is int
          ? json['storeCount'] as int
          : int.tryParse('${json['storeCount']}') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'storeCount': storeCount,
  };
}
