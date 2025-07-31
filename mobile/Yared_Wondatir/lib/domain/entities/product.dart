class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }

  // Validation methods for TDD
  bool isValid() {
    return id.isNotEmpty && 
           name.isNotEmpty && 
           description.isNotEmpty && 
           imageUrl.isNotEmpty && 
           price > 0;
  }

  List<String> getValidationErrors() {
    final errors = <String>[];
    
    if (id.isEmpty) errors.add('Product ID is required');
    if (name.isEmpty) errors.add('Product name is required');
    if (description.isEmpty) errors.add('Product description is required');
    if (imageUrl.isEmpty) errors.add('Product image URL is required');
    if (price <= 0) errors.add('Product price must be greater than 0');
    
    return errors;
  }

  // Factory method for creating new products (for TDD)
  factory Product.create({
    required String name,
    required String description,
    required String imageUrl,
    required double price,
  }) {
    return Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      imageUrl: imageUrl,
      price: price,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, imageUrl: $imageUrl, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
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