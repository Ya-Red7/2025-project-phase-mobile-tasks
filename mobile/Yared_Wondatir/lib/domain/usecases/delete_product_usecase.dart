import '../../features/product/domain/repositories/product_repository.dart';
import '../../core/entities/product.dart';
import 'base_usecase.dart';

class DeleteProductUseCase implements UseCase<bool, DeleteProductParams> {
  final ProductRepository repository;

  const DeleteProductUseCase(this.repository);

  @override
  Future<bool> call(DeleteProductParams params) async {
    return await repository.deleteProduct(params.id);
  }
}

class DeleteProductParams {
  final String id;
  const DeleteProductParams(this.id);
} 