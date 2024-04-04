import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/notifications/domain/repositories/notification_repository.dart';

class MarkAsRead extends UsecaseWithParams<void, String> {
  const MarkAsRead(this._repo);

  final NotificationRepository _repo;

  @override
  ResultFuture<void> call(String params) => _repo.markAsRead(params);
}
