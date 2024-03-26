import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam_question.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/usecases/get_exam_questions.dart';

import 'exam_repo.mock.dart';

void main() {
  late MockExamRepo repo;
  late GetExamQuestions usecase;

  const tExam = Exam.empty();

  setUp(() {
    repo = MockExamRepo();
    usecase = GetExamQuestions(repo);
    registerFallbackValue(tExam);
  });

  test(
    'should return [List<ExamQuestion>] from the repo',
    () async {
      when(() => repo.getExamQuestions(any())).thenAnswer(
        (_) async => const Right(<ExamQuestion>[]),
      );

      final result = await usecase(tExam);
      expect(result, equals(const Right<dynamic, List<ExamQuestion>>([])));
      verify(() => repo.getExamQuestions(any())).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
