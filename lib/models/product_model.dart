class ProductModel {
  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
  });

  final int id;
  final String title;
  final String description;
  final num price;
  final String thumbnail;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] is int ? json['id'] as int : 0,
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: json['price'] is num ? json['price'] as num : 0,
      thumbnail: (json['thumbnail'] ?? '').toString(),
    );
  }
}
