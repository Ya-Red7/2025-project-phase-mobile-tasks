import '../../features/product/domain/repositories/product_repository.dart';
import '../../core/entities/product.dart';
import 'base_usecase.dart';

class CreateProductUseCase implements UseCase<Product, CreateProductParams> {
  final ProductRepository repository;

  const CreateProductUseCase(this.repository);

  @override
  Future<Product> call(CreateProductParams params) async {
    return await repository.createProduct(params.product);
  }
}

class CreateProductParams {
  final Product product;
  const CreateProductParams(this.product);
} 