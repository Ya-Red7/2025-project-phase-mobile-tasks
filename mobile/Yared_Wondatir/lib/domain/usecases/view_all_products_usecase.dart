import '../../features/product/domain/repositories/product_repository.dart';
import '../../core/entities/product.dart';
import 'base_usecase.dart';

class ViewAllProductsUseCase implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  const ViewAllProductsUseCase(this.repository);

  @override
  Future<List<Product>> call(NoParams params) async {
    return await repository.getAllProducts();
  }
} 