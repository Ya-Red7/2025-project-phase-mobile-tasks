import '../../../../core/entities/product.dart';

/// Contract for local data source operations
/// Defines methods for local storage-based product operations
abstract class LocalDataSource {
  /// Get all products from local storage
  /// Returns a list of products stored locally
  Future<List<Product>> getAllProducts();

  /// Get a specific product by ID from local storage
  /// Returns the product if found, null otherwise
  Future<Product?> getProductById(String id);

  /// Save a new product to local storage
  /// Returns the saved product with local ID
  Future<Product> saveProduct(Product product);

  /// Update an existing product in local storage
  /// Returns the updated product
  Future<Product> updateProduct(Product product);

  /// Delete a product from local storage
  /// Returns true if deletion was successful, false otherwise
  Future<bool> deleteProduct(String id);

  /// Search products in local storage
  /// Returns a list of products matching the search criteria
  Future<List<Product>> searchProducts(String query);

  /// Get products by category from local storage
  /// Returns a list of products in the specified category
  Future<List<Product>> getProductsByCategory(String category);

  /// Cache products from remote source
  /// Stores the provided products in local storage
  Future<void> cacheProducts(List<Product> products);

  /// Clear all cached products
  /// Removes all products from local storage
  Future<void> clearCache();

  /// Get cache information
  /// Returns information about cached data
  Future<CacheInfo> getCacheInfo();

  /// Check if local storage is available
  /// Returns true if local storage is accessible, false otherwise
  Future<bool> isLocalStorageAvailable();
}

/// Cache information model
class CacheInfo {
  final int totalProducts;
  final DateTime lastUpdated;
  final int cacheSizeBytes;
  final bool isExpired;

  const CacheInfo({
    required this.totalProducts,
    required this.lastUpdated,
    required this.cacheSizeBytes,
    required this.isExpired,
  });

  @override
  String toString() {
    return 'CacheInfo(totalProducts: $totalProducts, lastUpdated: $lastUpdated, cacheSizeBytes: $cacheSizeBytes, isExpired: $isExpired)';
  }
} 