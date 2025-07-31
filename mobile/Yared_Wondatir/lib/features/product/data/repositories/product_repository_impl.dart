import '../../../../core/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/remote_data_source.dart';
import '../datasources/local_data_source.dart';

/// Implementation of ProductRepository that coordinates between
/// remote and local data sources following the repository pattern
class ProductRepositoryImpl implements ProductRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  const ProductRepositoryImpl({
    required RemoteDataSource remoteDataSource,
    required LocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      // First, try to get products from local cache
      final cachedProducts = await _localDataSource.getAllProducts();
      
      // Check if network is available
      final isNetworkAvailable = await _remoteDataSource.isNetworkAvailable();
      
      if (isNetworkAvailable) {
        try {
          // Try to get fresh data from remote source
          final remoteProducts = await _remoteDataSource.getAllProducts();
          
          // Cache the fresh data
          await _localDataSource.cacheProducts(remoteProducts);
          
          return remoteProducts;
        } catch (e) {
          // If remote fails, return cached data if available
          if (cachedProducts.isNotEmpty) {
            return cachedProducts;
          }
          rethrow; // Re-throw if no cached data available
        }
      } else {
        // Network not available, return cached data
        if (cachedProducts.isNotEmpty) {
          return cachedProducts;
        }
        throw Exception('No network connection and no cached data available');
      }
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      // First, try to get from local cache
      final cachedProduct = await _localDataSource.getProductById(id);
      
      // Check if network is available
      final isNetworkAvailable = await _remoteDataSource.isNetworkAvailable();
      
      if (isNetworkAvailable) {
        try {
          // Try to get fresh data from remote source
          final remoteProduct = await _remoteDataSource.getProductById(id);
          
          if (remoteProduct != null) {
            // Update local cache with fresh data
            await _localDataSource.updateProduct(remoteProduct);
            return remoteProduct;
          } else {
            // Product not found on remote, remove from cache if exists
            if (cachedProduct != null) {
              await _localDataSource.deleteProduct(id);
            }
            return null;
          }
        } catch (e) {
          // If remote fails, return cached data if available
          return cachedProduct;
        }
      } else {
        // Network not available, return cached data
        return cachedProduct;
      }
    } catch (e) {
      throw Exception('Failed to get product by ID: $e');
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    try {
      // Check if network is available
      final isNetworkAvailable = await _remoteDataSource.isNetworkAvailable();
      
      if (isNetworkAvailable) {
        try {
          // Create product on remote server
          final createdProduct = await _remoteDataSource.createProduct(product);
          
          // Cache the created product locally
          await _localDataSource.saveProduct(createdProduct);
          
          return createdProduct;
        } catch (e) {
          // If remote fails, save locally only
          return await _localDataSource.saveProduct(product);
        }
      } else {
        // Network not available, save locally only
        return await _localDataSource.saveProduct(product);
      }
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      // Check if network is available
      final isNetworkAvailable = await _remoteDataSource.isNetworkAvailable();
      
      if (isNetworkAvailable) {
        try {
          // Update product on remote server
          final updatedProduct = await _remoteDataSource.updateProduct(product);
          
          // Update local cache
          await _localDataSource.updateProduct(updatedProduct);
          
          return updatedProduct;
        } catch (e) {
          // If remote fails, update locally only
          return await _localDataSource.updateProduct(product);
        }
      } else {
        // Network not available, update locally only
        return await _localDataSource.updateProduct(product);
      }
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  @override
  Future<bool> deleteProduct(String id) async {
    try {
      // Check if network is available
      final isNetworkAvailable = await _remoteDataSource.isNetworkAvailable();
      
      if (isNetworkAvailable) {
        try {
          // Delete product from remote server
          final remoteDeleted = await _remoteDataSource.deleteProduct(id);
          
          if (remoteDeleted) {
            // Also delete from local cache
            await _localDataSource.deleteProduct(id);
          }
          
          return remoteDeleted;
        } catch (e) {
          // If remote fails, try to delete locally only
          return await _localDataSource.deleteProduct(id);
        }
      } else {
        // Network not available, delete locally only
        return await _localDataSource.deleteProduct(id);
      }
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    try {
      // Check if network is available
      final isNetworkAvailable = await _remoteDataSource.isNetworkAvailable();
      
      if (isNetworkAvailable) {
        try {
          // Search on remote server
          final remoteResults = await _remoteDataSource.searchProducts(query);
          
          // Cache the results locally
          await _localDataSource.cacheProducts(remoteResults);
          
          return remoteResults;
        } catch (e) {
          // If remote fails, search locally
          return await _localDataSource.searchProducts(query);
        }
      } else {
        // Network not available, search locally
        return await _localDataSource.searchProducts(query);
      }
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      // Check if network is available
      final isNetworkAvailable = await _remoteDataSource.isNetworkAvailable();
      
      if (isNetworkAvailable) {
        try {
          // Get products by category from remote server
          final remoteResults = await _remoteDataSource.getProductsByCategory(category);
          
          // Cache the results locally
          await _localDataSource.cacheProducts(remoteResults);
          
          return remoteResults;
        } catch (e) {
          // If remote fails, get from local cache
          return await _localDataSource.getProductsByCategory(category);
        }
      } else {
        // Network not available, get from local cache
        return await _localDataSource.getProductsByCategory(category);
      }
    } catch (e) {
      throw Exception('Failed to get products by category: $e');
    }
  }

  /// Get network information
  Future<NetworkInfo> getNetworkInfo() async {
    return await _remoteDataSource.getNetworkInfo();
  }

  /// Get cache information
  Future<CacheInfo> getCacheInfo() async {
    return await _localDataSource.getCacheInfo();
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    await _localDataSource.clearCache();
  }

  /// Force refresh data from remote source
  Future<List<Product>> refreshData() async {
    try {
      final remoteProducts = await _remoteDataSource.getAllProducts();
      await _localDataSource.cacheProducts(remoteProducts);
      return remoteProducts;
    } catch (e) {
      throw Exception('Failed to refresh data: $e');
    }
  }
} 