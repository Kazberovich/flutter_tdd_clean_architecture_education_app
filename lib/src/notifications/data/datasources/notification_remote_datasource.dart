import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tdd_education_app/core/errors/exceptions.dart';
import 'package:tdd_education_app/core/utils/datasource_utils.dart';
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
    try {
      DataSourceUtils.authorizedUser(_auth);
      final notificationStream = _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notifications')
          .orderBy('sentAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => NotificationModel.fromMap(doc.data()))
                .toList(),
          );
      return notificationStream.handleError((dynamic e) {
        if (e is FirebaseException) {
          throw ServerException(
            message: e.message ?? 'Unknown error occurred',
            statusCode: e.code,
          );
        }
        throw ServerException(message: e.toString(), statusCode: '505');
      });
    } on FirebaseException catch (e) {
      return Stream.error(
        ServerException(
          message: e.message ?? 'Unknown error occurred',
          statusCode: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Stream.error(e);
    } catch (e) {
      return Stream.error(
        ServerException(message: e.toString(), statusCode: '505'),
      );
    }
  }

  @override
  Future<void> markAsRead(String notificationId) {
    // TODO: implement markAsRead
    throw UnimplementedError();
  }

  @override
  Future<void> sendNotification(Notification notification) async {
    try {
      await DataSourceUtils.authorizedUser(_auth);
      // add notification to every users' notification collection
      final users = await _firestore.collection('users').get();
      if (users.docs.length > 500) {
        for (var i = 0; i < users.docs.length; i += 500) {
          final batch = _firestore.batch();
          final end = i + 500;
          final usersBatch = users.docs
              .sublist(i, end > users.docs.length ? users.docs.length : end);

          for (final user in usersBatch) {
            final newNotificationRef =
                user.reference.collection('notifications').doc();
            batch.set(
              newNotificationRef,
              (notification as NotificationModel)
                  .copyWith(id: newNotificationRef.id)
                  .toMap(),
            );
          }
          await batch.commit();
        }
      } else {
        final batch = _firestore.batch();
        for (final user in users.docs) {
          final newNotificationRef =
              user.reference.collection('notifications').doc();
          batch.set(
            newNotificationRef,
            (notification as NotificationModel)
                .copyWith(id: newNotificationRef.id)
                .toMap(),
          );
        }
        await batch.commit();
      }
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
