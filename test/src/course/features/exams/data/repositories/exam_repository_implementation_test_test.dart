import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/core/errors/exceptions.dart';
import 'package:tdd_education_app/core/errors/failures.dart';
import 'package:tdd_education_app/src/course/features/exams/data/datasources/exam_remote_datasource.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/exam_model.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/user_exam_model.dart';
import 'package:tdd_education_app/src/course/features/exams/data/repositories/exam_repository_implementation.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam_question.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/user_exam.dart';

class MockExamRemoteDataSrc extends Mock implements ExamRemoteDataSrc {}

void main() {
  late MockExamRemoteDataSrc remoteDataSrc;
  late ExamRepoImpl repoImpl;

  const tExam = ExamModel.empty();
  final tUserExam = UserExamModel.empty();

  setUp(() {
    remoteDataSrc = MockExamRemoteDataSrc();
    repoImpl = ExamRepoImpl(remoteDataSrc);
    registerFallbackValue(tExam);
    registerFallbackValue(tUserExam);
  });

  const tException = ServerException(
    message: 'Test message',
    statusCode: '500',
  );

  group('getExamQuestions', () {
    test(
      'should return [List<ExamQuestion>] when call to remote source is '
          'successful',
          () async {
        when(() => remoteDataSrc.getExamQuestions(any())).thenAnswer(
              (_) async => [],
        );

        final result = await repoImpl.getExamQuestions(tExam);

        expect(result, isA<Right<dynamic, List<ExamQuestion>>>());

        verify(() => remoteDataSrc.getExamQuestions(tExam)).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return ServerFailure when call to remote source is '
          'unsuccessful',
          () async {
        when(() => remoteDataSrc.getExamQuestions(any())).thenThrow(tException);

        final result = await repoImpl.getExamQuestions(tExam);

        expect(
          result,
          equals(
            Left<ServerFailure, List<ExamQuestion>>(
              ServerFailure.fromException(tException),
            ),
          ),
        );
        verify(() => remoteDataSrc.getExamQuestions(tExam)).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });

  group('getExams', () {
    test(
      'should return [List<Exam>] when call to remote source is '
          'successful',
          () async {
        when(() => remoteDataSrc.getExams(any())).thenAnswer(
              (_) async => [],
        );

        final result = await repoImpl.getExams('Test String');

        expect(result, isA<Right<dynamic, List<Exam>>>());

        verify(() => remoteDataSrc.getExams('Test String')).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return ServerFailure when call to remote source is '
          'unsuccessful',
          () async {
        when(() => remoteDataSrc.getExams(any())).thenThrow(tException);

        final result = await repoImpl.getExams('Test String');

        expect(
          result,
          equals(
            Left<ServerFailure, List<ExamModel>>(
              ServerFailure.fromException(tException),
            ),
          ),
        );
        verify(() => remoteDataSrc.getExams('Test String')).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });

  group('submitExam', () {
    test(
      'should complete successfully when call to remote source is '
          'successful',
          () async {
        when(() => remoteDataSrc.submitExam(any())).thenAnswer(
              (_) async => Future.value(),
        );

        final result = await repoImpl.submitExam(tUserExam);

        expect(result, equals(const Right<dynamic, void>(null)));

        verify(() => remoteDataSrc.submitExam(tUserExam)).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return ServerFailure when call to remote source is '
          'unsuccessful',
          () async {
        when(() => remoteDataSrc.submitExam(any())).thenThrow(tException);

        final result = await repoImpl.submitExam(tUserExam);

        expect(
          result,
          equals(
            Left<ServerFailure, void>(ServerFailure.fromException(tException)),
          ),
        );
        verify(() => remoteDataSrc.submitExam(tUserExam)).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });

  group('updateExam', () {
    test(
      'should complete successfully when call to remote source is '
          'successful',
          () async {
        when(() => remoteDataSrc.updateExam(any())).thenAnswer(
              (_) async => Future.value(),
        );

        final result = await repoImpl.updateExam(tExam);

        expect(result, equals(const Right<dynamic, void>(null)));

        verify(() => remoteDataSrc.updateExam(tExam)).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return ServerFailure when call to remote source is '
          'unsuccessful',
          () async {
        when(() => remoteDataSrc.updateExam(any())).thenThrow(tException);

        final result = await repoImpl.updateExam(tExam);

        expect(
          result,
          equals(
            Left<ServerFailure, void>(ServerFailure.fromException(tException)),
          ),
        );
        verify(() => remoteDataSrc.updateExam(tExam)).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });

  group('uploadExam', () {
    test(
      'should complete successfully when call to remote source is '
          'successful',
          () async {
        when(() => remoteDataSrc.uploadExam(any())).thenAnswer(
              (_) async => Future.value(),
        );

        final result = await repoImpl.uploadExam(tExam);

        expect(result, equals(const Right<dynamic, void>(null)));

        verify(() => remoteDataSrc.uploadExam(tExam)).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return ServerFailure when call to remote source is '
          'unsuccessful',
          () async {
        when(() => remoteDataSrc.uploadExam(any())).thenThrow(tException);

        final result = await repoImpl.uploadExam(tExam);

        expect(
          result,
          equals(
            Left<ServerFailure, void>(ServerFailure.fromException(tException)),
          ),
        );
        verify(() => remoteDataSrc.uploadExam(tExam)).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });

  group('getUserExams', () {
    test(
      'should return [List<UserExam>] when call to remote source is '
          'successful',
          () async {
        when(() => remoteDataSrc.getUserExams()).thenAnswer(
              (_) async => [],
        );

        final result = await repoImpl.getUserExams();

        expect(result, isA<Right<dynamic, List<UserExam>>>());

        verify(() => remoteDataSrc.getUserExams()).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return ServerFailure when call to remote source is '
          'unsuccessful',
          () async {
        when(() => remoteDataSrc.getUserExams()).thenThrow(tException);

        final result = await repoImpl.getUserExams();

        expect(
          result,
          equals(
            Left<ServerFailure, List<UserExamModel>>(
              ServerFailure.fromException(tException),
            ),
          ),
        );
        verify(() => remoteDataSrc.getUserExams()).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });

  group('getUserCourseExams', () {
    test(
      'should return [List<UserExam>] when call to remote source is '
          'successful',
          () async {
        when(() => remoteDataSrc.getUserCourseExams(any())).thenAnswer(
              (_) async => [],
        );

        final result = await repoImpl.getUserCourseExams('Test String');

        expect(result, isA<Right<dynamic, List<UserExam>>>());

        verify(() => remoteDataSrc.getUserCourseExams('Test String')).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return ServerFailure when call to remote source is '
          'unsuccessful',
          () async {
        when(() => remoteDataSrc.getUserCourseExams(any()))
            .thenThrow(tException);

        final result = await repoImpl.getUserCourseExams('Test String');

        expect(
          result,
          equals(
            Left<ServerFailure, List<UserExamModel>>(
              ServerFailure.fromException(tException),
            ),
          ),
        );
        verify(() => remoteDataSrc.getUserCourseExams('Test String')).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });
}
