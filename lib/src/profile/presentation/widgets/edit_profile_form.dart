import 'package:flutter/material.dart';
import 'package:tdd_education_app/core/extensions/context_extension.dart';
import 'package:tdd_education_app/core/extensions/string_extentsions.dart';
import 'package:tdd_education_app/src/profile/presentation/widgets/edit_profile_form_field.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.oldPasswordController,
    required this.bioController,
    super.key,
  });

  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController oldPasswordController;
  final TextEditingController bioController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditProfileFormField(
            fieldTitle: 'FULL NAME',
            controller: fullNameController,
            hintText: context.currentUser!.fullName,
          ),
          EditProfileFormField(
            fieldTitle: 'EMAIL',
            controller: emailController,
            hintText: context.currentUser!.email.obscureEmail,
          ),
          EditProfileFormField(
            fieldTitle: 'CURRENT PASSWORD',
            controller: oldPasswordController,
            hintText: '********',
          ),
          StatefulBuilder(
            builder: (context, setState) {
              oldPasswordController.addListener(() => setState(() {}));
              return EditProfileFormField(
                fieldTitle: 'NEW PASSWORD',
                controller: passwordController,
                hintText: '********',
                readOnly: oldPasswordController.text.isEmpty,
              );
            },
          ),
          EditProfileFormField(
            fieldTitle: 'BIO',
            controller: bioController,
            hintText: context.currentUser!.bio!,
          ),
        ],
      ),
    );
  }
}
