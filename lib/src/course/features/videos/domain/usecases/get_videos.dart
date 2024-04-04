import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/repositories/video_repository.dart';

class GetVideos extends FutureUsecaseWithParams<List<Video>, String> {
  GetVideos(this._repository);

  final VideoRepository _repository;

  @override
  ResultFuture<List<Video>> call(String params) =>
      _repository.getVideos(params);
}
