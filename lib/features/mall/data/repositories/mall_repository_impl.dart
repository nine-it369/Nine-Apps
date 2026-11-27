import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/mall_entities.dart';
import '../../domain/repositories/i_mall_repository.dart';
import '../datasources/mall_remote_datasource.dart';

class MallRepositoryImpl implements IMallRepository {
  final IMallRemoteDataSource remoteDataSource;

  MallRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MallCarouselEntity>>> getCarousels() async {
    try {
      final result = await remoteDataSource.getCarousels();
      return Either.right(result);
    } catch (e) {
      // Fallback with official Directus asset banner
      return Either.right([
        const MallCarouselEntity(
          batchName: 'banner-home',
          imageUrl: 'https://directus.nine.co.id/assets/e9ce0a22-ed0c-4f67-9a29-9698e7b9afcb',
        ),
      ]);
    }
  }

  @override
  Future<Either<Failure, List<MallCategoryEntity>>> getCategories() async {
    try {
      final result = await remoteDataSource.getCategories();
      return Either.right(result);
    } catch (e) {
      return Either.right([
        const MallCategoryEntity(id: 1, name: 'Headlight', slug: 'headlight'),
        const MallCategoryEntity(id: 2, name: 'Shooting Light', slug: 'shooting_light'),
        const MallCategoryEntity(id: 13, name: 'Biled', slug: 'biled'),
        const MallCategoryEntity(id: 17, name: 'DRL', slug: 'drl'),
      ]);
    }
  }

  @override
  Future<Either<Failure, List<MallProductEntity>>> getVariants({
    int? categoryId,
    String? search,
    int limit = 20,
    int page = 1,
  }) async {
    try {
      final result = await remoteDataSource.getVariants(
        categoryId: categoryId,
        search: search,
        limit: limit,
        page: page,
      );
      return Either.right(result);
    } catch (e) {
      if (e is ServerException) {
        return Either.left(ServerFailure(e.message, e.statusCode));
      }
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
