import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:tdd_education_app/src/course/data/models/course_model.dart';
import 'package:tdd_education_app/src/course/features/exams/data/datasources/exam_remote_datasource.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/exam_model.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/exam_question_model.dart';

void main() {
  late ExamRemoteDataSrc remoteDataSource;
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;

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

    remoteDataSource = ExamRemoteDataSrcImpl(
      firestore: firestore,
      auth: auth,
    );
  });

  group('uploadExam', () {
    test(
        'should upload a given [Exam] to the firestore and separate '
        'the [Exam] and the [Exam.questions]', () async {
      // Arrange

      final tExam = const ExamModel.empty()
          .copyWith(questions: const [ExamQuestionModel.empty()]);

      await firestore.collection('courses').doc(tExam.courseId).set(
            CourseModel.empty().copyWith(id: tExam.courseId).toMap(),
          );

      // Act
      await remoteDataSource.uploadExam(tExam);

      // Assert
      final examDocs = await firestore
          .collection('courses')
          .doc(tExam.courseId)
          .collection('exams')
          .get();

      expect(examDocs.docs, isNotEmpty);
      final examModel = ExamModel.fromMap(examDocs.docs.first.data());
      expect(examModel.courseId, tExam.courseId);

      final questionsDocs = await firestore
          .collection('courses')
          .doc(examModel.courseId)
          .collection('exams')
          .doc(examModel.id)
          .collection('questions')
          .get();

      expect(questionsDocs.docs, isNotEmpty);
      final questionModel =
          ExamQuestionModel.fromMap(questionsDocs.docs.first.data());
      expect(questionModel.courseId, tExam.courseId);
      expect(questionModel.examId, examModel.id);
    });
  });

  group('getExamQuestions', () {
    test('should return the questions of the given exam', () async {
      // arrange

      final exam = const ExamModel.empty()
          .copyWith(questions: [const ExamQuestionModel.empty()]);

      await firestore
          .collection('courses')
          .doc(exam.courseId)
          .set(CourseModel.empty().copyWith(id: exam.courseId).toMap());

      await remoteDataSource.uploadExam(exam);

      // act
      final examsCollection = await firestore
          .collection('courses')
          .doc(exam.courseId)
          .collection('exams')
          .get();

      final examModel = ExamModel.fromMap(examsCollection.docs.first.data());
      final result = await remoteDataSource.getExamQuestions(examModel);

      //assert
      expect(result, isA<List<ExamQuestionModel>>());
      expect(result, hasLength(1));
      expect(result.first.courseId, exam.courseId);
    });
  });
}
