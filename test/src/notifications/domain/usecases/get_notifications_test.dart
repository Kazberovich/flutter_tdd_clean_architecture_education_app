import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/src/notifications/domain/entities/notification.dart';
import 'package:tdd_education_app/src/notifications/domain/repositories/notification_repository.dart';
import 'package:tdd_education_app/src/notifications/domain/usecases/get_notifications.dart';

import 'notification_repository.mock.dart';

void main() {
  late NotificationRepository repo;
  late GetNotifications usecase;

  setUp(() {
    repo = MockNotificationRepo();
    usecase = GetNotifications(repo);
  });

  test(
    'should return a [Stream<List<Notification>>] from the [NotificationRepo]',
    () async {
      when(() => repo.getNotifications())
          .thenAnswer((_) => Stream.value(const Right([])));

      final result = usecase();

      expect(result, emits(const Right<dynamic, List<Notification>>([])));

      verify(() => repo.getNotifications()).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
