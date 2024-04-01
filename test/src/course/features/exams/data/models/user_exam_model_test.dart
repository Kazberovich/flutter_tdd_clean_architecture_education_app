import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/user_exam_model.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/user_exam.dart';

import '../../../../../../fixtures/fixture_reader.dart';

void main() {
  final timestampData = {
    '_seconds': 1677483548,
    '_nanoseconds': 123456000,
  };

  final date =
      DateTime.fromMillisecondsSinceEpoch(timestampData['_seconds']!).add(
    Duration(microseconds: timestampData['_nanoseconds']!),
  );

  final timestamp = Timestamp.fromDate(date);

  final tUserExamModel = UserExamModel.empty();

  final tMap = jsonDecode(fixture('user_exam.json')) as DataMap;
  tMap['dateSubmitted'] = timestamp;

  group('UserExamModel', () {
    test('should be a subclass of [UserExam] entity', () async {
      expect(tUserExamModel, isA<UserExam>());
    });

    group('fromMap', () {
      test('should return a valid [UserExamModel] when the JSON is not null',
          () async {
        final result = UserExamModel.fromMap(tMap);
        expect(result, tUserExamModel);
      });
    });

    group('toMap', () {
      test(
        'should return a Dart map containing the proper data',
        () async {
          final result = tUserExamModel.toMap()..remove('dateSubmitted');

          final map = DataMap.from(tMap)..remove('dateSubmitted');
          expect(result, equals(map));
        },
      );
    });

    group('copyWith', () {
      test('should return a new [UserExamModel] with the same values',
          () async {
        final result = tUserExamModel.copyWith(examId: '');
        expect(result.examId, equals(''));
      });
    });
  });
}
