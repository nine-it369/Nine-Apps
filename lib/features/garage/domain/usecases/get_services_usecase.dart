import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/service_entity.dart';
import '../repositories/i_garage_repository.dart';

class GetServicesParams {
  final String? vehicleType;
  const GetServicesParams({this.vehicleType});
}

class GetServicesUseCase implements UseCase<List<ServiceEntity>, GetServicesParams> {
  final IGarageRepository repository;

  GetServicesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ServiceEntity>>> call(GetServicesParams params) {
    return repository.getServices(vehicleType: params.vehicleType);
  }
}
