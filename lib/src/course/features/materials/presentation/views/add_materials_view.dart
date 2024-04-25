import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/common/widgets/course_picker.dart';
import 'package:tdd_education_app/core/common/widgets/information_field.dart';
import 'package:tdd_education_app/core/extensions/context_extension.dart';
import 'package:tdd_education_app/core/res/colours.dart';
import 'package:tdd_education_app/core/utils/core_utils.dart';

import 'package:tdd_education_app/src/course/domain/entities/course.dart';
import 'package:tdd_education_app/src/course/features/materials/data/models/resource_model.dart';
import 'package:tdd_education_app/src/course/features/materials/domain/entities/picked_resource.dart';
import 'package:tdd_education_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:tdd_education_app/src/course/features/materials/presentation/cubit/material_cubit.dart';

import 'package:tdd_education_app/src/course/features/materials/presentation/widgets/edit_resource_dialog.dart';

class AddMaterialsView extends StatefulWidget {
  const AddMaterialsView({super.key});

  static const routeName = '/add-materials';

  @override
  State<AddMaterialsView> createState() => _AddMaterialsViewState();
}

class _AddMaterialsViewState extends State<AddMaterialsView> {
  List<PickedResource> resources = <PickedResource>[];

  final formKey = GlobalKey<FormState>();
  final courseController = TextEditingController();
  final authorController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);

  bool authorSet = false;

  Future<void> pickResource() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        resources.addAll(
          result.paths.map(
            (path) => PickedResource(
              path: path!,
              author: authorController.text.trim(),
              title: path.split('/').last,
            ),
          ),
        );
      });
    }
  }

  Future<void> editResource(int resourceIndex) async {
    final resource = resources[resourceIndex];
    final newResource = await showDialog<PickedResource>(
      context: context,
      builder: (_) => EditResourceDialog(resource: resource),
    );
    if (newResource != null) {
      setState(() {
        resources[resourceIndex] = newResource;
      });
    }
  }

  void setAuthor() {
    if (authorSet) return;
    final text = authorController.text.trim();
    FocusManager.instance.primaryFocus?.unfocus();

    final newResources = <PickedResource>[];
    for (final resource in resources) {
      if (resource.authorManuallySet) {
        newResources.add(resource);
        continue;
      }
      newResources.add(resource.copyWith(
        author: text,
      ));
    }
    setState(() {
      resources = newResources;
      authorSet = true;
    });
  }

  void uploadMaterials() {
    if (formKey.currentState!.validate()) {
      if (this.resources.isEmpty) {
        return CoreUtils.showSnackBar(context, 'No resources picked yet');
      }
      if (!authorSet && authorController.text.trim().isNotEmpty) {
        CoreUtils.showSnackBar(
            context,
            'Please tap on the check icon in the author field '
            'to confirm the author');
      }

      final resources = <Resource>[];
      for (final resource in this.resources) {
        resources.add(
          ResourceModel.empty().copyWith(
            courseId: courseNotifier.value!.id,
            fileURL: resource.path,
            title: resource.title,
            description: resource.description,
            author: resource.author,
            fileExtension: resource.path.split('.').last,
          ),
        );
      }
      context.read<MaterialCubit>().addMaterials(resources);
    }
  }

  @override
  void dispose() {
    courseNotifier.dispose();
    courseController.dispose();
    authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Materials'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: CoursePicker(
                    controller: courseController,
                    notifier: courseNotifier,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InformationField(
                  controller: authorController,
                  border: true,
                  hintText: 'General Author',
                  onChanged: (_) {
                    if (authorSet) {
                      setState(() {
                        authorSet = false;
                      });
                    }
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      authorSet
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                    ),
                    color: authorSet ? Colors.green : Colors.grey,
                    onPressed: setAuthor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'You can upload multiple materials at once.',
                  style: context.theme.textTheme.bodySmall
                      ?.copyWith(color: Colours.neutralTextColour),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: pickResource,
                      child: const Text('Add Material'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: uploadMaterials,
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
