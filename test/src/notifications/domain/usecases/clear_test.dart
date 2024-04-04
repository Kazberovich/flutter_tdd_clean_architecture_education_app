import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/src/notifications/domain/repositories/notification_repository.dart';
import 'package:tdd_education_app/src/notifications/domain/usecases/clear.dart';

import 'notification_repository.mock.dart';

void main() {
  late NotificationRepository repo;
  late Clear usecase;
  setUp(() {
    repo = MockNotificationRepo();
    usecase = Clear(repo);
  });

  test(
    'should call the [NotificationRepo.clear]',
    () async {
      when(() => repo.clear(any())).thenAnswer((_) async => const Right(null));

      final result = await usecase('id');

      expect(result, const Right<dynamic, void>(null));

      verify(() => repo.clear('id')).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
