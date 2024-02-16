import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:tdd_education_app/core/enums/update_user.dart';
import 'package:tdd_education_app/core/extensions/context_extension.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final bioController = TextEditingController();

  File? pickedImage;

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
    }
  }

  bool get nameChanged =>
      context.currentUser?.fullName.trim() != fullNameController.text.trim();

  bool get emailChanged => emailController.text.isNotEmpty;

  bool get passwordChanged => passwordController.text.trim().isNotEmpty;

  bool get bioChanged =>
      context.currentUser?.bio?.trim() != bioController.text.trim();

  bool get imageChanged => pickedImage != null;

  bool get nothingChanged =>
      !nameChanged &&
      !emailChanged &&
      !passwordChanged &&
      !bioChanged &&
      !imageChanged;

  @override
  void initState() {
    fullNameController.text = context.currentUser!.fullName.trim();
    bioController.text = context.currentUser!.bio?.trim() ?? '';

    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    oldPasswordController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
