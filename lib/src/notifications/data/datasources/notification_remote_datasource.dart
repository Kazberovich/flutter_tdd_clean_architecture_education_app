import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tdd_education_app/src/notifications/data/models/notification_model.dart';
import 'package:tdd_education_app/src/notifications/domain/entities/notification.dart';

abstract class NotificationRemoteDatasource {
  const NotificationRemoteDatasource();

  Future<void> markAsRead(String notificationId);

  Future<void> clearAll();

  Future<void> clear(String notificationId);

  Future<void> sendNotification(Notification notification);

  Stream<List<NotificationModel>> getNotifications();
}

class NotificationRemoteDatasourceImplementation
    implements NotificationRemoteDatasource {
  NotificationRemoteDatasourceImplementation(
      {required FirebaseFirestore firestore, required FirebaseAuth auth})
      : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Future<void> clear(String notificationId) {
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  Future<void> clearAll() {
    // TODO: implement clearAll
    throw UnimplementedError();
  }

  @override
  Stream<List<NotificationModel>> getNotifications() {
    // TODO: implement getNotifications
    throw UnimplementedError();
  }

  @override
  Future<void> markAsRead(String notificationId) {
    // TODO: implement markAsRead
    throw UnimplementedError();
  }

  @override
  Future<void> sendNotification(Notification notification) {
    // TODO: implement sendNotification
    throw UnimplementedError();
  }
}
