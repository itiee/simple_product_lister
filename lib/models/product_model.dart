class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final String category;
  final double rating;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.category,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'No Title',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      rating: (json['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'thumbnail': thumbnail,
      'category': category,
      'rating': rating,
    };
  }
}

class ProductResponse {
  final List<ProductModel> products;
  final int total;

  ProductResponse({required this.products, required this.total});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      products: (json['products'] as List)
          .map((i) => ProductModel.fromJson(i as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );
  }
}
