import '../../features/product/domain/repositories/product_repository.dart';
import '../../core/entities/product.dart';
import 'base_usecase.dart';

class ViewProductUseCase implements UseCase<Product?, ViewProductParams> {
  final ProductRepository repository;

  const ViewProductUseCase(this.repository);

  @override
  Future<Product?> call(ViewProductParams params) async {
    return await repository.getProductById(params.id);
  }
}

class ViewProductParams {
  final String id;
  const ViewProductParams(this.id);
} 