import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/notifications/domain/entities/notification.dart';
import 'package:tdd_education_app/src/notifications/domain/repositories/notification_repository.dart';

class SendNotification extends FutureUsecaseWithParams<void, Notification> {
  const SendNotification(this._repo);

  final NotificationRepository _repo;

  @override
  ResultFuture<void> call(Notification params) =>
      _repo.sendNotification(params);
}
