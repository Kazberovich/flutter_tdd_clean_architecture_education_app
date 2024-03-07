import 'package:flutter/material.dart';
import 'package:tdd_education_app/core/common/widgets/course_tile.dart';
import 'package:tdd_education_app/core/common/widgets/gradient_background.dart';
import 'package:tdd_education_app/core/common/widgets/nested_back_button.dart';
import 'package:tdd_education_app/core/res/media_resources.dart';

import 'package:tdd_education_app/src/course/domain/entities/course.dart';

class AllCoursesView extends StatelessWidget {
  const AllCoursesView({required this.courses, super.key});

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const NestedBackButton(),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: GradientBackground(
        image: MediaRes.homeGradientBackground,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'All Subjects',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 40,
                  runAlignment: WrapAlignment.spaceEvenly,
                  children: courses
                      .map(
                        (course) => CourseTile(
                          course: course,
                          // TODO(Course-Details): change to pushNamed and route
                          onTap: () => Navigator.of(context).pushNamed(
                            '/unknown',
                            arguments: course,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
