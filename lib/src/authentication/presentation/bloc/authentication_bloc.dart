import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_education_app/core/enums/update_user.dart';
import 'package:tdd_education_app/src/authentication/domain/entities/user.dart';
import 'package:tdd_education_app/src/authentication/domain/usecases/forgot_password.dart';
import 'package:tdd_education_app/src/authentication/domain/usecases/sign_in.dart';
import 'package:tdd_education_app/src/authentication/domain/usecases/sign_up.dart';
import 'package:tdd_education_app/src/authentication/domain/usecases/update_user.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required SignInUsecase signInUsecase,
    required SignUpUsecase signUpUsecase,
    required ForgotPasswordUsecase forgotPasswordUsecase,
    required UpdateUserUsecase updateUserUsecase,
  })  : _signInUsecase = signInUsecase,
        _signUpUsecase = signUpUsecase,
        _forgotPasswordUsecase = forgotPasswordUsecase,
        _updateUserUsecase = updateUserUsecase,
        super(const AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) {
      emit(const AuthenticationLoading());
    });
    on<SignInEvent>(_signInHandler);
  }

  final SignInUsecase _signInUsecase;
  final SignUpUsecase _signUpUsecase;
  final UpdateUserUsecase _updateUserUsecase;
  final ForgotPasswordUsecase _forgotPasswordUsecase;

  Future<void> _signInHandler(
    SignInEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final result = await _signInUsecase(
      SignInParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => null,
      (user) => emit(SignedIn(user)),
    );
  }
}
