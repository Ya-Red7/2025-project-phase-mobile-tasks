# Architecture Documentation

## 🏗️ **Clean Architecture Implementation**

This document provides a detailed explanation of the Clean Architecture implementation in the eCommerce Flutter app.

## 📊 **Architecture Overview**

### **Clean Architecture Principles**

The app follows Clean Architecture principles as defined by Robert C. Martin, with clear separation of concerns and dependency inversion:

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                      │
│  (UI, Controllers, State Management)                      │
└─────────────────────────────────────────────────────────────┘
                              ↑
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                           │
│  (Entities, Use Cases, Repository Interfaces)             │
└─────────────────────────────────────────────────────────────┘
                              ↑
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                            │
│  (Models, Repository Implementations, Data Sources)       │
└─────────────────────────────────────────────────────────────┘
```

## 🏛️ **Layer Details**

### **1. Core Layer** (`lib/core/`)

The core layer contains shared components that are used across the entire application.

#### **Entities** (`lib/core/entities/`)
```dart
// Product entity - pure business object
class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  
  // Business logic methods
  bool isValid();
  List<String> getValidationErrors();
}
```

#### **Error Handling** (`lib/core/error/`)
```dart
// Base failure class
abstract class Failure extends Equatable {
  final String message;
  final String? code;
}

// Specific failure types
class ServerFailure extends Failure { }
class CacheFailure extends Failure { }
class NetworkFailure extends Failure { }
class ValidationFailure extends Failure { }
```

#### **Use Cases** (`lib/core/usecases/`)
```dart
// Base use case class
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// No parameters class
class NoParams {
  const NoParams();
}
```

### **2. Features Layer** (`lib/features/`)

Each feature is organized as a separate module with its own layers.

#### **Product Feature Structure**
```
lib/features/product/
├── data/                    # Data layer
│   ├── models/             # Data models
│   │   └── product_model.dart
│   ├── repositories/       # Repository implementations
│   └── datasources/        # Data sources
├── domain/                 # Domain layer
│   ├── entities/           # Domain entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business logic
└── presentation/           # Presentation layer
    ├── pages/              # UI pages
    ├── widgets/            # Reusable widgets
    └── controllers/        # State management
```

### **3. Data Models** (`lib/features/product/data/models/`)

Data models handle the conversion between domain entities and external data formats.

#### **ProductModel Implementation**
```dart
class ProductModel extends Product {
  // JSON conversion methods
  factory ProductModel.fromJson(String source);
  String toJson();
  
  // Map conversion methods
  factory ProductModel.fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap();
  
  // Entity conversion methods
  factory ProductModel.fromEntity(Product product);
  Product toEntity();
}
```

## 📊 **Data Flow Architecture**

### **Unidirectional Data Flow**

```
UI Action → Use Case → Repository → Data Source
     ↑                                    ↓
     └── State Update ← Entity ← Model ← JSON
```

### **Detailed Flow Example**

1. **User Action**: User taps "Add Product" button
2. **Presentation Layer**: UI triggers use case
3. **Domain Layer**: Use case validates business rules
4. **Data Layer**: Repository handles data operation
5. **Data Source**: API call or local storage
6. **Response**: Data flows back through layers
7. **UI Update**: State management updates UI

## 🧪 **Testing Architecture**

### **Test Structure**

```
test/
├── core/                          # Core tests
│   ├── entities/
│   ├── error/
│   └── usecases/
├── features/                      # Feature tests
│   └── product/
│       ├── data/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       └── presentation/
└── integration/                   # Integration tests
```

### **Testing Strategy**

#### **1. Unit Tests**
- Test individual components in isolation
- Mock all dependencies
- Focus on business logic

#### **2. Integration Tests**
- Test component interactions
- Use real implementations where appropriate
- Verify data flow between layers

#### **3. Model Tests**
- Test JSON serialization/deserialization
- Test entity-model conversions
- Test validation logic

## 🔧 **Dependency Injection**

### **Dependency Injection Pattern**

```dart
class DependencyInjection {
  static final DependencyInjection _instance = DependencyInjection._internal();
  factory DependencyInjection() => _instance;
  DependencyInjection._internal();

  // Repository
  late final ProductRepository _productRepository = ProductRepositoryImpl();

