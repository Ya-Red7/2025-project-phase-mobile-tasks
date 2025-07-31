# Test-Driven Development (TDD) Implementation Guide

This document outlines the TDD approach implemented for the eCommerce app's domain layer, following Clean Architecture principles.

## TDD Cycle: Red-Green-Refactor

### 1. **Red** - Write a failing test
### 2. **Green** - Write the minimum code to make the test pass
### 3. **Refactor** - Improve the code while keeping tests green

## Implementation Overview

### ✅ **Entities with TDD**

#### Product Entity Tests
```dart
// Test: should create a valid product
test('should create a valid product', () {
  const product = Product(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    imageUrl: 'assets/test.png',
    price: 99.99,
  );
  
  expect(product.id, '1');
  expect(product.name, 'Test Product');
  // ... more assertions
});
```

#### Validation Tests
```dart
// Test: should validate a valid product
test('should validate a valid product', () {
  const product = Product(/* valid data */);
  expect(product.isValid(), true);
});

// Test: should not validate an invalid product
test('should not validate an invalid product', () {
  const product = Product(/* invalid data */);
  expect(product.isValid(), false);
});
```

### ✅ **Use Cases with TDD**

#### ViewAllProductsUseCase Tests
```dart
// Test: should return list of products when repository call is successful
test('should return list of products when repository call is successful', () async {
  // Arrange
  final products = [/* test products */];
  when(mockRepository.getAllProducts()).thenAnswer((_) async => products);
  
  // Act
  final result = await viewAllProductsUseCase(const NoParams());
  
  // Assert
  expect(result, products);
  verify(mockRepository.getAllProducts()).called(1);
});
```

#### CRUD Operation Tests
```dart
// Create Product Test
test('should create product when repository call is successful', () async {
  // Arrange
  const newProduct = Product(/* test data */);
  when(mockRepository.createProduct(newProduct)).thenAnswer((_) async => createdProduct);
  
  // Act
  final result = await createProductUseCase(CreateProductParams(newProduct));
  
  // Assert
  expect(result, createdProduct);
});

// Update Product Test
test('should update product when repository call is successful', () async {
  // Arrange
  const updatedProduct = Product(/* test data */);
  when(mockRepository.updateProduct(updatedProduct)).thenAnswer((_) async => updatedProduct);
  
  // Act
  final result = await updateProductUseCase(UpdateProductParams(updatedProduct));
  
  // Assert
  expect(result, updatedProduct);
});

// Delete Product Test
test('should delete product when repository call is successful', () async {
  // Arrange
  when(mockRepository.deleteProduct('1')).thenAnswer((_) async => true);
  
  // Act
  final result = await deleteProductUseCase(const DeleteProductParams('1'));
  
  // Assert
  expect(result, true);
});
```

### ✅ **Repository Tests with TDD**

#### Repository Implementation Tests
```dart
// Test: should return list of products
test('should return list of products', () async {
  final products = await repository.getAllProducts();
  
  expect(products, isA<List<Product>>());
  expect(products.length, greaterThan(0));
});

// Test: should create product with generated id
test('should create product with generated id when id is empty', () async {
  const newProduct = Product(id: '', name: 'Test', /* ... */);
  
  final createdProduct = await repository.createProduct(newProduct);
  
  expect(createdProduct.id, isNotEmpty);
  expect(createdProduct.name, 'Test');
});
```

## TDD Best Practices Implemented

### 1. **Test Structure (AAA Pattern)**
```dart
test('should perform specific action', () {
  // Arrange - Set up test data and dependencies
  const testProduct = Product(/* test data */);
  
  // Act - Execute the method being tested
  final result = someMethod(testProduct);
  
  // Assert - Verify the expected outcome
  expect(result, expectedValue);
});
```

### 2. **Mocking Dependencies**
```dart
// Using Mockito for dependency mocking
@GenerateMocks([ProductRepository])
class MockProductRepository extends Mock implements ProductRepository {}

// In tests
when(mockRepository.getAllProducts()).thenAnswer((_) async => testProducts);
verify(mockRepository.getAllProducts()).called(1);
```

### 3. **Edge Case Testing**
```dart
// Test: should handle null values
test('should handle null values in fromMap', () {
  final map = <String, dynamic>{};
  final product = Product.fromMap(map);
  
  expect(product.id, '');
  expect(product.name, '');
});

// Test: should throw exception when operation fails
test('should throw exception when repository call fails', () async {
  when(mockRepository.getAllProducts()).thenThrow(Exception('Database error'));
  
  expect(
    () => viewAllProductsUseCase(const NoParams()),
    throwsA(isA<Exception>()),
  );
});
```

### 4. **Integration Testing**
```dart
// Test: should perform full CRUD cycle
test('should perform full CRUD cycle', () async {
  // Create
  final createdProduct = await repository.createProduct(newProduct);
  expect(createdProduct.id, isNotEmpty);
  
  // Read
  final retrievedProduct = await repository.getProductById(createdProduct.id);
  expect(retrievedProduct, isNotNull);
  
  // Update
  final updatedProduct = createdProduct.copyWith(name: 'Updated');
  final updateResult = await repository.updateProduct(updatedProduct);
  expect(updateResult.name, 'Updated');
  
  // Delete
  final deleteResult = await repository.deleteProduct(createdProduct.id);
  expect(deleteResult, true);
});
```

## Test Categories

### 1. **Unit Tests**
- Test individual components in isolation
- Mock all dependencies
- Fast execution
- Focus on business logic

### 2. **Integration Tests**
- Test component interactions
- Use real implementations where appropriate
- Verify data flow between layers

### 3. **Validation Tests**
- Test input validation
- Test error handling
- Test edge cases

## Running Tests

### Setup
```bash
# Add test dependencies to pubspec.yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.7

# Generate mocks
flutter packages pub run build_runner build
```

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/domain/entities/product_test.dart

# Run tests with coverage
flutter test --coverage
```

## TDD Benefits Achieved

### 1. **Confidence in Code**
- All business logic is tested
- Refactoring is safe
- Bugs are caught early

### 2. **Better Design**
- Tests drive good API design
- Dependencies are clearly defined
- Code is more modular

### 3. **Documentation**
- Tests serve as living documentation
- Examples of how to use the code
- Clear understanding of expected behavior

### 4. **Regression Prevention**
- Changes don't break existing functionality
- Continuous integration safety net
- Quick feedback on issues

## Test Coverage Goals

- **Entity Tests**: 100% coverage
- **Use Case Tests**: 100% coverage
- **Repository Tests**: 100% coverage
- **Integration Tests**: Critical paths covered

## Continuous Integration

### GitHub Actions Example
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter test --coverage
```

## Next Steps for TDD

1. **Add More Edge Cases**
   - Network failure scenarios
   - Invalid data handling
   - Performance edge cases

2. **Performance Testing**
   - Large dataset handling
   - Memory usage testing
   - Response time testing

3. **UI Testing**
   - Widget tests for UI components
   - Integration tests for user flows
   - Accessibility testing

4. **API Testing**
   - Real API integration tests
   - Mock API responses
   - Error handling scenarios

This TDD implementation provides a solid foundation for maintaining code quality and ensuring the reliability of the eCommerce app's domain layer. 