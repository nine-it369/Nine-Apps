import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../garage/domain/entities/voucher_entity.dart';
import '../repositories/i_profile_repository.dart';

class GetProfileUseCase implements UseCase<UserEntity, NoParams> {
  final IProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return repository.getProfile();
  }
}

class UpdateProfileUseCase implements UseCase<UserEntity, UpdateProfileParams> {
  final IProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) {
    return repository.updateProfile(name: params.name, email: params.email);
  }
}

class UpdateProfileParams {
  final String name;
  final String? email;

  const UpdateProfileParams({required this.name, this.email});
}

class ChangePasswordUseCase implements UseCase<void, ChangePasswordParams> {
  final IProfileRepository repository;

  ChangePasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) {
    return repository.changePassword(
      oldPassword: params.oldPassword,
      newPassword: params.newPassword,
    );
  }
}

class ChangePasswordParams {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.oldPassword,
    required this.newPassword,
  });
}

class GetCustomerVouchersUseCase implements UseCase<List<VoucherEntity>, NoParams> {
  final IProfileRepository repository;

  GetCustomerVouchersUseCase(this.repository);

  @override
  Future<Either<Failure, List<VoucherEntity>>> call(NoParams params) {
    return repository.getCustomerVouchers();
  }
}
