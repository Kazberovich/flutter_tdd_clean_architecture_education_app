import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_education_app/core/enums/notification_enum.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/notifications/data/models/notification_model.dart';
import 'package:tdd_education_app/src/notifications/domain/entities/notification.dart';

import '../../../../fixtures/fixture_reader.dart';

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

  final tModel = NotificationModel.empty();

  final tMap = jsonDecode(fixture('notification.json')) as DataMap;
  tMap['sentAt'] = timestamp;

  test('should be a subclass of [Notification] entity', () {
    expect(tModel, isA<Notification>());
  });

  group('empty', () {
    test('should return an empty [NotificationModel]', () {
      final result = NotificationModel.empty();

      expect(result.title, '_empty.title');
    });
  });

  group('fromMap', () {
    test('should return a [NotificationModel] with the right data', () {
      final result = NotificationModel.fromMap(tMap);

      expect(result, equals(tModel));
    });
  });

  group('toMap', () {
    test('should return a [DataMap] with the right data', () {
      final result = tModel.toMap()..remove('sentAt');

      expect(result, equals(tMap..remove('sentAt')));
    });
  });

  group('copyWith', () {
    test('should return a [NotificationModel] with the right data', () {
      final result = tModel.copyWith(
        category: NotificationCategory.TEST,
      );

      expect(result, isA<NotificationModel>());
      expect(result.category, equals(NotificationCategory.TEST));
    });
  });
}
