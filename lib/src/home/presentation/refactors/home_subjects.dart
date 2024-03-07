import 'package:flutter/material.dart';
import 'package:tdd_education_app/core/extensions/context_extension.dart';

import 'package:tdd_education_app/src/course/domain/entities/course.dart';
import 'package:tdd_education_app/src/home/presentation/views/section_header.dart';

class HomeSubjects extends StatelessWidget {
  const HomeSubjects({
    required this.courses,
    super.key,
  });

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          sectionTitle: 'Courses',
          seAll: courses.length > 4,
          onSeeAll: () => context.push(
            const Placeholder(),
          ),
        ),
      ],
    );
  }
}
