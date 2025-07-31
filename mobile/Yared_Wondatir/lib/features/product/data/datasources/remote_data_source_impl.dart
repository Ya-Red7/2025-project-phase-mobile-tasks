import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../../../core/entities/product.dart';
import 'remote_data_source.dart';

/// Implementation of RemoteDataSource that simulates network operations
/// In a real app, this would make actual HTTP requests to a REST API
class RemoteDataSourceImpl implements RemoteDataSource {
  // Simulated API base URL
  static const String _baseUrl = 'https://api.ecommerce.com';
  
  // Simulated network delay
  static const Duration _networkDelay = Duration(milliseconds: 800);
  
  // Simulated products data (in real app, this would come from API)
  static final List<Product> _mockProducts = [
    const Product(
      id: '1',
      name: 'Derby Leather Shoes',
      description: 'Classic derby shoes made from premium leather',
      imageUrl: 'assets/photo.jpg',
      price: 129.99,
    ),
    const Product(
      id: '2',
      name: 'Running Sneakers',
      description: 'Comfortable running shoes with breathable mesh',
      imageUrl: 'assets/photo.jpg',
      price: 89.99,
    ),
    const Product(
      id: '3',
      name: 'Casual Loafers',
      description: 'Stylish casual loafers for everyday wear',
      imageUrl: 'assets/photo.jpg',
      price: 79.99,
    ),
    const Product(
      id: '4',
      name: 'Formal Oxford Shoes',
      description: 'Elegant formal oxford shoes for business occasions',
      imageUrl: 'assets/photo.jpg',
      price: 159.99,
    ),
  ];

  @override
  Future<List<Product>> getAllProducts() async {
    // Simulate network delay
    await Future.delayed(_networkDelay);
    
    // Simulate network error (10% chance)
    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to fetch products');
    }
    
    // Return a copy of the mock data
    return List.from(_mockProducts);
  }

  @override
  Future<Product?> getProductById(String id) async {
    await Future.delayed(_networkDelay);
    
    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to fetch product');
    }
    
    try {
      return _mockProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null; // Product not found
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    await Future.delayed(_networkDelay);
    
    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to create product');
    }
    
    // Simulate server-generated ID
    final newProduct = product.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    
    // In a real implementation, this would be sent to the server
    // and the server would return the created product with ID
    
    return newProduct;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    await Future.delayed(_networkDelay);
    
    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to update product');
    }
    
    // Check if product exists
    final existingIndex = _mockProducts.indexWhere((p) => p.id == product.id);
    if (existingIndex == -1) {
      throw Exception('Product not found');
    }
    
    // In a real implementation, this would be sent to the server
    // and the server would return the updated product
    
    return product;
  }

  @override
  Future<bool> deleteProduct(String id) async {
    await Future.delayed(_networkDelay);
    
    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to delete product');
    }
    
    // Check if product exists
    final existingIndex = _mockProducts.indexWhere((p) => p.id == id);
    if (existingIndex == -1) {
      return false; // Product not found
    }
    
    // In a real implementation, this would be sent to the server
    // and the server would confirm deletion
    
    return true;
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(_networkDelay);
    
    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to search products');
    }
    
    if (query.isEmpty) {
      return getAllProducts();
    }
    
    final lowercaseQuery = query.toLowerCase();
    return _mockProducts.where((product) {
      return product.name.toLowerCase().contains(lowercaseQuery) ||
             product.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    await Future.delayed(_networkDelay);
    
    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to fetch products by category');
    }
    
    // For now, return all products (in real app, this would filter by category)
    return getAllProducts();
  }

  @override
  Future<bool> isNetworkAvailable() async {
    // Simulate network check
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Simulate network availability (90% chance of being available)
    return Random().nextDouble() > 0.1;
  }

  @override
  Future<NetworkInfo> getNetworkInfo() async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final isConnected = await isNetworkAvailable();
    final responseTime = Random().nextInt(500) + 100; // 100-600ms
    
    return NetworkInfo(
      isConnected: isConnected,
      connectionType: isConnected ? 'WiFi' : 'None',
      responseTime: responseTime,
    );
  }

  /// Simulates network errors for testing purposes
  bool _shouldSimulateError() {
    return Random().nextDouble() < 0.1; // 10% chance of error
  }

  /// Real HTTP implementation example (commented out for demo)
  Future<List<Product>> _realHttpGetAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_API_KEY',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Product.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
} 