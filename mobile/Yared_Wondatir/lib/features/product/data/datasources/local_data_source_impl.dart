import 'dart:convert';
import 'dart:math';
import '../../../../core/entities/product.dart';
import 'local_data_source.dart';

/// Implementation of LocalDataSource that simulates local storage operations
/// In a real app, this would use SharedPreferences, SQLite, or Hive
class LocalDataSourceImpl implements LocalDataSource {
  // Simulated local storage
  static final Map<String, dynamic> _localStorage = {};
  
  // Cache expiration time (24 hours)
  static const Duration _cacheExpiration = Duration(hours: 24);
  
  // Cache key constants
  static const String _productsKey = 'cached_products';
  static const String _lastUpdatedKey = 'last_updated';
  static const String _cacheSizeKey = 'cache_size';

  @override
  Future<List<Product>> getAllProducts() async {
    // Simulate local storage delay
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (!_localStorage.containsKey(_productsKey)) {
      return []; // No cached products
    }
    
    try {
      final List<dynamic> jsonData = json.decode(_localStorage[_productsKey]);
      return jsonData.map((json) => Product.fromMap(json)).toList();
    } catch (e) {
      // If cache is corrupted, clear it
      await clearCache();
      return [];
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    final products = await getAllProducts();
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null; // Product not found
    }
  }

  @override
  Future<Product> saveProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 150));
    
    // Generate local ID if not provided
    final productToSave = product.id.isEmpty 
        ? product.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString())
        : product;
    
    final products = await getAllProducts();
    products.add(productToSave);
    await _saveProducts(products);
    
    return productToSave;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 150));
    
    final products = await getAllProducts();
    final index = products.indexWhere((p) => p.id == product.id);
    
    if (index == -1) {
      throw Exception('Product not found in local storage');
    }
    
    products[index] = product;
    await _saveProducts(products);
    
    return product;
  }

  @override
  Future<bool> deleteProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    final products = await getAllProducts();
    final initialLength = products.length;
    
    products.removeWhere((product) => product.id == id);
    
    if (products.length < initialLength) {
      await _saveProducts(products);
      return true;
    }
    
    return false; // Product not found
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 80));
    
    if (query.isEmpty) {
      return getAllProducts();
    }
    
    final products = await getAllProducts();
    final lowercaseQuery = query.toLowerCase();
    
    return products.where((product) {
      return product.name.toLowerCase().contains(lowercaseQuery) ||
             product.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 80));
    
    // For now, return all products (in real app, this would filter by category)
    return getAllProducts();
  }

  @override
  Future<void> cacheProducts(List<Product> products) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    await _saveProducts(products);
    
    // Update cache metadata
    _localStorage[_lastUpdatedKey] = DateTime.now().toIso8601String();
    _localStorage[_cacheSizeKey] = _calculateCacheSize(products);
  }

  @override
  Future<void> clearCache() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    _localStorage.clear();
  }

  @override
  Future<CacheInfo> getCacheInfo() async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    final products = await getAllProducts();
    final lastUpdated = _localStorage[_lastUpdatedKey];
    final cacheSize = _localStorage[_cacheSizeKey] ?? 0;
    
    DateTime? lastUpdatedTime;
    bool isExpired = true;
    
    if (lastUpdated != null) {
      try {
        lastUpdatedTime = DateTime.parse(lastUpdated);
        isExpired = DateTime.now().difference(lastUpdatedTime) > _cacheExpiration;
      } catch (e) {
        // Invalid date format
      }
    }
    
    return CacheInfo(
      totalProducts: products.length,
      lastUpdated: lastUpdatedTime ?? DateTime.now(),
      cacheSizeBytes: cacheSize,
      isExpired: isExpired,
    );
  }

  @override
  Future<bool> isLocalStorageAvailable() async {
    await Future.delayed(const Duration(milliseconds: 30));
    
    // Simulate storage availability (95% chance of being available)
    return Random().nextDouble() > 0.05;
  }

  /// Helper method to save products to local storage
  Future<void> _saveProducts(List<Product> products) async {
    final jsonData = products.map((product) => product.toMap()).toList();
    _localStorage[_productsKey] = json.encode(jsonData);
    
    // Update cache metadata
    _localStorage[_lastUpdatedKey] = DateTime.now().toIso8601String();
    _localStorage[_cacheSizeKey] = _calculateCacheSize(products);
  }

  /// Calculate approximate cache size in bytes
  int _calculateCacheSize(List<Product> products) {
    int size = 0;
    for (final product in products) {
      size += product.name.length;
      size += product.description.length;
      size += product.imageUrl.length;
      size += product.id.length;
      size += 8; // For price (double)
    }
    return size;
  }

  /// Real SharedPreferences implementation example (commented out for demo)
  Future<void> _realSharedPreferencesSave() async {
    // In a real implementation, you would use SharedPreferences:
    /*
    final prefs = await SharedPreferences.getInstance();
    final jsonData = products.map((product) => product.toMap()).toList();
    await prefs.setString(_productsKey, json.encode(jsonData));
    await prefs.setString(_lastUpdatedKey, DateTime.now().toIso8601String());
    await prefs.setInt(_cacheSizeKey, _calculateCacheSize(products));
    */
  }

  /// Real SQLite implementation example (commented out for demo)
  Future<void> _realSQLiteSave() async {
    // In a real implementation, you would use SQLite:
    /*
    final db = await openDatabase('products.db');
    await db.transaction((txn) async {
      for (final product in products) {
        await txn.insert(
          'products',
          product.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
    */
  }
} 