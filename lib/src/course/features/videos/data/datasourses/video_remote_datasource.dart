import 'package:tdd_education_app/src/course/features/videos/data/models/video_model.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/entities/video.dart';

abstract class VideoRemoteDataSource {
  Future<List<VideoModel>> getVideos(String courseId);

  Future<void> addVideo(Video video);
}

