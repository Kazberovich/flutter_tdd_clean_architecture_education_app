import 'package:flutter/cupertino.dart';
import 'package:tdd_education_app/core/utils/core_utils.dart';
import 'package:tdd_education_app/src/course/features/videos/data/models/video_model.dart';

import 'package:tdd_education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:youtube_metadata/youtube_metadata.dart';

class VideoUtils {
  const VideoUtils._();

  static Future<Video?> getVideoFromYoutube(
    BuildContext context, {
    required String url,
  }) async {
    void showSnack(String message) => CoreUtils.showSnackBar(context, message);

    try {
      final metadata = await YoutubeMetaData.getData(url);
      final missingData = <String>[];
      if (metadata.thumbnailUrl == null) missingData.add('thumbnailUrl');
      if (metadata.title == null) missingData.add('title');
      if (metadata.authorName == null) missingData.add('authorName');
      final missingDataText = missingData.fold(
        ' ',
        (previousValue, element) => '$previousValue$element, ',
      );

      if (metadata.thumbnailUrl == null ||
          metadata.title == null ||
          metadata.authorName == null) {
        final message = 'Could not get video data. Please try again. \n '
            'The following data is missing: $missingDataText';
        showSnack(message);
        return null;
      }

      return VideoModel.empty().copyWith(
        thumbnail: metadata.thumbnailUrl,
        videoUrl: metadata.url,
        title: metadata.title,
        tutor: metadata.authorName,
      );
    } catch (e) {
      showSnack('Please try again. \n$e');
      return null;
    }
  }
}