import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {
  const LoadProfileEvent();
}

class SubmitUpdateProfileEvent extends ProfileEvent {
  final String name;
  final String? email;

  const SubmitUpdateProfileEvent({required this.name, this.email});

  @override
  List<Object?> get props => [name, email];
}

class SubmitChangePasswordEvent extends ProfileEvent {
  final String oldPassword;
  final String newPassword;

  const SubmitChangePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}
