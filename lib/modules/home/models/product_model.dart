import 'dart:convert';

class ProductModel {
  final String id;
  final String name;
  final Map<String, dynamic>? data;

  ProductModel({
    required this.id,
    required this.name,
    this.data,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
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

  static List<ProductModel> listFromJson(String str) {
    final decoded = jsonDecode(str) as List<dynamic>;
    return decoded.map((json) => ProductModel.fromJson(json)).toList();
  }

  factory ProductModel.empty() {
    return ProductModel(
      id: '',
      name: '',
      data: {},
    );
  }
}
