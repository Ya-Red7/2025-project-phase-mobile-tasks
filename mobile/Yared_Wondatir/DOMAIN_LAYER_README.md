# Domain Layer Implementation for eCommerce App

This document outlines the domain layer refactoring implemented for the eCommerce app, following Clean Architecture principles.

## Overview

The domain layer has been successfully implemented with the following components:

### 1. Entities
- **Product**: Represents a single eCommerce product with the following properties:
  - `id`: Unique identifier
  - `name`: Product name
  - `description`: Product description
  - `imageUrl`: URL/path to product image
  - `price`: Product price as double

### 2. Use Cases (Callable Classes)

All use cases implement the `UseCase<Type, Params>` interface and follow the callable class pattern:

#### a. ViewAllProductsUseCase
- **Purpose**: Retrieves all products from the repository
- **Parameters**: `NoParams` (no parameters required)
- **Returns**: `Future<List<Product>>`
- **Usage**: `await viewAllProductsUseCase(const NoParams())`

#### b. ViewProductUseCase
- **Purpose**: Retrieves a specific product by ID
- **Parameters**: `ViewProductParams(id: String)`
- **Returns**: `Future<Product?>`
- **Usage**: `await viewProductUseCase(ViewProductParams('1'))`

#### c. CreateProductUseCase
- **Purpose**: Creates a new product
- **Parameters**: `CreateProductParams(product: Product)`
- **Returns**: `Future<Product>`
- **Usage**: `await createProductUseCase(CreateProductParams(product))`

#### d. UpdateProductUseCase
- **Purpose**: Updates an existing product
- **Parameters**: `UpdateProductParams(product: Product)`
- **Returns**: `Future<Product>`
- **Usage**: `await updateProductUseCase(UpdateProductParams(product))`

#### e. DeleteProductUseCase
- **Purpose**: Deletes a product by ID
- **Parameters**: `DeleteProductParams(id: String)`
- **Returns**: `Future<bool>`
- **Usage**: `await deleteProductUseCase(DeleteProductParams('1'))`

### 3. Repository Interface

**ProductRepository** defines the contract for data operations:
```dart
abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<Product?> getProductById(String id);
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<bool> deleteProduct(String id);
}
```

### 4. Repository Implementation

**ProductRepositoryImpl** provides the concrete implementation with in-memory storage:
- Simulates network delays for realistic behavior
- Maintains a static list of products
- Handles CRUD operations with proper error handling
- Generates unique IDs for new products

### 5. Dependency Injection

**DependencyInjection** manages all use cases and repository instances:
- Singleton pattern for consistent state
- Centralized dependency management
- Easy access to all use cases

## File Structure

```
lib/
├── domain/
│   ├── entities/
│   │   └── product.dart
│   ├── repositories/
│   │   └── product_repository.dart
│   └── usecases/
│       ├── base_usecase.dart
│       ├── view_all_products_usecase.dart
│       ├── view_product_usecase.dart
│       ├── create_product_usecase.dart
│       ├── update_product_usecase.dart
│       └── delete_product_usecase.dart
├── data/
│   └── repositories/
│       └── product_repository_impl.dart
├── di/
│   └── dependency_injection.dart
└── [existing UI files updated to use domain layer]
```

## Updated UI Components

### HomePage
- Now uses `ViewAllProductsUseCase` to load products
- Displays loading states and error handling
- Shows product information from domain entities
- Handles product updates and deletions

### DetailsPage
- Uses `DeleteProductUseCase` for product deletion
- Displays product details from domain entities
- Handles product updates through navigation

### AddUpdateSearchPage
- Uses `CreateProductUseCase` and `UpdateProductUseCase`
- Form validation and error handling
- Supports all product properties (name, description, price, imageUrl)

## Key Features Implemented

1. **Clean Architecture**: Clear separation between domain, data, and presentation layers
2. **Callable Classes**: All use cases implement the callable pattern for consistent API
3. **Error Handling**: Proper error handling throughout the domain layer
4. **Dependency Injection**: Centralized dependency management
5. **Type Safety**: Strong typing with proper parameter classes
6. **Testability**: Domain layer is easily testable with mock repositories
7. **Scalability**: Easy to extend with new use cases and entities

## Usage Examples

### Loading Products
```dart
final di = DependencyInjection();
final products = await di.viewAllProductsUseCase(const NoParams());
```

### Creating a Product
```dart
final product = Product(
  id: '',
  name: 'New Product',
  description: 'Product description',
  imageUrl: 'assets/image.png',
  price: 99.99,
);
final createdProduct = await di.createProductUseCase(CreateProductParams(product));
```

### Updating a Product
```dart
final updatedProduct = existingProduct.copyWith(name: 'Updated Name');
final result = await di.updateProductUseCase(UpdateProductParams(updatedProduct));
```

### Deleting a Product
```dart
final success = await di.deleteProductUseCase(DeleteProductParams('product_id'));
```

## Benefits of This Implementation

1. **Maintainability**: Clear separation of concerns makes code easier to maintain
2. **Testability**: Domain logic can be tested independently of UI
3. **Flexibility**: Easy to swap implementations (e.g., switch from in-memory to API)
4. **Consistency**: All use cases follow the same pattern
5. **Type Safety**: Compile-time checking prevents runtime errors
6. **Documentation**: Self-documenting code with clear interfaces

## Next Steps

The domain layer is now ready for:
- Integration with real API endpoints
- Unit testing with mock repositories
- Adding more complex business logic
- Implementing caching strategies
- Adding validation rules

This implementation provides a solid foundation for a scalable eCommerce application following Clean Architecture principles. 