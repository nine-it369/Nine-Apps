import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/regency_entity.dart';
import '../repositories/i_garage_repository.dart';

class SearchRegenciesUseCase implements UseCase<List<RegencyEntity>, String> {
  final IGarageRepository repository;
  SearchRegenciesUseCase(this.repository);

  @override
  Future<Either<Failure, List<RegencyEntity>>> call(String query) {
    return repository.searchRegencies(query);
  }
}
