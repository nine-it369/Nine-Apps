import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/mall_entities.dart';

abstract class IMallRepository {
  Future<Either<Failure, List<MallCarouselEntity>>> getCarousels();
  Future<Either<Failure, List<MallCategoryEntity>>> getCategories();
  Future<Either<Failure, List<MallProductEntity>>> getVariants({
    int? categoryId,
    String? search,
    int limit = 20,
    int page = 1,
  });
}
