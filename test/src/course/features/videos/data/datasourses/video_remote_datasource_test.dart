import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:tdd_education_app/src/course/data/models/course_model.dart';
import 'package:tdd_education_app/src/course/features/videos/data/datasourses/video_remote_datasource.dart';
import 'package:tdd_education_app/src/course/features/videos/data/models/video_model.dart';

void main() {
  late VideoRemoteDataSource remoteDataSource;
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late MockFirebaseStorage storage;

  final tVideo = VideoModel.empty();

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

    remoteDataSource = VideoRemoteDataSourceImplementation(
      firestore: firestore,
      storage: storage,
      auth: auth,
    );

    await firestore
        .collection('courses')
        .doc(tVideo.courseId)
        .set(CourseModel.empty().copyWith(id: tVideo.courseId).toMap());
  });

  group('addVideo', () {
    test('should add the provided [Video] to Firestore', () async {
      await remoteDataSource.addVideo(tVideo);

      final videoCollectionRef = await firestore
          .collection('courses')
          .doc(tVideo.courseId)
          .collection('videos')
          .get();

      expect(videoCollectionRef.docs.length, 1);
      expect(videoCollectionRef.docs.first.data()['title'], tVideo.title);

      final courseRef =
          await firestore.collection('courses').doc(tVideo.courseId).get();
      expect(courseRef.data()!['numberOfVideos'], 1);
    });
  });
}
