import 'package:dartz/dartz.dart';
import 'package:tdd_education_app/core/errors/exceptions.dart';
import 'package:tdd_education_app/core/errors/failures.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/features/videos/data/datasourses/video_remote_datasource.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/repositories/video_repository.dart';

class VideoRepositoryImplementation implements VideoRepository {
  const VideoRepositoryImplementation(this._remoteDataSourse);

  final VideoRemoteDataSource _remoteDataSourse;

  @override
  ResultFuture<void> addVideo(Video video) async {
    try {
      await _remoteDataSourse.addVideo(video);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Video>> getVideos(String courseId) async {
    try {
      final result = await _remoteDataSourse.getVideos(courseId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
