import 'package:flutter/material.dart';
import 'core/entities/product.dart';
import 'di/dependency_injection.dart';
import 'domain/usecases/view_all_products_usecase.dart';
import 'domain/usecases/delete_product_usecase.dart';
import 'domain/usecases/base_usecase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];
  bool isLoading = true;
  String? errorMessage;

  final TextEditingController searchController = TextEditingController();
  bool showSearchBar = false;

  late final ViewAllProductsUseCase _viewAllProductsUseCase;
  late final DeleteProductUseCase _deleteProductUseCase;

  @override
  void initState() {
    super.initState();
    final di = DependencyInjection();
    _viewAllProductsUseCase = di.viewAllProductsUseCase;
    _deleteProductUseCase = di.deleteProductUseCase;
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      
      final productsList = await _viewAllProductsUseCase(const NoParams());
      
      setState(() {
        products = productsList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load products: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'July 14, 2023',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Hello, Yohannes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Icon(Icons.notifications_none, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Show search bar if toggled, else show header row with search button
              showSearchBar
                  ? Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: searchController,
                                    decoration: const InputDecoration(
                                      hintText: 'Search Product',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    // Implement search logic here
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.filter_alt,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // Implement filter logic here
                            },
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Available Products',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              showSearchBar = true;
                            });
                          },
                        ),
                      ],
                    ),
              const SizedBox(height: 24),
              if (!showSearchBar) const SizedBox(height: 12),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _loadProducts,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : products.isEmpty
                            ? const Center(
                                child: Text(
                                  'No products available',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : ListView.separated(
                                itemCount: products.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  return GestureDetector(
                                    onTap: () async {
                                      final result = await Navigator.pushNamed(
                                        context,
                                        '/details',
                                        arguments: {'product': product, 'index': index},
                                      );
                                      if (result == 'deleted') {
                                        setState(() {
                                          products.removeAt(index);
                                        });
                                      } else if (result is Product) {
                                        setState(() {
                                          products[index] = result;
                                        });
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          ClipRRect(
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16),
                                            ),
                                            child: Image.asset(
                                              product.imageUrl,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        product.name,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        product.description,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        children: const [
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(0xFFFFC107),
                                                            size: 16,
                                                          ),
                                                          SizedBox(width: 4),
                                                          Text(
                                                            '4.0',
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '\$${product.price.toStringAsFixed(2)}',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newProduct = await Navigator.pushNamed(context, '/add_edit');
          if (newProduct is Product) {
            setState(() {
              products.add(newProduct);
            });
          }
        },
        backgroundColor: const Color(0xFF3B5AFB),
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Replace with your search result UI
    return Center(child: Text('Results for "$query"'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Replace with your search suggestions UI
    return Center(child: Text('Suggestions for "$query"'));
  }
}
