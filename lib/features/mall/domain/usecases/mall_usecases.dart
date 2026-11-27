import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/mall_entities.dart';
import '../repositories/i_mall_repository.dart';

class GetMallHomeDataUseCase implements UseCase<MallHomeData, NoParams> {
  final IMallRepository repository;

  GetMallHomeDataUseCase(this.repository);

  @override
  Future<Either<Failure, MallHomeData>> call(NoParams params) async {
    final carouselsResult = await repository.getCarousels();
    final categoriesResult = await repository.getCategories();
    final productsResult = await repository.getVariants(limit: 20);

    return productsResult.fold(
      (failure) => Either.left(failure),
      (products) {
        final carousels = carouselsResult.fold((l) => <MallCarouselEntity>[], (r) => r);
        final categories = categoriesResult.fold((l) => <MallCategoryEntity>[], (r) => r);

        return Either.right(
          MallHomeData(
            carousels: carousels,
            categories: categories,
            products: products,
          ),
        );
      },
    );
  }
}

class MallHomeData {
  final List<MallCarouselEntity> carousels;
  final List<MallCategoryEntity> categories;
  final List<MallProductEntity> products;

  const MallHomeData({
    required this.carousels,
    required this.categories,
    required this.products,
  });
}
