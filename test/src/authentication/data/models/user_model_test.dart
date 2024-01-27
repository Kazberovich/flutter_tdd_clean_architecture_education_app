import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/authentication/data/models/user_model.dart';
import 'package:tdd_education_app/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tLocalUserModel = LocalUserModel.empty();

  test(
    'should be a subclass of [LocalUser] entity',
    () => expect(tLocalUserModel, isA<LocalUser>()),
  );

  final tMap = jsonDecode(fixture('user.json')) as DataMap;

  group('fromMap', () {
    test('should return a valid [LocalUserModel] from the map', () {
      // act

      final result = LocalUserModel.fromMap(tMap);

      // assert
      expect(result, equals(tLocalUserModel));
      expect(result, isA<LocalUserModel>());
    });

    test('should throw an [Error] when the map is invalid', () {
      final map = tMap..remove('uid');

      const call = LocalUserModel.fromMap;
      expect(() => call(map), throwsA(isA<Error>()));
    });
  });
}
