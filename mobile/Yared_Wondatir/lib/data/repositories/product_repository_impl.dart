import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  static final List<Product> _products = [
    const Product(
      id: '1',
      name: 'Derby Leather Shoes',
      description: "Men's premium leather derby shoes with classic design",
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
      price: 149.99,
    ),
  ];

  @override
  Future<List<Product>> getAllProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_products);
  }

  @override
  Future<Product?> getProductById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Generate a new ID if not provided
    final newProduct = product.id.isEmpty 
        ? product.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString())
        : product;
    
    _products.add(newProduct);
    return newProduct;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      return product;
    } else {
      throw Exception('Product not found');
    }
  }

  @override
  Future<bool> deleteProduct(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _products.indexWhere((product) => product.id == id);
    if (index != -1) {
      _products.removeAt(index);
      return true;
    }
    return false;
  }
} 