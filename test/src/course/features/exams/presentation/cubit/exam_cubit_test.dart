import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/core/errors/failures.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/exam_model.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/exam_question_model.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/user_exam_model.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/usecases/get_exam_questions.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/usecases/get_exams.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/usecases/get_user_course_exams.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/usecases/get_user_exams.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/usecases/submit_exam.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/usecases/update_exam.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/usecases/upload_exam.dart';
import 'package:tdd_education_app/src/course/features/exams/presentation/app/cubit/exam_cubit.dart';

class MockGetExamQuestions extends Mock implements GetExamQuestions {}

class MockGetExams extends Mock implements GetExams {}

class MockSubmitExam extends Mock implements SubmitExam {}

class MockUpdateExam extends Mock implements UpdateExam {}

class MockUploadExam extends Mock implements UploadExam {}

class MockGetUserCourseExams extends Mock implements GetUserCourseExams {}

class MockGetUserExams extends Mock implements GetUserExams {}

void main() {
  late MockGetExamQuestions getExamQuestions;
  late MockGetExams getExams;
  late MockGetUserCourseExams getUserCourseExams;
  late MockGetUserExams getUserExams;
  late MockSubmitExam submitExam;
  late MockUpdateExam updateExam;
  late MockUploadExam uploadExam;

  late ExamCubit cubit;

  setUp(() {
    getExamQuestions = MockGetExamQuestions();
    getExams = MockGetExams();
    getUserCourseExams = MockGetUserCourseExams();
    getUserExams = MockGetUserExams();
    submitExam = MockSubmitExam();
    updateExam = MockUpdateExam();
    uploadExam = MockUploadExam();
    cubit = ExamCubit(
      getExamQuestions: getExamQuestions,
      getUserCourseExams: getUserCourseExams,
      getUserExams: getUserExams,
      getExams: getExams,
      submitExam: submitExam,
      updateExam: updateExam,
      uploadExam: uploadExam,
    );
  });

  test('initial state should be [ExamInitial]', () {
    expect(cubit.state, const ExamInitial());
  });

  final tFailure = ServerFailure(message: 'Server Failure', statusCode: '500');

  group('getExamQuestions', () {
    const tExam = ExamModel.empty();

    setUp(() => registerFallbackValue(tExam));

    final tQuestions = [
      const ExamQuestionModel.empty(),
      const ExamQuestionModel.empty().copyWith(id: '1'),
    ];

    blocTest<ExamCubit, ExamState>(
      'should emit [GettingExamQuestions, ExamQuestionsLoaded] when successful',
      build: () {
        when(() => getExamQuestions(any())).thenAnswer(
          (_) async => Right(tQuestions),
        );
        return cubit;
      },
      act: (cubit) => cubit.getExamQuestions(tExam),
      expect: () => [
        const GettingExamQuestions(),
        ExamQuestionsLoaded(tQuestions),
      ],
      verify: (_) {
        verify(() => getExamQuestions(tExam)).called(1);
        verifyNoMoreInteractions(getExamQuestions);
      },
    );

    blocTest<ExamCubit, ExamState>(
      'should emit [GettingExamQuestions, ExamError] when unsuccessful',
      build: () {
        when(() => getExamQuestions(tExam))
            .thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.getExamQuestions(tExam),
      expect: () => [
        const GettingExamQuestions(),
        const ExamError('500 Error : Server Failure'),
      ],
      verify: (_) {
        verify(() => getExamQuestions(tExam)).called(1);
        verifyNoMoreInteractions(getExamQuestions);
      },
    );
  });

  group('getExams', () {
    const tCourseId = 'Test String';

    final tExams = [
      const ExamModel.empty(),
      const ExamModel.empty().copyWith(id: '1'),
    ];

    blocTest<ExamCubit, ExamState>(
      'should emit [GettingExams, ExamsLoaded] when successful',
      build: () {
        when(() => getExams(any())).thenAnswer(
          (_) async => Right(tExams),
        );
        return cubit;
      },
      act: (cubit) => cubit.getExams(tCourseId),
      expect: () => [
        const GettingExams(),
        ExamsLoaded(tExams),
      ],
      verify: (_) {
        verify(() => getExams(tCourseId)).called(1);
        verifyNoMoreInteractions(getExams);
      },
    );

    blocTest<ExamCubit, ExamState>(
      'should emit [GettingExams, ExamError] when unsuccessful',
      build: () {
        when(() => getExams(tCourseId)).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.getExams(tCourseId),
      expect: () => [
        const GettingExams(),
        const ExamError('500 Error : Server Failure'),
      ],
      verify: (_) {
        verify(() => getExams(tCourseId)).called(1);
        verifyNoMoreInteractions(getExams);
      },
    );
  });

  group('submitExam', () {
    final tUserExam = UserExamModel.empty();

    setUp(() => registerFallbackValue(tUserExam));

    blocTest<ExamCubit, ExamState>(
      'should emit [SubmittingExam, ExamSubmitted] when successful',
      build: () {
        when(() => submitExam(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return cubit;
      },
      act: (cubit) => cubit.submitExam(tUserExam),
      expect: () => [
        const SubmittingExam(),
        const ExamSubmitted(),
      ],
      verify: (_) {
        verify(() => submitExam(tUserExam)).called(1);
        verifyNoMoreInteractions(submitExam);
      },
    );

    blocTest<ExamCubit, ExamState>(
      'should emit [SubmittingExam, ExamError] when unsuccessful',
      build: () {
        when(() => submitExam(tUserExam))
            .thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.submitExam(tUserExam),
      expect: () => [
        const SubmittingExam(),
        const ExamError('500 Error : Server Failure'),
      ],
      verify: (_) {
        verify(() => submitExam(tUserExam)).called(1);
        verifyNoMoreInteractions(submitExam);
      },
    );
  });

  group('updateExam', () {
    const tExam = ExamModel.empty();

    setUp(() => registerFallbackValue(tExam));

    blocTest<ExamCubit, ExamState>(
      'should emit [UpdatingExam, ExamUpdated] when successful',
      build: () {
        when(() => updateExam(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return cubit;
      },
      act: (cubit) => cubit.updateExam(tExam),
      expect: () => [
        const UpdatingExam(),
        const ExamUpdated(),
      ],
      verify: (_) {
        verify(() => updateExam(tExam)).called(1);
        verifyNoMoreInteractions(updateExam);
      },
    );

    blocTest<ExamCubit, ExamState>(
      'should emit [UpdatingExam, ExamError] when unsuccessful',
      build: () {
        when(() => updateExam(tExam)).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.updateExam(tExam),
      expect: () => [
        const UpdatingExam(),
        const ExamError('500 Error : Server Failure'),
      ],
      verify: (_) {
        verify(() => updateExam(tExam)).called(1);
        verifyNoMoreInteractions(updateExam);
      },
    );
  });

  group('uploadExam', () {
    const tExam = ExamModel.empty();

    setUp(() => registerFallbackValue(tExam));

    blocTest<ExamCubit, ExamState>(
      'should emit [UploadingExam, ExamUploaded] when successful',
      build: () {
        when(() => uploadExam(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return cubit;
      },
      act: (cubit) => cubit.uploadExam(tExam),
      expect: () => [
        const UploadingExam(),
        const ExamUploaded(),
      ],
      verify: (_) {
        verify(() => uploadExam(tExam)).called(1);
        verifyNoMoreInteractions(uploadExam);
      },
    );

    blocTest<ExamCubit, ExamState>(
      'should emit [UploadingExam, ExamError] when unsuccessful',
      build: () {
        when(() => uploadExam(tExam)).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.uploadExam(tExam),
      expect: () => [
        const UploadingExam(),
        const ExamError('500 Error : Server Failure'),
      ],
      verify: (_) {
        verify(() => uploadExam(tExam)).called(1);
        verifyNoMoreInteractions(uploadExam);
      },
    );
  });

  group('getUserCourseExams', () {
    const tCourseId = 'Test String';

    final tUserExams = [UserExamModel.empty()];

    blocTest<ExamCubit, ExamState>(
      'should emit [GettingUserExams, UserCourseExamsLoaded] '
      'when successful',
      build: () {
        when(() => getUserCourseExams(any())).thenAnswer(
          (_) async => Right(tUserExams),
        );
        return cubit;
      },
      act: (cubit) => cubit.getUserCourseExams(tCourseId),
      expect: () => [
        const GettingUserExams(),
        UserCourseExamsLoaded(tUserExams),
      ],
      verify: (_) {
        verify(() => getUserCourseExams(tCourseId)).called(1);
        verifyNoMoreInteractions(getUserCourseExams);
      },
    );

    blocTest<ExamCubit, ExamState>(
      'should emit [GettingUserExams, ExamError] when unsuccessful',
      build: () {
        when(() => getUserCourseExams(tCourseId))
            .thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.getUserCourseExams(tCourseId),
      expect: () => [
        const GettingUserExams(),
        const ExamError('500 Error : Server Failure'),
      ],
      verify: (_) {
        verify(() => getUserCourseExams(tCourseId)).called(1);
        verifyNoMoreInteractions(getUserCourseExams);
      },
    );
  });

  group('getUserExams', () {
    final tUserExams = [UserExamModel.empty()];

    blocTest<ExamCubit, ExamState>(
      'should emit [GettingUserExams, UserExamsLoaded] when successful',
      build: () {
        when(() => getUserExams()).thenAnswer(
          (_) async => Right(tUserExams),
        );
        return cubit;
      },
      act: (cubit) => cubit.getUserExams(),
      expect: () => [
        const GettingUserExams(),
        UserExamsLoaded(tUserExams),
      ],
      verify: (_) {
        verify(() => getUserExams()).called(1);
        verifyNoMoreInteractions(getUserExams);
      },
    );

    blocTest<ExamCubit, ExamState>(
      'should emit [GettingUserExams, ExamError] when unsuccessful',
      build: () {
        when(() => getUserExams()).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.getUserExams(),
      expect: () => [
        const GettingUserExams(),
        const ExamError('500 Error : Server Failure'),
      ],
      verify: (_) {
        verify(() => getUserExams()).called(1);
        verifyNoMoreInteractions(getUserExams);
      },
    );
  });
}
