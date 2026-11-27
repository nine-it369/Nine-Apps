import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/profile_usecases.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final GetCustomerVouchersUseCase getCustomerVouchersUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
    required this.getCustomerVouchersUseCase,
  }) : super(const ProfileState()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<SubmitUpdateProfileEvent>(_onUpdateProfile);
    on<SubmitChangePasswordEvent>(_onChangePassword);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final profileResult = await getProfileUseCase(const NoParams());
    final vouchersResult = await getCustomerVouchersUseCase(const NoParams());

    profileResult.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: failure.message,
      )),
      (user) {
        final vouchers = vouchersResult.fold((l) => state.vouchers, (r) => r);
        emit(state.copyWith(
          status: ProfileStatus.loaded,
          user: user,
          vouchers: vouchers,
        ));
      },
    );
  }

  Future<void> _onUpdateProfile(
    SubmitUpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading, errorMessage: null));
    final result = await updateProfileUseCase(
      UpdateProfileParams(name: event.name, email: event.email),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: failure.message,
      )),
      (updatedUser) => emit(state.copyWith(
        status: ProfileStatus.success,
        user: updatedUser,
        successMessage: 'Profil berhasil diperbarui.',
      )),
    );
  }

  Future<void> _onChangePassword(
    SubmitChangePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading, errorMessage: null));
    final result = await changePasswordUseCase(
      ChangePasswordParams(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: ProfileStatus.success,
        successMessage: 'Kata sandi berhasil diperbarui.',
      )),
    );
  }
}
