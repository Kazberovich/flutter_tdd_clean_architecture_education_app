import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tdd_education_app/core/errors/exceptions.dart';
import 'package:tdd_education_app/core/utils/datasource_utils.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/exam_model.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/exam_question_model.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/question_choice_model.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/user_exam_model.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/user_exam.dart';

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
    try {
      await DataSourceUtils.authorizedUser(_auth);
      final result = await _firestore
          .collection('courses')
          .doc(exam.courseId)
          .collection('exams')
          .doc(exam.id)
          .collection('questions')
          .get();

      return result.docs
          .map((doc) => ExamQuestionModel.fromMap(doc.data()))
          .toList();
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

  @override
  Future<List<ExamModel>> getExams(String courseId) async {
    try {
      await DataSourceUtils.authorizedUser(_auth);
      final result = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('exams')
          .get();

      return result.docs.map((doc) => ExamModel.fromMap(doc.data())).toList();
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

  @override
  Future<List<UserExamModel>> getUserCourseExams(String courseId) async {
    try {
      await DataSourceUtils.authorizedUser(_auth);

      final result = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('courses')
          .doc(courseId)
          .collection('exams')
          .get();

      return result.docs
          .map((doc) => UserExamModel.fromMap(doc.data()))
          .toList();
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

  @override
  Future<List<UserExamModel>> getUserExams() async {
    // TODO(GetUserExams): implement getUserExams
    throw UnimplementedError();
  }

  @override
  Future<void> submitExam(UserExam exam) async {
    try {
      await DataSourceUtils.authorizedUser(_auth);
      final user = _auth.currentUser!;
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('courses')
          .doc(exam.courseId)
          .set({
        'courseId': exam.courseId,
        'courseName': exam.examTitle,
      });

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('courses')
          .doc(exam.courseId)
          .collection('exams')
          .doc(exam.examId)
          .set((exam as UserExamModel).toMap());

      final totalPoints = exam.answers
          .where((answer) => answer.isCorrect)
          .fold<int>(0, (previousValue, _) => previousValue + 1);

      final pointPercent = totalPoints / exam.totalQuestions;
      final points = pointPercent * 100;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'points': FieldValue.increment(points)});

      final userData = await _firestore.collection('users').doc(user.uid).get();

      final alreadyEnrolled = (userData.data()?['enrolledCourseIds'] as List?)
              ?.contains(exam.courseId) ??
          false;

      if (!alreadyEnrolled) {
        await _firestore.collection('users').doc(user.uid).update({
          'enrolledCourseIds': FieldValue.arrayUnion([exam.courseId]),
        });
      }
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> updateExam(Exam exam) async {
    try {
      await DataSourceUtils.authorizedUser(_auth);
      await _firestore
          .collection('courses')
          .doc(exam.courseId)
          .collection('exams')
          .doc(exam.id)
          .update((exam as ExamModel).toMap());

      // update questions
      final questions = exam.questions;

      if (questions != null && questions.isNotEmpty) {
        final batch = _firestore.batch();
        for (final question in questions) {
          final questionDocRef = _firestore
              .collection('courses')
              .doc(exam.courseId)
              .collection('exams')
              .doc(exam.id)
              .collection('questions')
              .doc(question.id);
          batch.update(questionDocRef, (question as ExamQuestionModel).toMap());
        }
        await batch.commit();
      }
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
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

      // upload questions
      final questions = exam.questions;
      if (questions != null && questions.isNotEmpty) {
        final batch = _firestore.batch();
        for (final question in questions) {
          final questionDocRef = examDocsRef.collection('questions').doc();
          var questionToUpload = (question as ExamQuestionModel).copyWith(
            id: questionDocRef.id,
            examId: examDocsRef.id,
            courseId: exam.courseId,
          );

          final newChoices = <QuestionChoiceModel>[];
          for (final choice in questionToUpload.choices) {
            final newChoice = (choice as QuestionChoiceModel)
                .copyWith(questionId: questionDocRef.id);
            newChoices.add(newChoice);
          }
          questionToUpload = questionToUpload.copyWith(choices: newChoices);
          batch.set(questionDocRef, questionToUpload.toMap());
        }
        await batch.commit();
      }

      await _firestore.collection('courses').doc(exam.courseId).update({
        'numberOfExams': FieldValue.increment(1),
      });
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
