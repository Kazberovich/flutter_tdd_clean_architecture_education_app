import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/repositories/video_repository.dart';

class AddVideo extends FutureUsecaseWithParams<void, Video> {
  AddVideo(this._repository);

  final VideoRepository _repository;

  @override
  ResultFuture<void> call(Video params) => _repository.addVideo(params);
}
