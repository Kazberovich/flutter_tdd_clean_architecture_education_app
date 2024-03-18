import 'package:equatable/equatable.dart';

class Video extends Equatable {
  const Video({
    required this.id,
    required this.videoUrl,
    required this.courseId,
    required this.uploadDate,
    this.thumbnailIsFile = false,
    this.thumbnail,
    this.title,
    this.tutor,
  });

  Video.empty()
      : this(
          id: '_empty.id',
          videoUrl: '_empty.videoUrl',
          uploadDate: DateTime.now(),
          courseId: '_empty.courseId',
        );

  final String id;
  final String? thumbnail;
  final String videoUrl;
  final String? title;
  final String? tutor;
  final String courseId;
  final DateTime uploadDate;
  final bool thumbnailIsFile;

  @override
  List<Object?> get props => [id];
}
