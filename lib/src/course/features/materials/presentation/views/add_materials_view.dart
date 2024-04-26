import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide MaterialState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/common/widgets/course_picker.dart';
import 'package:tdd_education_app/core/common/widgets/information_field.dart';
import 'package:tdd_education_app/core/enums/notification_enum.dart';
import 'package:tdd_education_app/core/extensions/context_extension.dart';
import 'package:tdd_education_app/core/extensions/int_extension.dart';
import 'package:tdd_education_app/core/res/colours.dart';
import 'package:tdd_education_app/core/utils/core_utils.dart';

import 'package:tdd_education_app/src/course/domain/entities/course.dart';
import 'package:tdd_education_app/src/course/features/materials/data/models/resource_model.dart';
import 'package:tdd_education_app/src/course/features/materials/domain/entities/picked_resource.dart';
import 'package:tdd_education_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:tdd_education_app/src/course/features/materials/presentation/cubit/material_cubit.dart';

import 'package:tdd_education_app/src/course/features/materials/presentation/widgets/edit_resource_dialog.dart';
import 'package:tdd_education_app/src/course/features/materials/presentation/widgets/picked_resource_tile.dart';
import 'package:tdd_education_app/src/notifications/presentation/widgets/notification_wrapper.dart';

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
      newResources.add(
        resource.copyWith(
          author: text,
        ),
      );
    }
    setState(() {
      resources = newResources;
      authorSet = true;
    });
  }

  bool showingLoader = false;

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
    return NotificationWrapper(
      onNotificationSent: () {
        Navigator.pop(context);
      },
      child: BlocListener<MaterialCubit, MaterialState>(
        listener: (context, state) {
          if (showingLoader) {
            Navigator.pop(context);
            showingLoader = false;
          }

          if (state is MaterialError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is MaterialsAdded) {
            CoreUtils.showSnackBar(
              context,
              'Material(s) uploaded successfully',
            );
            CoreUtils.sendNotification(
              context,
              title: 'New ${courseNotifier.value!.title} '
                  'Material${resources.length.pluralize}',
              body: 'A new material has been uploaded '
                  'for ${courseNotifier.value!.title}',
              category: NotificationCategory.MATERIAL,
            );
          } else if (state is AddingMaterials) {
            CoreUtils.showLoadingDialog(context);
            showingLoader = true;
          }
        },
        child: Scaffold(
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
                    if (resources.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemBuilder: (_, index) {
                            final resource = resources[index];
                            return PickedResourceTile(
                              resource: resource,
                              onEdit: () => editResource(index),
                              onDelete: () {
                                setState(() {
                                  resources.removeAt(index);
                                });
                              },
                            );
                          },
                          itemCount: resources.length,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
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
        ),
      ),
    );
  }
}
