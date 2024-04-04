import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/notifications/domain/repositories/notification_repository.dart';

class ClearAll extends UsecaseWithoutParams<void> {
  const ClearAll(this._repo);

  final NotificationRepository _repo;

  @override
  ResultFuture<void> call() => _repo.clearAll();
}