  // Use Cases
  late final ViewAllProductsUseCase viewAllProductsUseCase = 
      ViewAllProductsUseCase(_productRepository);
}
```

### **Benefits**
- **Centralized Management**: All dependencies in one place
- **Singleton Pattern**: Consistent state across app
- **Easy Testing**: Easy to swap implementations
- **Loose Coupling**: Components depend on abstractions

## 📊 **Error Handling Architecture**

### **Failure Classes**

```dart
// Base failure class
abstract class Failure extends Equatable {
  final String message;
  final String? code;
}

// Specific failure types
class ServerFailure extends Failure { }
class CacheFailure extends Failure { }
class NetworkFailure extends Failure { }
class ValidationFailure extends Failure { }
class NotFoundFailure extends Failure { }
class UnauthorizedFailure extends Failure { }
class ForbiddenFailure extends Failure { }
```

### **Error Handling Flow**

1. **Data Layer**: Catches exceptions and converts to failures
2. **Domain Layer**: Handles business logic errors
3. **Presentation Layer**: Displays user-friendly error messages

## 🏗️ **Repository Pattern**

### **Repository Interface**
```dart
abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<Product?> getProductById(String id);
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<bool> deleteProduct(String id);
}
```

### **Repository Implementation**
```dart
class ProductRepositoryImpl implements ProductRepository {
  // Implementation details
  @override
  Future<List<Product>> getAllProducts() async {
    // Data source interaction
  }
}
```

## 📊 **Use Case Pattern**

### **Use Case Implementation**
```dart
class ViewAllProductsUseCase implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  const ViewAllProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    try {
      final products = await repository.getAllProducts();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

## 🔄 **State Management**

### **State Management Pattern**

The app uses a simple state management pattern with `setState` for UI updates:

```dart
class _HomePageState extends State<HomePage> {
  List<Product> products = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    try {
      final result = await useCase(const NoParams());
      result.fold(
        (failure) => setState(() {
          errorMessage = failure.message;
          isLoading = false;
        }),
        (products) => setState(() {
          this.products = products;
          isLoading = false;
        }),
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }
}
```

## 📊 **Data Models vs Entities**

### **Entities (Domain Layer)**
- Pure business objects
- No dependencies on external frameworks
- Contain business logic
- Platform independent

### **Models (Data Layer)**
- Extend entities
- Handle data serialization
- Convert between formats
- Framework specific

### **Conversion Flow**
```
JSON ↔ Model ↔ Entity ↔ UI
```

## 🚀 **Scalability Considerations**

### **Adding New Features**

1. **Create Feature Module**: `lib/features/new_feature/`
2. **Implement Layers**: data, domain, presentation
3. **Add Dependencies**: Update dependency injection
4. **Write Tests**: Unit and integration tests
5. **Update Documentation**: Architecture and usage docs

### **Adding New Data Sources**

1. **Create Data Source**: Implement data source interface
2. **Update Repository**: Add new repository implementation
3. **Update DI**: Register new dependencies
4. **Write Tests**: Test new data source
5. **Update Models**: Add new model classes if needed

## 🔧 **Best Practices**

### **1. Separation of Concerns**
- Keep layers independent
- Don't mix business logic with UI
- Use interfaces for dependencies

### **2. Dependency Inversion**
- Depend on abstractions, not concretions
- Use dependency injection
- Make testing easier

### **3. Single Responsibility**
- Each class has one reason to change
- Keep methods small and focused
- Clear naming conventions

### **4. Testability**
- Write tests first (TDD)
- Mock external dependencies
- Test edge cases

### **5. Error Handling**
- Use failure classes consistently
- Provide meaningful error messages
- Handle errors gracefully

## 📊 **Performance Considerations**

### **1. Memory Management**
- Dispose of controllers properly
- Use const constructors where possible
- Avoid memory leaks

### **2. Network Optimization**
- Implement caching strategies
- Use pagination for large datasets
- Handle offline scenarios

### **3. UI Performance**
- Use efficient widgets
- Implement lazy loading
- Optimize rebuilds

## 🔮 **Future Enhancements**

### **1. State Management**
- Implement BLoC or Riverpod
- Add reactive programming
- Improve state synchronization

### **2. Caching**
- Add local storage
- Implement cache invalidation
- Add offline support

### **3. API Integration**
- Replace in-memory storage
- Add real API endpoints
- Implement authentication

### **4. Advanced Features**
- Add search and filtering
- Implement pagination
- Add real-time updates

This architecture provides a solid foundation for building scalable, maintainable, and testable Flutter applications following Clean Architecture principles. 