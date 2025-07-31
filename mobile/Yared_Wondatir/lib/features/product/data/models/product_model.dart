import 'dart:convert';
import '../../../../core/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.price,
  });

  // Factory constructor to create ProductModel from JSON
  factory ProductModel.fromJson(String source) {
    final Map<String, dynamic> json = jsonDecode(source);
    return ProductModel.fromMap(json);
  }

  // Factory constructor to create ProductModel from Map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }

  // Convert ProductModel to JSON string
  String toJson() {
    return jsonEncode(toMap());
  }

  // Convert ProductModel to Map
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  // Convert Product entity to ProductModel
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
    );
  }

  // Convert ProductModel to Product entity
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      price: price,
    );
  }

  // Copy with method for ProductModel
  @override
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
    );
  }

  // Factory method for creating new ProductModel
  factory ProductModel.create({
    required String name,
    required String description,
    required String imageUrl,
    required double price,
  }) {
    return ProductModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      imageUrl: imageUrl,
      price: price,
    );
  }

  // Validation methods
  @override
  bool isValid() {
    return id.isNotEmpty && 
           name.isNotEmpty && 
           description.isNotEmpty && 
           imageUrl.isNotEmpty && 
           price > 0;
  }

  @override
  List<String> getValidationErrors() {
    final errors = <String>[];
    
    if (id.isEmpty) errors.add('Product ID is required');
    if (name.isEmpty) errors.add('Product name is required');
    if (description.isEmpty) errors.add('Product description is required');
    if (imageUrl.isEmpty) errors.add('Product image URL is required');
    if (price <= 0) errors.add('Product price must be greater than 0');
    
    return errors;
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, description: $description, imageUrl: $imageUrl, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        imageUrl.hashCode ^
        price.hashCode;
  }
} 