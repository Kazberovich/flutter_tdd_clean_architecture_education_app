import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/features/videos/data/models/video_model.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/entities/video.dart';

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

  final tVideoModel = VideoModel.empty();

  final tMap = jsonDecode(fixture('video.json')) as DataMap;
  tMap['uploadDate'] = timestamp;

  test('should be a subclass of [Video]', () {
    expect(tVideoModel, isA<Video>());
  });

  group('fromMap', () {
    test('should return a [VideoModel] with the correct data', () {
      final result = VideoModel.fromMap(tMap);
      expect(result, equals(tVideoModel));
    });
  });

  group('toMap', () {
    test('should return a [Map] with the proper data', () {
      final result = tVideoModel.toMap()..remove('uploadDate');

      final map = DataMap.from(tMap)..remove('uploadDate');
      expect(result, equals(map));
    });
  });

  group('copyWith', () {
    test('should return a [VideoModel] with the new data', () {
      final result = tVideoModel.copyWith(tutor: 'new tutor');
      expect(result.tutor, 'new tutor');
    });
  });
}
