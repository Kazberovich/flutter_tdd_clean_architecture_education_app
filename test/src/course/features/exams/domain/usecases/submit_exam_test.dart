import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/usecases/submit_exam.dart';

import 'exam_repo.mock.dart';

void main() {
  late MockExamRepo repo;
  late SubmitExam usecase;

  final tExam = UserExam.empty();

  setUp(() {
    repo = MockExamRepo();
    usecase = SubmitExam(repo);
    registerFallbackValue(tExam);
  });

  test(
    'should call the [ExamRepo.submitExam]',
    () async {
      when(() => repo.submitExam(any())).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(tExam);
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => repo.submitExam(any())).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
