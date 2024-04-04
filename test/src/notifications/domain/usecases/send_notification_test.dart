import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/src/notifications/domain/entities/notification.dart';
import 'package:tdd_education_app/src/notifications/domain/repositories/notification_repository.dart';
import 'package:tdd_education_app/src/notifications/domain/usecases/send_notification.dart';

import 'notification_repository.mock.dart';

void main() {
  late NotificationRepository repo;
  late SendNotification usecase;
  final tNotification = Notification.empty();

  setUp(() {
    repo = MockNotificationRepo();
    usecase = SendNotification(repo);
    registerFallbackValue(tNotification);
  });

  test(
    'should call the [NotificationRepo.sendNotification]',
    () async {
      when(() => repo.sendNotification(any()))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(tNotification);

      expect(result, const Right<dynamic, void>(null));

      verify(() => repo.sendNotification(tNotification)).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
