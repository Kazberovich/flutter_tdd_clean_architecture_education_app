import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tdd_education_app/core/utils/datasource_utils.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/exam_model.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/exam_question_model.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/user_exam_model.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/user_exam.dart';

import '../../../../../../core/errors/exceptions.dart';

abstract class ExamRemoteDataSrc {
  Future<List<ExamModel>> getExams(String courseId);

  Future<void> uploadExam(Exam exam);

  Future<List<ExamQuestionModel>> getExamQuestions(Exam exam);

  Future<void> updateExam(Exam exam);

  Future<void> submitExam(UserExam exam);

  Future<List<UserExamModel>> getUserExams();

  Future<List<UserExamModel>> getUserCourseExams(String courseId);
}

class ExamRemoteDataSrcImpl implements ExamRemoteDataSrc {
  const ExamRemoteDataSrcImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Future<List<ExamQuestionModel>> getExamQuestions(Exam exam) async {
    throw UnimplementedError();
  }

  @override
  Future<List<ExamModel>> getExams(String courseId) async {
    // TODO: implement getExams
    throw UnimplementedError();
  }

  @override
  Future<List<UserExamModel>> getUserCourseExams(String courseId) async {
    // TODO: implement getUserCourseExams
    throw UnimplementedError();
  }

  @override
  Future<List<UserExamModel>> getUserExams() async {
    // TODO: implement getUserExams
    throw UnimplementedError();
  }

  @override
  Future<void> submitExam(UserExam exam) async {
    // TODO: implement submitExam
    throw UnimplementedError();
  }

  @override
  Future<void> updateExam(Exam exam) async {
    // TODO: implement updateExam
    throw UnimplementedError();
  }

  @override
  Future<void> uploadExam(Exam exam) async {
    try {
      await DataSourceUtils.authorizedUser(_auth);
      final examDocsRef = _firestore
          .collection('courses')
          .doc(exam.courseId)
          .collection('exams')
          .doc();

      final examToUpload = (exam as ExamModel).copyWith(id: examDocsRef.id);
      await examDocsRef.set(examToUpload.toMap());

    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
