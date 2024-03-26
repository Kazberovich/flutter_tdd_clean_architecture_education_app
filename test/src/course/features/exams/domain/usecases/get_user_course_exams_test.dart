import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/usecases/get_user_course_exams.dart';

import 'exam_repo.mock.dart';

void main() {
  late MockExamRepo repo;
  late GetUserCourseExams usecase;

  const tCourseId = 'Test String';

  setUp(() {
    repo = MockExamRepo();
    usecase = GetUserCourseExams(repo);
  });

  test(
    'should return [List<UserExam>] from the repo',
    () async {
      when(() => repo.getUserCourseExams(any())).thenAnswer(
        (_) async => const Right([]),
      );

      final result = await usecase(tCourseId);
      expect(result, equals(const Right<dynamic, List<UserExam>>([])));
      verify(() => repo.getUserCourseExams(any())).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
