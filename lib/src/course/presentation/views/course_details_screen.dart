import 'package:flutter/material.dart';
import 'package:tdd_education_app/core/common/widgets/course_info_tile.dart';
import 'package:tdd_education_app/core/common/widgets/expandable_text.dart';
import 'package:tdd_education_app/core/common/widgets/gradient_background.dart';
import 'package:tdd_education_app/core/extensions/context_extension.dart';
import 'package:tdd_education_app/core/extensions/int_extesions.dart';
import 'package:tdd_education_app/core/res/media_resources.dart';
import 'package:tdd_education_app/src/course/data/models/course_model.dart';
import 'package:tdd_education_app/src/course/domain/entities/course.dart';
import 'package:tdd_education_app/src/course/features/exams/presentation/views/course_exams_view.dart';
import 'package:tdd_education_app/src/course/features/materials/presentation/views/course_materials_view.dart';
import 'package:tdd_education_app/src/course/features/videos/presentation/views/course_videos_view.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({required this.course, super.key});

  static const routeName = '/course-details';

  final Course course;

  @override
  Widget build(BuildContext context) {
    final course = (this.course as CourseModel).copyWith(
      numberOfExams: 3,
      numberOfMaterials: 24,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(course.title),
      ),
      body: GradientBackground(
        image: MediaRes.homeGradientBackground,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              SizedBox(
                height: context.height * .3,
                child: Center(
                  child: course.image != null
                      ? Image.network(course.image!)
                      : Image.asset(
                          MediaRes.casualMeditation,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (course.description != null)
                    ExpandableText(text: course.description!, context: context),
                  if (course.numberOfMaterials > 0 ||
                      course.numberOfVideos > 0 ||
                      course.numberOfExams > 0) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Subject details: ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (course.numberOfVideos > 0) ...[
                      const SizedBox(height: 10),
                      CourseInfoTile(
                        onTap: () => Navigator.of(context).pushNamed(
                          CourseVideosView.routeName,
                          arguments: course,
                        ),
                        image: MediaRes.courseInfoVideo,
                        title: '${course.numberOfVideos} Video(s)',
                        subtitle:
                            'Watch our tutorial videos for ${course.title}',
                      ),
                    ],
                    if (course.numberOfExams > 0) ...[
                      const SizedBox(height: 10),
                      CourseInfoTile(
                        onTap: () => Navigator.of(context).pushNamed(
                          CourseExamsView.routeName,
                          arguments: course,
                        ),
                        image: MediaRes.examQuestions,
                        title: '${course.numberOfExams} Exam(s)',
                        subtitle: 'Take our exams for ${course.title}',
                      ),
                    ],
                    if (course.numberOfMaterials > 0) ...[
                      const SizedBox(height: 10),
                      CourseInfoTile(
                        onTap: () => Navigator.of(context).pushNamed(
                          CourseMaterialsView.routeName,
                          arguments: course,
                        ),
                        image: MediaRes.courseInfoMaterial,
                        title: '${course.numberOfMaterials} Material(s)',
                        subtitle:
                            'Access to ${course.numberOfMaterials.estimate} '
                            'materials for ${course.title}',
                      ),
                    ],
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
