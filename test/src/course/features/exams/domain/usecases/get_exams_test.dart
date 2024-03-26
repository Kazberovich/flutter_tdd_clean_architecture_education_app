import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/usecases/get_exams.dart';

import 'exam_repo.mock.dart';

void main() {
  late MockExamRepo repo;
  late GetExams usecase;

  const tCourseId = 'Test String';

  setUp(() {
    repo = MockExamRepo();
    usecase = GetExams(repo);
  });

  test(
    'should return [List<Exam>] from the repo',
    () async {
      when(
        () => repo.getExams(
          any(),
        ),
      ).thenAnswer(
        (_) async => const Right([]),
      );

      final result = await usecase(tCourseId);
      expect(result, equals(const Right<dynamic, List<Exam>>([])));
      verify(
        () => repo.getExams(
          any(),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
