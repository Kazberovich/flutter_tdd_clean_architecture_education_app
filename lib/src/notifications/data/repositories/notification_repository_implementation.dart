import 'package:dartz/dartz.dart';
import 'package:tdd_education_app/core/errors/exceptions.dart';
import 'package:tdd_education_app/core/errors/failures.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:tdd_education_app/src/notifications/domain/entities/notification.dart';
import 'package:tdd_education_app/src/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImplementation implements NotificationRepository {
  const NotificationRepositoryImplementation(this._remoteDatasource);

  final NotificationRemoteDatasource _remoteDatasource;

  @override
  ResultFuture<void> clear(String notificationId) async {
    try {
      await _remoteDatasource.clear(notificationId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> clearAll() async {
    try {
      await _remoteDatasource.clearAll();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultStream<List<Notification>> getNotifications() {
    // TODO: implement getNotifications
    throw UnimplementedError();
  }

  @override
  ResultFuture<void> markAsRead(String notificationId) {
    // TODO: implement markAsRead
    throw UnimplementedError();
  }

  @override
  ResultFuture<void> sendNotification(Notification notification) {
    // TODO: implement sendNotification
    throw UnimplementedError();
  }
}
