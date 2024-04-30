import 'package:flutter/material.dart' hide MaterialState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/common/views/loading_view.dart';
import 'package:tdd_education_app/core/common/widgets/gradient_background.dart';
import 'package:tdd_education_app/core/common/widgets/nested_back_button.dart';
import 'package:tdd_education_app/core/common/widgets/not_found_text.dart';
import 'package:tdd_education_app/core/res/media_resources.dart';
import 'package:tdd_education_app/core/services/injection_container.dart';
import 'package:tdd_education_app/core/utils/core_utils.dart';
import 'package:tdd_education_app/src/course/domain/entities/course.dart';
import 'package:tdd_education_app/src/course/features/materials/domain/entities/resource.dart';

import 'package:tdd_education_app/src/course/features/materials/presentation/app/cubit/material_cubit.dart';
import 'package:provider/provider.dart';
import 'package:tdd_education_app/src/course/features/materials/presentation/app/resource_controller.dart';

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('${widget.course.title} Materials'),
        leading: const NestedBackButton(),
      ),
      body: GradientBackground(
        image: MediaRes.documentsGradientBackground,
        child: BlocConsumer<MaterialCubit, MaterialState>(
          listener: (_, state) {
            if (state is MaterialError) {
              CoreUtils.showSnackBar(context, state.message);
            }
          },
          builder: (_, state) {
            if (state is LoadingMaterials) {
              return const LoadingView();
            } else if ((state is MaterialsLoaded && state.materials.isEmpty) ||
                state is MaterialError) {
              return NotFoundText(
                'No materials found for ${widget.course.title}',
              );
            } else if (state is MaterialsLoaded) {
              final materials = state.materials
                ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));

              return SafeArea(
                child: ListView.separated(
                  separatorBuilder: (_, __) => const Divider(
                    color: Color(0xFFE6E8EC),
                  ),
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (_, index) {
                    return ChangeNotifierProvider(
                      create: (_) => serviceLocator<ResourceController>()
                        ..initResource(materials[index]),
                      child: const Placeholder(
                        fallbackHeight: 20,
                      ),
                    );
                  },
                  itemCount: materials.length,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
