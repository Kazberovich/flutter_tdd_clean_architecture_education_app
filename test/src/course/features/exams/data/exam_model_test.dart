import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/exam_model.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam.dart';

import '../../../../../fixtures/fixture_reader.dart';

void main() {
  const tExamModel = ExamModel.empty();

  group('ExamModel', () {
    test('should be a subclass of [Exam] entity', () async {
      expect(tExamModel, isA<Exam>());
    });

    group('fromMap', () {
      test('should return a valid [ExamModel] when the JSON is not null',
          () async {
        final map = jsonDecode(fixture('exam.json')) as DataMap;
        final result = ExamModel.fromMap(map);
        expect(result, tExamModel);
      });
    });

    group('fromUploadMap', () {
      test('should return a valid [ExamModel] when the JSON is not null',
          () async {
        final map = jsonDecode(fixture('uploaded_exam.json')) as DataMap;
        final result = ExamModel.fromUploadMap(map);
        expect(result, tExamModel);
      });
    });

    group('fromJson', () {
      test('should return a valid [ExamModel] when the JSON is not null',
          () async {
        final json = fixture('uploaded_exam.json');
        final result = ExamModel.fromJson(json);
        expect(result, tExamModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () async {
        final map = jsonDecode(fixture('exam.json')) as DataMap
          ..remove('questions');
        final result = tExamModel.toMap();
        expect(result, map);
      });
    });

    group('copyWith', () {
      test('should return a new [ExamModel] with the same values', () async {
        final result = tExamModel.copyWith(id: '');
        expect(result.id, equals(''));
      });
    });
  });
}
