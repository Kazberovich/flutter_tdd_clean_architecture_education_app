import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/notifications/domain/entities/notification.dart';

abstract class NotificationRepository {
  const NotificationRepository();

  ResultFuture<void> markAsRead(String notificationId);

  ResultFuture<void> clearAll();

  ResultFuture<void> clear(String notificationId);

  ResultFuture<void> sendNotification(Notification notification);

  ResultStream<List<Notification>> getNotifications();
}
