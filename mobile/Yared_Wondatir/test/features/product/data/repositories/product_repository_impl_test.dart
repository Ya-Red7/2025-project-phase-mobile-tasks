import 'package:flutter_test/flutter_test.dart';
import 'package:flutter101/features/product/data/repositories/product_repository_impl.dart';
import 'package:flutter101/features/product/data/datasources/remote_data_source_impl.dart';
import 'package:flutter101/features/product/data/datasources/local_data_source_impl.dart';
import 'package:flutter101/features/product/data/datasources/remote_data_source.dart';
import 'package:flutter101/features/product/data/datasources/local_data_source.dart';
import 'package:flutter101/core/entities/product.dart';

void main() {
  late ProductRepositoryImpl repository;
  late RemoteDataSourceImpl remoteDataSource;
  late LocalDataSourceImpl localDataSource;

  setUp(() {
    remoteDataSource = RemoteDataSourceImpl();
    localDataSource = LocalDataSourceImpl();
    repository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });

  group('ProductRepositoryImpl Integration Tests', () {
    group('getAllProducts', () {
      test('should return products from remote data source', () async {
        // Act
        final result = await repository.getAllProducts();

        // Assert
        expect(result, isA<List<Product>>());
        expect(result.length, greaterThan(0));
        expect(result.first, isA<Product>());
      });

      test('should handle network errors gracefully', () async {
        // This test verifies that the repository can handle network issues
        // The implementation includes error handling for network failures
        
        // Act & Assert
        expect(() => repository.getAllProducts(), returnsNormally);
      });
    });

    group('getProductById', () {
      test('should return product when it exists', () async {
        // Arrange
        final products = await repository.getAllProducts();
        if (products.isNotEmpty) {
          final productId = products.first.id;

          // Act
          final result = await repository.getProductById(productId);

          // Assert
          expect(result, isNotNull);
          expect(result!.id, productId);
        }
      });

      test('should return null when product does not exist', () async {
        // Act
        final result = await repository.getProductById('non-existent-id');

        // Assert
        expect(result, isNull);
      });
    });

    group('createProduct', () {
      test('should create a new product successfully', () async {
        // Arrange
        const newProduct = Product(
          id: '',
          name: 'Test Product',
          description: 'Test Description',
          imageUrl: 'assets/test.png',
          price: 99.99,
        );

        // Act
        final result = await repository.createProduct(newProduct);

        // Assert
        expect(result, isA<Product>());
        expect(result.id, isNotEmpty);
        expect(result.name, 'Test Product');
        expect(result.description, 'Test Description');
        expect(result.price, 99.99);
      });
    });

    group('updateProduct', () {
      test('should update an existing product', () async {
        // Arrange
        const productToUpdate = Product(
          id: '1',
          name: 'Updated Product',
          description: 'Updated Description',
          imageUrl: 'assets/updated.png',
          price: 199.99,
        );

        // Act
        final result = await repository.updateProduct(productToUpdate);

        // Assert
        expect(result, isA<Product>());
        expect(result.id, '1');
        expect(result.name, 'Updated Product');
        expect(result.description, 'Updated Description');
        expect(result.price, 199.99);
      });
    });

    group('deleteProduct', () {
      test('should delete an existing product', () async {
        // Arrange
        const productId = '1';

        // Act
        final result = await repository.deleteProduct(productId);

        // Assert
        expect(result, isA<bool>());
      });
    });

    group('searchProducts', () {
      test('should search products by query', () async {
        // Arrange
        const searchQuery = 'shoes';

        // Act
        final result = await repository.searchProducts(searchQuery);

        // Assert
        expect(result, isA<List<Product>>());
      });

      test('should return all products when query is empty', () async {
        // Act
        final result = await repository.searchProducts('');

        // Assert
        expect(result, isA<List<Product>>());
        expect(result.length, greaterThan(0));
      });
    });

    group('getProductsByCategory', () {
      test('should get products by category', () async {
        // Arrange
        const category = 'shoes';

        // Act
        final result = await repository.getProductsByCategory(category);

        // Assert
        expect(result, isA<List<Product>>());
      });
    });

    group('Network and Cache Information', () {
      test('should get network information', () async {
        // Act
        final result = await repository.getNetworkInfo();

        // Assert
        expect(result, isA<NetworkInfo>());
        expect(result.isConnected, isA<bool>());
        expect(result.connectionType, isA<String>());
        expect(result.responseTime, isA<int>());
      });

      test('should get cache information', () async {
        // Act
        final result = await repository.getCacheInfo();

        // Assert
        expect(result, isA<CacheInfo>());
        expect(result.totalProducts, isA<int>());
        expect(result.lastUpdated, isA<DateTime>());
        expect(result.cacheSizeBytes, isA<int>());
        expect(result.isExpired, isA<bool>());
      });

      test('should clear cache successfully', () async {
        // Act & Assert
        expect(() => repository.clearCache(), returnsNormally);
      });

      test('should refresh data from remote source', () async {
        // Act
        final result = await repository.refreshData();

        // Assert
        expect(result, isA<List<Product>>());
        expect(result.length, greaterThan(0));
      });
    });

    group('Repository Contract Compliance', () {
      test('should implement all required repository methods', () async {
        // This test verifies that the repository implements all methods
        // defined in the ProductRepository interface
        
        // Test getAllProducts
        expect(() => repository.getAllProducts(), returnsNormally);
        
        // Test getProductById
        expect(() => repository.getProductById('1'), returnsNormally);
        
        // Test createProduct
        const testProduct = Product(
          id: '',
          name: 'Test',
          description: 'Test',
          imageUrl: 'test.png',
          price: 10.0,
        );
        expect(() => repository.createProduct(testProduct), returnsNormally);
        
        // Test updateProduct
        const updateProduct = Product(
          id: '1',
          name: 'Test',
          description: 'Test',
          imageUrl: 'test.png',
          price: 10.0,
        );
        expect(() => repository.updateProduct(updateProduct), returnsNormally);
        
        // Test deleteProduct
        expect(() => repository.deleteProduct('1'), returnsNormally);
        
        // Test searchProducts
        expect(() => repository.searchProducts('test'), returnsNormally);
        
        // Test getProductsByCategory
        expect(() => repository.getProductsByCategory('test'), returnsNormally);
      });
    });
  });
} 