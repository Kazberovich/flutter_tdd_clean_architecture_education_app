import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/exam_question_model.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam_question.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/question_choice.dart';

import '../../../../../../fixtures/fixture_reader.dart';

void main() {
  const tExamQuestionModel = ExamQuestionModel.empty();

  group('ExamQuestionModel', () {
    test('should be a subclass of [ExamQuestion] entity', () async {
      expect(tExamQuestionModel, isA<ExamQuestion>());
    });

    var map = jsonDecode(fixture('exam.json')) as DataMap;
    map = (map['questions'] as List<dynamic>)[0] as DataMap;

    group('fromMap', () {
      test(
          'should return a valid [ExamQuestionModel] when the JSON is not null',
          () async {
        final result = ExamQuestionModel.fromMap(map);
        expect(result, tExamQuestionModel);
      });
    });
    group('fromUploadMap', () {
      test(
          'should return a valid [ExamQuestionModel] when the JSON is not null',
          () async {
        final map =
            jsonDecode(fixture('uploaded_exam_question.json')) as DataMap;
        final result = ExamQuestionModel.fromUploadMap(map);
        expect(result, tExamQuestionModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () async {
        final result = tExamQuestionModel.toMap();
        expect(result, map..update('choices', (value) => <QuestionChoice>[]));
      });
    });

    group('copyWith', () {
      test('should return a new [ExamQuestionModel] with the same values',
          () async {
        final result = tExamQuestionModel.copyWith(id: '');
        expect(result.id, equals(''));
      });
    });
  });
}
