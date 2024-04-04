import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/notifications/domain/entities/notification.dart';
import 'package:tdd_education_app/src/notifications/domain/repositories/notification_repository.dart';

class GetNotifications extends StreamUsecaseWithoutParams<List<Notification>> {
  const GetNotifications(this._repository);

  final NotificationRepository _repository;

  @override
  ResultStream<List<Notification>> call() => _repository.getNotifications();
}
