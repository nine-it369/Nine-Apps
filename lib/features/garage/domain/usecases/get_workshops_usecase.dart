import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/workshop_entity.dart';
import '../repositories/i_garage_repository.dart';

class GetWorkshopsUseCase implements UseCase<List<WorkshopEntity>, NoParams> {
  final IGarageRepository repository;

  GetWorkshopsUseCase(this.repository);

  @override
  Future<Either<Failure, List<WorkshopEntity>>> call(NoParams params) {
    return repository.getWorkshops();
  }
}
