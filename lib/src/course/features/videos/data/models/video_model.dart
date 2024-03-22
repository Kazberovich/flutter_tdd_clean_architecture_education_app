import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.videoUrl,
    required super.courseId,
    required super.uploadDate,
    super.thumbnailIsFile = false,
    super.thumbnail,
    super.title,
    super.tutor,
  });

  VideoModel.empty()
      : this(
          id: '_empty.id',
          videoUrl: '_empty.videoUrl',
          uploadDate: DateTime.now(),
          courseId: '_empty.courseId',
        );

  VideoModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String,
          videoUrl: map['videoUrl'] as String,
          courseId: map['courseId'] as String,
          uploadDate: (map['uploadDate'] as Timestamp).toDate(),
          thumbnail: map['thumbnail'] as String?,
          title: map['title'] as String?,
          tutor: map['tutor'] as String?,
        );

  DataMap toMap() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'videoUrl': videoUrl,
      'title': title,
      'tutor': tutor,
      'courseId': courseId,
      'uploadDate': FieldValue.serverTimestamp(),
    };
  }

  VideoModel copyWith({
    String? id,
    String? thumbnail,
    String? videoUrl,
    String? title,
    String? tutor,
    String? courseId,
    DateTime? uploadDate,
    bool? thumbnailIsFile,
  }) {
    return VideoModel(
      id: id ?? this.id,
      thumbnail: thumbnail ?? this.thumbnail,
      videoUrl: videoUrl ?? this.videoUrl,
      title: title ?? this.title,
      tutor: tutor ?? this.tutor,
      courseId: courseId ?? this.courseId,
      uploadDate: uploadDate ?? this.uploadDate,
      thumbnailIsFile: thumbnailIsFile ?? this.thumbnailIsFile,
    );
  }
}
