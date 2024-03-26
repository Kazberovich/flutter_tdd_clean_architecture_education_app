import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/usecases/upload_exam.dart';

import 'exam_repo.mock.dart';

void main() {
  late MockExamRepo repo;
  late UploadExam usecase;

  const tExam = Exam.empty();

  setUp(() {
    repo = MockExamRepo();
    usecase = UploadExam(repo);
    registerFallbackValue(tExam);
  });

  test(
    'should call the [ExamRepo.uploadExam]',
    () async {
      when(() => repo.uploadExam(any())).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(tExam);
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => repo.uploadExam(any())).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
