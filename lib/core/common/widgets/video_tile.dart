import 'package:flutter/material.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/entities/video.dart';

class VideoTile extends StatelessWidget {
  const VideoTile(this.video, {super.key});

  final Video video;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
    );
  }
}
