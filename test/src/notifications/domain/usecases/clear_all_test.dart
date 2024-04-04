import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/src/notifications/domain/repositories/notification_repository.dart';
import 'package:tdd_education_app/src/notifications/domain/usecases/clear_all.dart';

import 'notification_repository.mock.dart';

void main() {
  late NotificationRepository repo;
  late ClearAll usecase;

  setUp(() {
    repo = MockNotificationRepo();
    usecase = ClearAll(repo);
  });

  test(
    'should call the [NotificationRepo.clearAll]',
    () async {
      when(() => repo.clearAll()).thenAnswer((_) async => const Right(null));

      final result = await usecase();

      expect(result, const Right<dynamic, void>(null));

      verify(() => repo.clearAll()).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
