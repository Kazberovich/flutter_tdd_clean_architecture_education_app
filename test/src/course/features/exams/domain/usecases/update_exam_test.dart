import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/usecases/update_exam.dart';

import 'exam_repo.mock.dart';

void main() {
  late MockExamRepo repo;
  late UpdateExam usecase;

  const tExam = Exam.empty();

  setUp(() {
    repo = MockExamRepo();
    usecase = UpdateExam(repo);
    registerFallbackValue(tExam);
  });

  test(
    'should call the [ExamRepo.updateExam]',
    () async {
      when(() => repo.updateExam(any())).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(tExam);
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => repo.updateExam(any())).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
