import 'package:flutter/material.dart';
import 'package:tdd_education_app/src/course/domain/entities/course.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({required this.course, super.key});

  static const routeName = '/course-details';

  final Course course;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
