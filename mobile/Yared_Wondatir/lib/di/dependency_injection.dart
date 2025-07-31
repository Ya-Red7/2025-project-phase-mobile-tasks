import '../features/product/data/datasources/remote_data_source.dart';
import '../features/product/data/datasources/remote_data_source_impl.dart';
import '../features/product/data/datasources/local_data_source.dart';
import '../features/product/data/datasources/local_data_source_impl.dart';
import '../features/product/data/repositories/product_repository_impl.dart';
import '../features/product/domain/repositories/product_repository.dart';
import '../domain/usecases/view_all_products_usecase.dart';
import '../domain/usecases/view_product_usecase.dart';
import '../domain/usecases/create_product_usecase.dart';
import '../domain/usecases/update_product_usecase.dart';
import '../domain/usecases/delete_product_usecase.dart';

/// Dependency Injection container that manages all dependencies
/// Uses singleton pattern to ensure consistent state across the app
class DependencyInjection {
  static final DependencyInjection _instance = DependencyInjection._internal();
  factory DependencyInjection() => _instance;
  DependencyInjection._internal();

  // Data Sources
  late final RemoteDataSource _remoteDataSource = RemoteDataSourceImpl();
  late final LocalDataSource _localDataSource = LocalDataSourceImpl();

  // Repository
  late final ProductRepository _productRepository = ProductRepositoryImpl(
    remoteDataSource: _remoteDataSource,
    localDataSource: _localDataSource,
  );

  // Use Cases
  late final ViewAllProductsUseCase viewAllProductsUseCase =
      ViewAllProductsUseCase(_productRepository);
  late final ViewProductUseCase viewProductUseCase =
      ViewProductUseCase(_productRepository);
  late final CreateProductUseCase createProductUseCase =
      CreateProductUseCase(_productRepository);
  late final UpdateProductUseCase updateProductUseCase =
      UpdateProductUseCase(_productRepository);
  late final DeleteProductUseCase deleteProductUseCase =
      DeleteProductUseCase(_productRepository);

  /// Get the product repository instance
  ProductRepository get productRepository => _productRepository;

  /// Get the remote data source instance
  RemoteDataSource get remoteDataSource => _remoteDataSource;

  /// Get the local data source instance
  LocalDataSource get localDataSource => _localDataSource;

  /// Get all use cases
  Map<String, dynamic> get useCases => {
    'viewAllProducts': viewAllProductsUseCase,
    'viewProduct': viewProductUseCase,
    'createProduct': createProductUseCase,
    'updateProduct': updateProductUseCase,
    'deleteProduct': deleteProductUseCase,
  };

  /// Initialize all dependencies
  Future<void> initialize() async {
    // This method can be used to initialize any dependencies
    // that require async setup
    print('DependencyInjection initialized successfully');
  }

  /// Dispose all dependencies (for cleanup)
  void dispose() {
    // This method can be used to dispose any resources
    // that need cleanup
    print('DependencyInjection disposed');
  }
} 