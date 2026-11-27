import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';

abstract class IAuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String phone,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String phone,
    required String password,
  });

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, void>> logout();
}
