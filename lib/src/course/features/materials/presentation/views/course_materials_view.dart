import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/src/course/domain/entities/course.dart';
import 'package:tdd_education_app/src/course/features/materials/presentation/cubit/material_cubit.dart';

class CourseMaterialsView extends StatefulWidget {
  const CourseMaterialsView(
    this.course, {
    super.key,
  });

  static const routeName = '/course-materials';

  final Course course;

  @override
  State<CourseMaterialsView> createState() => _CourseMaterialsViewState();
}

class _CourseMaterialsViewState extends State<CourseMaterialsView> {
  void getMaterials() {
    context.read<MaterialCubit>().getMaterials(widget.course.id);
  }

  @override
  void initState() {
    super.initState();
    getMaterials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
