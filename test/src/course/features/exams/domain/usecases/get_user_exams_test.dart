import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/usecases/get_user_exams.dart';

import 'exam_repo.mock.dart';

void main() {
  late MockExamRepo repo;
  late GetUserExams usecase;

  setUp(() {
    repo = MockExamRepo();
    usecase = GetUserExams(repo);
  });

  test(
    'should return [List<UserExam>] from the repo',
    () async {
      when(() => repo.getUserExams()).thenAnswer(
        (_) async => const Right([]),
      );

      final result = await usecase();
      expect(result, equals(const Right<dynamic, List<UserExam>>([])));
      verify(() => repo.getUserExams()).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
