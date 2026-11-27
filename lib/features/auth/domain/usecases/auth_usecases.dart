import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final IAuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.login(phone: params.phone, password: params.password);
  }
}

class LoginParams {
  final String phone;
  final String password;

  const LoginParams({required this.phone, required this.password});
}

class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final IAuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return repository.register(
      name: params.name,
      phone: params.phone,
      password: params.password,
    );
  }
}

class RegisterParams {
  final String name;
  final String phone;
  final String password;

  const RegisterParams({
    required this.name,
    required this.phone,
    required this.password,
  });
}

class GetCurrentUserUseCase implements UseCase<UserEntity?, NoParams> {
  final IAuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}

class LogoutUseCase implements UseCase<void, NoParams> {
  final IAuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.logout();
  }
}
