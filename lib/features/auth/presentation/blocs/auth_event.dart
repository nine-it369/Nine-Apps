import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthSessionEvent extends AuthEvent {
  const CheckAuthSessionEvent();
}

class LoginWithPhonePasswordEvent extends AuthEvent {
  final String phone;
  final String password;

  const LoginWithPhonePasswordEvent({
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [phone, password];
}

class RegisterCustomerEvent extends AuthEvent {
  final String name;
  final String phone;
  final String password;

  const RegisterCustomerEvent({
    required this.name,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [name, phone, password];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}
