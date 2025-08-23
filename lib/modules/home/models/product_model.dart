import 'dart:convert';

class Product {
  final String id;
  final String name;
  final Map<String, dynamic>? data;

  Product({
    required this.id,
    required this.name,
    this.data,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'data': data,
    };
  }

  static List<Product> listFromJson(String str) {
    final decoded = jsonDecode(str) as List<dynamic>;
    return decoded.map((json) => Product.fromJson(json)).toList();
  }
}
