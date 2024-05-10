import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/common/widgets/course_tile.dart';
import 'package:tdd_education_app/core/extensions/context_extension.dart';
import 'package:tdd_education_app/core/services/injection_container.dart';
import 'package:tdd_education_app/src/course/domain/entities/course.dart';
import 'package:tdd_education_app/src/course/features/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:tdd_education_app/src/course/features/exams/presentation/views/course_exams_view.dart';
import 'package:tdd_education_app/src/course/features/materials/presentation/app/cubit/material_cubit.dart';
import 'package:tdd_education_app/src/course/features/materials/presentation/views/course_materials_view.dart';

class DocumentsAndExamBody extends StatelessWidget {
  const DocumentsAndExamBody({
    required this.courses,
    required this.index,
    super.key,
  });

  final List<Course> courses;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20).copyWith(top: 0),
      children: [
        const SizedBox(height: 5),
        Center(
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            runAlignment: WrapAlignment.spaceEvenly,
            children: courses.map((course) {
              return CourseTile(
                course: course,
                onTap: () {
                  context.push(
                    index == 0
                        ? BlocProvider(
                            create: (_) => serviceLocator<MaterialCubit>(),
                            child: CourseMaterialsView(course),
                          )
                        : BlocProvider(
                            create: (_) => serviceLocator<ExamCubit>(),
                            child: CourseExamsView(course),
                          ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
