import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/package_entity.dart';
import '../repositories/i_garage_repository.dart';

class GetPackagesUseCase implements UseCase<List<PackageEntity>, NoParams> {
  final IGarageRepository repository;
  GetPackagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<PackageEntity>>> call(NoParams params) {
    return repository.getPackages();
  }
}
