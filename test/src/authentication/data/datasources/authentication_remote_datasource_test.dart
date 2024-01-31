import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/core/errors/exceptions.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:tdd_education_app/src/authentication/data/models/user_model.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  String _uid = 'Test uid';

  @override
  String get uid => _uid;

  set uid(String value) {
    if (_uid != value) _uid = value;
  }
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;
  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

void main() {
  late FirebaseAuth authClient;
  late FirebaseFirestore cloudStoreClient;
  late FirebaseStorage dbClient;
  late AuthenticationRemoteDatasource datasource;
  late MockUser mockUser;
  late UserCredential userCredential;
  late DocumentReference<DataMap> documentReference;
  const tUser = LocalUserModel.empty();

  setUpAll(() async {
    authClient = MockFirebaseAuth();
    cloudStoreClient = FakeFirebaseFirestore();
    documentReference =
        await cloudStoreClient.collection('users').add(tUser.toMap());

    mockUser = MockUser().._uid = documentReference.id;
    dbClient = MockFirebaseStorage();
    userCredential = MockUserCredential(mockUser);
    datasource = AuthenticationRemoteDataSourceImplementation(
      authClient,
      cloudStoreClient,
      dbClient,
    );

    when(() => authClient.currentUser).thenReturn(mockUser);
  });

  const tPassword = 'Test Password';
  const tFullName = 'Test Full Name';
  const tEmail = 'testemail@mail.org';

  final tFirebaseAuthException = FirebaseAuthException(
    code: 'user-not-found',
    message: 'There is no user record corresponding to this identifier. '
        'The user may have been deleted.',
  );

  group('forgotPassword', () {
    test('should complete successfully when no [Exception] is thrown',
        () async {
      when(() => authClient.sendPasswordResetEmail(email: any(named: 'email')))
          .thenAnswer((_) => Future.value());

      final call = datasource.forgotPassword(tEmail);

      expect(call, completes);

      verify(() => authClient.sendPasswordResetEmail(email: tEmail)).called(1);
      verifyNoMoreInteractions(authClient);
    });

    test(
        'should throw [ServerException] when [FirebaseAuthException] is thrown',
        () async {
      when(() => authClient.sendPasswordResetEmail(email: any(named: 'email')))
          .thenThrow(tFirebaseAuthException);

      final call = datasource.forgotPassword;

      expect(() => call(tEmail), throwsA(isA<ServerException>()));
      verify(() => authClient.sendPasswordResetEmail(email: tEmail)).called(1);
      verifyNoMoreInteractions(authClient);
    });
  });
}

// BELOW IS NOT RIGHT the EXAMPLE
//   const tPassword = 'Test Password';
//   const tFullName = 'Test Full Name';
//   const tEmail = 'testemail@mail.org';
//
//   test('signUp', () async {
//     await datasource.signUp(
//       email: tEmail,
//       fullName: tFullName,
//       password: tPassword,
//     );
//
//     // expect that the user was created in the fireStore and the authClient
//     // also has the user
//
//     expect(authClient.currentUser, isNotNull);
//     expect(authClient.currentUser!.displayName, tFullName);
//
//     final user = await cloudStoreClient
//         .collection('users')
//         .doc(authClient.currentUser!.uid)
//         .get();
//
//     expect(user.exists, isTrue);
//   });
//
//   test('signIn', () async {
//     await datasource.signUp(
//       email: 'newEmail@mail.com',
//       fullName: tFullName,
//       password: tPassword,
//     );
//
//     await authClient.signOut();
//
//     await datasource.signIn(email: 'newEmail@mail.com', password: tPassword);
//
//     expect(authClient.currentUser, isNotNull);
//     expect(authClient.currentUser!.email, 'newEmail@mail.com');
//   });
//
//   group('updateUser', () {
//     test('displayName', () async {
//       // Arrange
//       await datasource.signUp(
//         email: tEmail,
//         fullName: tFullName,
//         password: tPassword,
//       );
//
//       // Act
//       await datasource.updateUser(
//         action: UpdateUserAction.displayName,
//         userData: 'new name',
//       );
//
//       expect(authClient.currentUser!.displayName, 'new name');
//     });
//
//     test('email', () async {
//       await datasource.updateUser(
//         action: UpdateUserAction.email,
//         userData: 'newEmail@mail.com',
//       );
//
//       expect(authClient.currentUser!.email, 'newEmail@mail.com');
//     });
//   });
// }
