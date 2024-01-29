import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

class AuthenticationRemoteDataSourceImplementation
    implements AuthenticationRemoteDatasource {
  const AuthenticationRemoteDataSourceImplementation(
      this._authClient, this._cloudStoreClient, this._dbClient);

  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;

  @override
  Future<void> forgotPassword(String email) async {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<LocalUserModel> signIn(
      {required String email, required String password}) async {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<void> signUp(
      {required String email,
      required String fullName,
      required String password}) async {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(
      {required UpdateUserAction action, required dynamic userData}) async {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
