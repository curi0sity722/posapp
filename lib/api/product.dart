
class Product {
  final String title;
  final String brand;
  final double price;
  final double discountPercentage;
  final String thumbnail;

  Product({
    required this.title,
    required this.brand,
    required this.price,
    required this.discountPercentage,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'] ?? 'No Title', // Default value for null
      brand: json['brand'] ?? 'Unknown Brand', // Default value for null
      price: json['price']?.toDouble() ?? 0.0, // Handle null values
      discountPercentage: json['discountPercentage']?.toDouble() ?? 0.0, // Handle null values
      thumbnail: json['thumbnail'] ?? 'https://example.com/default_thumbnail.png', // Default value for null
    );
  }
}
