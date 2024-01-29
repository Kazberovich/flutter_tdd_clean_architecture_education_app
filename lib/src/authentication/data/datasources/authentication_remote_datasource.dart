import 'package:tdd_education_app/core/enums/update_user.dart';
import 'package:tdd_education_app/src/authentication/data/models/user_model.dart';

abstract class AuthenticationRemoteDatasource {
  const AuthenticationRemoteDatasource();

  Future<void> forgotPassword(String email);

  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });

  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
}
