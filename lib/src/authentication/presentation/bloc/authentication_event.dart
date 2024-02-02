part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class SignInEvent extends AuthenticationEvent {
  const SignInEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class SignUpEvent extends AuthenticationEvent {
  const SignUpEvent({
    required this.email,
    required this.password,
    required this.name,
  });

  final String email;
  final String password;
  final String name;

  @override
  List<Object?> get props => [email, password];
}

class ForgotPasswordEvent extends AuthenticationEvent {
  const ForgotPasswordEvent({
    required this.email,
  });

  final String email;

  @override
  List<Object?> get props => [email];
}

class UpdateUserEvent extends AuthenticationEvent {
  UpdateUserEvent({required this.action, required this.userData})
      : assert(
          userData is String || userData is File,
          'userData must be either a String or a File,'
              ' but was ${userData.runtimeType}',
        );

  final UpdateUserAction action;
  final dynamic userData;

  @override
  List<Object?> get props => [action, userData];
}
