import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/variant_entity.dart';
import '../repositories/i_garage_repository.dart';

class GetVariantsParams {
  final int? workshopId;
  final int? categoryId;
  final String? search;
  final String? vehicleType;
  final bool? isEv;
  final int? page;
  final int? limit;

  const GetVariantsParams({
    this.workshopId,
    this.categoryId,
    this.search,
    this.vehicleType,
    this.isEv,
    this.page,
    this.limit,
  });
}

class GetVariantsUseCase implements UseCase<List<VariantEntity>, GetVariantsParams> {
  final IGarageRepository repository;

  GetVariantsUseCase(this.repository);

  @override
  Future<Either<Failure, List<VariantEntity>>> call(GetVariantsParams params) {
    return repository.getVariants(
      workshopId: params.workshopId,
      categoryId: params.categoryId,
      search: params.search,
      vehicleType: params.vehicleType,
      isEv: params.isEv,
      page: params.page,
      limit: params.limit,
    );
  }
}
