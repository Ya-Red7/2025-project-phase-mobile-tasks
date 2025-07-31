import '../../../../core/entities/product.dart';

/// Contract that defines the methods a repository must fulfill
/// This interface ensures that any repository implementation
/// must provide these specific methods for product operations
abstract class ProductRepository {
  /// Get all products from the data source
  /// Returns a list of products or throws an exception
  Future<List<Product>> getAllProducts();

  /// Get a specific product by its ID
  /// Returns the product if found, null otherwise
  Future<Product?> getProductById(String id);

  /// Create a new product
  /// Returns the created product with generated ID
  Future<Product> createProduct(Product product);

  /// Update an existing product
  /// Returns the updated product
  Future<Product> updateProduct(Product product);

  /// Delete a product by its ID
  /// Returns true if deletion was successful, false otherwise
  Future<bool> deleteProduct(String id);

  /// Search products by name or description
  /// Returns a list of products matching the search criteria
  Future<List<Product>> searchProducts(String query);

  /// Get products by category (for future use)
  /// Returns a list of products in the specified category
  Future<List<Product>> getProductsByCategory(String category);
} 