import '../../features/product/domain/repositories/product_repository.dart';
import '../../core/entities/product.dart';
import 'base_usecase.dart';

class UpdateProductUseCase implements UseCase<Product, UpdateProductParams> {
  final ProductRepository repository;

  const UpdateProductUseCase(this.repository);

  @override
  Future<Product> call(UpdateProductParams params) async {
    return await repository.updateProduct(params.product);
  }
}

class UpdateProductParams {
  final Product product;
  const UpdateProductParams(this.product);
} 