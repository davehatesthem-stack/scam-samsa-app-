class SamsaModel {
  final String id;
  final String name;
  final String quality;
  final String ingredients;
  final String dough;
  final String price;
  final String? imageUrl;

  SamsaModel({
    required this.id,
    required this.name,
    required this.quality,
    required this.ingredients,
    required this.dough,
    required this.price,
    this.imageUrl,
  });

  factory SamsaModel.fromJson(Map<String, dynamic> json) {
    return SamsaModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Meat samsa',
      quality: json['quality']?.toString() ?? 'Good quality',
      ingredients: json['ingredients']?.toString() ?? 'Onion',
      dough: json['dough']?.toString() ?? 'Onion',
      price: json['price']?.toString() ?? '13,000 UZS',
      imageUrl: json['image']?.toString(),
    );
  }
}