import '../../../../core/entities/product.dart';

/// Contract for remote data source operations
/// Defines methods for network-based product operations
abstract class RemoteDataSource {
  /// Get all products from the remote API
  /// Returns a list of products from the server
  Future<List<Product>> getAllProducts();

  /// Get a specific product by ID from the remote API
  /// Returns the product if found, null otherwise
  Future<Product?> getProductById(String id);

  /// Create a new product on the remote server
  /// Returns the created product with server-generated ID
  Future<Product> createProduct(Product product);

  /// Update an existing product on the remote server
  /// Returns the updated product
  Future<Product> updateProduct(Product product);

  /// Delete a product from the remote server
  /// Returns true if deletion was successful, false otherwise
  Future<bool> deleteProduct(String id);

  /// Search products on the remote server
  /// Returns a list of products matching the search criteria
  Future<List<Product>> searchProducts(String query);

  /// Get products by category from the remote server
  /// Returns a list of products in the specified category
  Future<List<Product>> getProductsByCategory(String category);

  /// Check network connectivity
  /// Returns true if network is available, false otherwise
  Future<bool> isNetworkAvailable();

  /// Get network information
  /// Returns network status and connection type
  Future<NetworkInfo> getNetworkInfo();
}

/// Network information model
class NetworkInfo {
  final bool isConnected;
  final String connectionType;
  final int responseTime;

  const NetworkInfo({
    required this.isConnected,
    required this.connectionType,
    required this.responseTime,
  });

  @override
  String toString() {
    return 'NetworkInfo(isConnected: $isConnected, connectionType: $connectionType, responseTime: ${responseTime}ms)';
  }
} 