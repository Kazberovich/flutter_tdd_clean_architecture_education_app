import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:tdd_education_app/core/common/widgets/course_picker.dart';
import 'package:tdd_education_app/core/common/widgets/information_field.dart';
import 'package:tdd_education_app/core/common/widgets/reactive_button.dart';
import 'package:tdd_education_app/core/common/widgets/video_tile.dart';
import 'package:tdd_education_app/core/enums/notification_enum.dart';
import 'package:tdd_education_app/core/extensions/string_extentsions.dart';
import 'package:tdd_education_app/core/utils/core_utils.dart';
import 'package:tdd_education_app/src/course/domain/entities/course.dart';
import 'package:tdd_education_app/src/course/features/videos/data/models/video_model.dart';
import 'package:tdd_education_app/src/course/features/videos/presentation/cubit/video_cubit.dart';
import 'package:tdd_education_app/src/course/features/videos/presentation/utils/video_utils.dart';
import 'package:tdd_education_app/src/notifications/presentation/widgets/notification_wrapper.dart';

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
  bool showingDialog = false;

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

    authorController.addListener(() {
      video = video?.copyWith(tutor: authorController.text.trim());
    });

    titleController.addListener(() {
      video = video?.copyWith(title: titleController.text.trim());
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
    return NotificationWrapper(
      onNotificationSent: () {
        Navigator.pop(context);
      },
      child: BlocListener<VideoCubit, VideoState>(
        listener: (context, state) {
          if (showingDialog == true) {
            Navigator.pop(context);
            showingDialog = false;
          }
          if (state is AddingVideo) {
            CoreUtils.showLoadingDialog(context);
            showingDialog = true;
          } else if (state is VideoError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is VideoAdded) {
            CoreUtils.showSnackBar(context, 'Video added successfully');
            CoreUtils.sendNotification(
              context,
              title: 'New (${courseNotifier.value!.title.trim()})',
              body: 'A new video has been added',
              category: NotificationCategory.VIDEO,
            );
          }
        },
        child: Scaffold(
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
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: VideoTile(
                    video!,
                    isFile: thumbnailIsFile,
                    uploadTimePrefix: '~  ',
                  ),
                ),
              if (getMoreDetails) ...[
                InformationField(
                  controller: authorController,
                  keyboardType: TextInputType.name,
                  autoFocus: true,
                  focusNode: authorFocusNode,
                  labelText: 'Tutor Name',
                  onEditingComplete: () {
                    setState(() {});
                    titleFocusNode.requestFocus();
                  },
                ),
                InformationField(
                  controller: titleController,
                  labelText: 'Video Title',
                  focusNode: titleFocusNode,
                  onEditingComplete: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {});
                  },
                ),
              ],
              const SizedBox(height: 20),
              Center(
                child: ReactiveButton(
                  disabled: video == null,
                  loading: loading == true,
                  text: 'Submit',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (courseNotifier.value == null) {
                        CoreUtils.showSnackBar(context, 'Please pick a course');
                        return;
                      }
                      if (courseNotifier.value != null &&
                          video != null &&
                          video!.tutor == null &&
                          authorController.text.trim().isNotEmpty) {
                        video = video!.copyWith(
                          tutor: authorController.text.trim(),
                        );
                      }
                      if (video != null &&
                          video!.tutor != null &&
                          video!.title != null &&
                          video!.title!.isNotEmpty) {
                        video = video?.copyWith(
                          thumbnailIsFile: thumbnailIsFile,
                          courseId: courseNotifier.value!.id,
                          uploadDate: DateTime.now(),
                        );
                        context.read<VideoCubit>().addVideo(video!);
                      } else {
                        CoreUtils.showSnackBar(
                          context,
                          'Please fill all fields',
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
