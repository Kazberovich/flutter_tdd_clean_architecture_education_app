import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/common/app/providers/course_of_the_day_notifier.dart';
import 'package:tdd_education_app/core/common/views/loading_view.dart';
import 'package:tdd_education_app/core/common/widgets/not_found_text.dart';
import 'package:tdd_education_app/core/utils/core_utils.dart';
import 'package:tdd_education_app/src/course/presentation/cubit/course_cubit.dart';

import 'package:tdd_education_app/src/home/presentation/refactors/home_header.dart';
import 'package:tdd_education_app/src/home/presentation/refactors/home_subjects.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  void getCourses() {
    context.read<CourseCubit>().getCourses();
  }

  @override
  void initState() {
    super.initState();
    getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseCubit, CourseState>(
      listener: (_, state) {
        if (state is CourseError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is CoursesLoaded && state.courses.isNotEmpty) {
          final courses = state.courses..shuffle();
          final courseOfDay = courses.first;
          context.read<CourseOfTheDayNotifier>().setCourseOfTheDay(courseOfDay);
        }
      },
      builder: (BuildContext context, Object? state) {
        if (state is LoadingCourses) {
          return const LoadingView();
        } else if (state is CoursesLoaded && state.courses.isEmpty ||
            state is CourseError) {
          return const Center(
            child: NotFoundText('No courses found\nPlease contact admin'),
          );
        } else if (state is CoursesLoaded) {
          final courses = state.courses
            ..sort(
              (a, b) => b.updatedAt.compareTo(a.updatedAt),
            );

          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            children: [
              const HomeHeader(),
              const SizedBox(height: 20),
              HomeSubjects(
                courses: courses,
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
