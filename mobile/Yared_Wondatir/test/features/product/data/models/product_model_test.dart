import 'package:flutter_test/flutter_test.dart';
import 'package:flutter101/features/product/data/models/product_model.dart';
import 'package:flutter101/core/entities/product.dart';

void main() {
  group('ProductModel Tests', () {
    test('should create a valid ProductModel', () {
      // Arrange
      const productModel = ProductModel(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        imageUrl: 'assets/test.png',
        price: 99.99,
      );

      // Assert
      expect(productModel.id, '1');
      expect(productModel.name, 'Test Product');
      expect(productModel.description, 'Test Description');
      expect(productModel.imageUrl, 'assets/test.png');
      expect(productModel.price, 99.99);
    });

    test('should create ProductModel using factory method', () {
      // Arrange & Act
      final productModel = ProductModel.create(
        name: 'Factory Product',
        description: 'Factory Description',
        imageUrl: 'assets/factory.png',
        price: 149.99,
      );

      // Assert
      expect(productModel.id, isNotEmpty);
      expect(productModel.name, 'Factory Product');
      expect(productModel.description, 'Factory Description');
      expect(productModel.imageUrl, 'assets/factory.png');
      expect(productModel.price, 149.99);
    });

    test('should validate a valid ProductModel', () {
      // Arrange
      const productModel = ProductModel(
        id: '1',
        name: 'Valid Product',
        description: 'Valid Description',
        imageUrl: 'assets/valid.png',
        price: 99.99,
      );

      // Act
      final isValid = productModel.isValid();

      // Assert
      expect(isValid, true);
    });

    test('should not validate an invalid ProductModel', () {
      // Arrange
      const productModel = ProductModel(
        id: '',
        name: '',
        description: '',
        imageUrl: '',
        price: 0,
      );

      // Act
      final isValid = productModel.isValid();

      // Assert
      expect(isValid, false);
    });

    test('should return validation errors for invalid ProductModel', () {
      // Arrange
      const productModel = ProductModel(
        id: '',
        name: '',
        description: '',
        imageUrl: '',
        price: 0,
      );

      // Act
      final errors = productModel.getValidationErrors();

      // Assert
      expect(errors.length, 5);
      expect(errors, contains('Product ID is required'));
      expect(errors, contains('Product name is required'));
      expect(errors, contains('Product description is required'));
      expect(errors, contains('Product image URL is required'));
      expect(errors, contains('Product price must be greater than 0'));
    });

    test('should copy ProductModel with new values', () {
      // Arrange
      const originalProductModel = ProductModel(
        id: '1',
        name: 'Original Product',
        description: 'Original Description',
        imageUrl: 'assets/original.png',
        price: 99.99,
      );

      // Act
      final copiedProductModel = originalProductModel.copyWith(
        name: 'Updated Product',
        price: 149.99,
      );

      // Assert
      expect(copiedProductModel.id, '1');
      expect(copiedProductModel.name, 'Updated Product');
      expect(copiedProductModel.description, 'Original Description');
      expect(copiedProductModel.imageUrl, 'assets/original.png');
      expect(copiedProductModel.price, 149.99);
    });

    test('should convert ProductModel to map', () {
      // Arrange
      const productModel = ProductModel(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        imageUrl: 'assets/test.png',
        price: 99.99,
      );

      // Act
      final map = productModel.toMap();

      // Assert
      expect(map['id'], '1');
      expect(map['name'], 'Test Product');
      expect(map['description'], 'Test Description');
      expect(map['imageUrl'], 'assets/test.png');
      expect(map['price'], 99.99);
    });

    test('should create ProductModel from map', () {
      // Arrange
      final map = {
        'id': '1',
        'name': 'Test Product',
        'description': 'Test Description',
        'imageUrl': 'assets/test.png',
        'price': 99.99,
      };

      // Act
      final productModel = ProductModel.fromMap(map);

      // Assert
      expect(productModel.id, '1');
      expect(productModel.name, 'Test Product');
      expect(productModel.description, 'Test Description');
      expect(productModel.imageUrl, 'assets/test.png');
      expect(productModel.price, 99.99);
    });

    test('should handle null values in fromMap', () {
      // Arrange
      final map = <String, dynamic>{};

      // Act
      final productModel = ProductModel.fromMap(map);

      // Assert
      expect(productModel.id, '');
      expect(productModel.name, '');
      expect(productModel.description, '');
      expect(productModel.imageUrl, '');
      expect(productModel.price, 0.0);
    });

    test('should convert ProductModel to JSON', () {
      // Arrange
      const productModel = ProductModel(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        imageUrl: 'assets/test.png',
        price: 99.99,
      );

      // Act
      final json = productModel.toJson();

      // Assert
      expect(json, contains('"id":"1"'));
      expect(json, contains('"name":"Test Product"'));
      expect(json, contains('"description":"Test Description"'));
      expect(json, contains('"imageUrl":"assets/test.png"'));
      expect(json, contains('"price":99.99'));
    });

    test('should create ProductModel from JSON', () {
      // Arrange
      const jsonString = '''
      {
        "id": "1",
        "name": "Test Product",
        "description": "Test Description",
        "imageUrl": "assets/test.png",
        "price": 99.99
      }
      ''';

      // Act
      final productModel = ProductModel.fromJson(jsonString);

      // Assert
      expect(productModel.id, '1');
      expect(productModel.name, 'Test Product');
      expect(productModel.description, 'Test Description');
      expect(productModel.imageUrl, 'assets/test.png');
      expect(productModel.price, 99.99);
    });

    test('should convert Product entity to ProductModel', () {
      // Arrange
      const product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        imageUrl: 'assets/test.png',
        price: 99.99,
      );

      // Act
      final productModel = ProductModel.fromEntity(product);

      // Assert
      expect(productModel.id, '1');
      expect(productModel.name, 'Test Product');
      expect(productModel.description, 'Test Description');
      expect(productModel.imageUrl, 'assets/test.png');
      expect(productModel.price, 99.99);
    });

    test('should convert ProductModel to Product entity', () {
      // Arrange
      const productModel = ProductModel(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        imageUrl: 'assets/test.png',
        price: 99.99,
      );

      // Act
      final product = productModel.toEntity();

      // Assert
      expect(product.id, '1');
      expect(product.name, 'Test Product');
      expect(product.description, 'Test Description');
      expect(product.imageUrl, 'assets/test.png');
      expect(product.price, 99.99);
    });

    test('should be equal to identical ProductModel', () {
      // Arrange
      const productModel1 = ProductModel(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        imageUrl: 'assets/test.png',
        price: 99.99,
      );

      const productModel2 = ProductModel(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        imageUrl: 'assets/test.png',
        price: 99.99,
      );

      // Assert
      expect(productModel1, productModel2);
    });

    test('should not be equal to different ProductModel', () {
      // Arrange
      const productModel1 = ProductModel(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        imageUrl: 'assets/test.png',
        price: 99.99,
      );

      const productModel2 = ProductModel(
        id: '2',
        name: 'Different Product',
        description: 'Different Description',
        imageUrl: 'assets/different.png',
        price: 149.99,
      );

      // Assert
      expect(productModel1, isNot(productModel2));
    });

    test('should have consistent hashCode', () {
      // Arrange
      const productModel1 = ProductModel(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        imageUrl: 'assets/test.png',
        price: 99.99,
      );

      const productModel2 = ProductModel(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        imageUrl: 'assets/test.png',
        price: 99.99,
      );

      // Assert
      expect(productModel1.hashCode, productModel2.hashCode);
    });

    test('should return proper string representation', () {
      // Arrange
      const productModel = ProductModel(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        imageUrl: 'assets/test.png',
        price: 99.99,
      );

      // Act
      final string = productModel.toString();

      // Assert
      expect(string, contains('ProductModel(id: 1, name: Test Product'));
    });

    test('should handle JSON with missing fields', () {
      // Arrange
      const jsonString = '''
      {
        "id": "1",
        "name": "Test Product"
      }
      ''';

      // Act
      final productModel = ProductModel.fromJson(jsonString);

      // Assert
      expect(productModel.id, '1');
      expect(productModel.name, 'Test Product');
      expect(productModel.description, '');
      expect(productModel.imageUrl, '');
      expect(productModel.price, 0.0);
    });

    test('should handle invalid JSON gracefully', () {
      // Arrange
      const invalidJson = 'invalid json';

      // Act & Assert
      expect(() => ProductModel.fromJson(invalidJson), throwsA(isA<FormatException>()));
    });
  });
} 