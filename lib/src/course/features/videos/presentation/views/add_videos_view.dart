import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:tdd_education_app/core/common/widgets/course_picker.dart';
import 'package:tdd_education_app/core/common/widgets/information_field.dart';
import 'package:tdd_education_app/core/extensions/string_extentsions.dart';
import 'package:tdd_education_app/src/course/domain/entities/course.dart';
import 'package:tdd_education_app/src/course/features/videos/data/models/video_model.dart';
import 'package:tdd_education_app/src/course/features/videos/presentation/utils/video_utils.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;

import 'package:tdd_education_app/core/common/widgets/video_tile.dart';

class AddVideoView extends StatefulWidget {
  const AddVideoView({super.key});

  static const routeName = '/add-videos';

  @override
  State<AddVideoView> createState() => _AddVideoViewState();
}

class _AddVideoViewState extends State<AddVideoView> {
  final urlController = TextEditingController();
  final authorController = TextEditingController(text: 'dbstech');
  final titleController = TextEditingController();
  final courseController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);

  final formKey = GlobalKey<FormState>();
  VideoModel? video;
  PreviewData? previewData;

  final authorFocusNode = FocusNode();
  final titleFocusNode = FocusNode();
  final urlFocusNode = FocusNode();

  bool getMoreDetails = false;

  bool get isYoutubeLink => urlController.text.trim().isYoutubeVideo;

  bool thumbnailIsFile = false;
  bool loading = false;

  void reset() {
    setState(() {
      urlController.clear();
      authorController.text = 'dbstech';
      titleController.clear();
      getMoreDetails = false;
      loading = false;
      video = null;
      previewData = null;
    });
  }

  @override
  void initState() {
    super.initState();
    urlController.addListener(() {
      if (urlController.text.trim().isEmpty) reset();
    });
  }

  Future<void> fetchVideo() async {
    if (urlController.text.trim().isEmpty) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      getMoreDetails = false;
      loading = false;
      thumbnailIsFile = false;
      video = null;
      previewData = null;
    });

    setState(() {
      loading = true;
    });

    if (isYoutubeLink) {
      video = await VideoUtils.getVideoFromYoutube(
        context,
        url: urlController.text.trim(),
      ) as VideoModel?;
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    urlController.dispose();
    authorController.dispose();
    titleController.dispose();
    courseController.dispose();
    courseNotifier.dispose();
    urlFocusNode.dispose();
    titleFocusNode.dispose();
    authorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Video'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        children: [
          Form(
            key: formKey,
            child: CoursePicker(
              controller: courseController,
              notifier: courseNotifier,
            ),
          ),
          const SizedBox(height: 20),
          InformationField(
            controller: urlController,
            hintText: 'Enter video URL',
            onEditingComplete: fetchVideo,
            focusNode: urlFocusNode,
            onTapOutside: (_) => urlFocusNode.unfocus(),
            keyboardType: TextInputType.url,
            autoFocus: true,
          ),
          ListenableBuilder(
            listenable: urlController,
            builder: (_, __) {
              return Column(
                children: [
                  if (urlController.text.trim().isNotEmpty) ...[
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: fetchVideo,
                      child: const Text('FetchVideo'),
                    ),
                  ],
                ],
              );
            },
          ),
          if (loading && !isYoutubeLink)
            LinkPreview(
              onPreviewDataFetched: (data) async {
                setState(() {
                  thumbnailIsFile = false;
                  video = VideoModel.empty().copyWith(
                    thumbnail: data.image?.url,
                    videoUrl: urlController.text.trim(),
                    title: data.title ?? 'No title',
                  );
                  if (data.image?.url != null) loading = false;
                  getMoreDetails = true;
                  titleController.text = data.title ?? '';
                  loading = false;
                });
              },
              previewData: previewData,
              text: '',
              width: 0,
            ),
          if (video != null)
            VideoTile(video!),
        ],
      ),
    );
  }
}
