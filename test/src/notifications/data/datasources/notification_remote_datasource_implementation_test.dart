import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:tdd_education_app/src/authentication/data/models/user_model.dart';
import 'package:tdd_education_app/src/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:tdd_education_app/src/notifications/data/models/notification_model.dart';

void main() {
  late NotificationRemoteDatasourceImplementation notificationRemoteDatasource;
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late MockFirebaseStorage storage;

  setUp(() async {
    firestore = FakeFirebaseFirestore();

    final user =
        MockUser(uid: 'uid', email: 'email', displayName: 'displayName');

    final googleSignIn = MockGoogleSignIn();
    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;
    final credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    auth = MockFirebaseAuth(mockUser: user);
    await auth.signInWithCredential(credentials);

    storage = MockFirebaseStorage();

    notificationRemoteDatasource = NotificationRemoteDatasourceImplementation(
      firestore: firestore,
      auth: auth,
    );
  });

  group('sendNotification', () {
    test('should upload a [Notification] to the specified user', () async {
      // arrange
      const secondUID = 'second uid';
      for (var i = 0; i < 2; i++) {
        await firestore
            .collection('users')
            .doc(i == 0 ? auth.currentUser!.uid : secondUID)
            .set(
              const LocalUserModel.empty()
                  .copyWith(
                    uid: i == 0 ? auth.currentUser!.uid : secondUID,
                    email: i == 0 ? auth.currentUser!.email : 'second email',
                    fullName:
                        i == 0 ? auth.currentUser!.displayName : 'second name',
                  )
                  .toMap(),
            );
      }

      final tNotification = NotificationModel.empty().copyWith(
        id: '1',
        title: 'Test unique title, can not be duplicated',
        body: 'Test',
      );

      // Act
      await notificationRemoteDatasource.sendNotification(tNotification);

      // Assert
      final user1NotificationRef = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('notifications')
          .get();
      final user2NotificationRef = await firestore
          .collection('users')
          .doc(secondUID)
          .collection('notifications')
          .get();

      expect(user1NotificationRef.docs, hasLength(1));
      expect(
        user1NotificationRef.docs.first.data()['title'],
        equals(
          tNotification.title,
        ),
      );
      expect(user2NotificationRef.docs, hasLength(1));
      expect(
        user2NotificationRef.docs.first.data()['title'],
        equals(
          tNotification.title,
        ),
      );
    });
  });

  group('getNotifications', () {
    test(
      'should return a [Stream<List<Notification>>] '
      'when the call is successful',
      () async {
        // arrange
        final userId = auth.currentUser!.uid;

        final expectedNotifications = [
          NotificationModel.empty(),
          NotificationModel.empty().copyWith(
            id: '1',
            sentAt: DateTime.now().add(
              const Duration(seconds: 50),
            ),
          ),
        ];

        for (final notification in expectedNotifications) {
          await notificationRemoteDatasource.sendNotification(notification);
        }

        // act
        final result = notificationRemoteDatasource.getNotifications();

        // assert
        expect(result, emits(equals(<NotificationModel>[])));
      },
    );
  });
}
