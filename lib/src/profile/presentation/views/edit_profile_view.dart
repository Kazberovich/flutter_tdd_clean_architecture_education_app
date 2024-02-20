import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:tdd_education_app/core/common/widgets/gradient_background.dart';
import 'package:tdd_education_app/core/common/widgets/nested_back_button.dart';
import 'package:tdd_education_app/core/enums/update_user.dart';
import 'package:tdd_education_app/core/extensions/context_extension.dart';
import 'package:tdd_education_app/core/res/media_resources.dart';
import 'package:tdd_education_app/core/utils/core_utils.dart';
import 'package:tdd_education_app/src/authentication/presentation/bloc/authentication_bloc.dart';

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
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          CoreUtils.showSnackBar(context, 'Profile updated Successfully');
          context.pop();
        } else if (state is AuthenticationError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: const NestedBackButton(),
            title: const Text(
              'Edit Profile',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (nothingChanged) context.pop();

                  final bloc = context.read<AuthenticationBloc>();

                  if (passwordChanged) {
                    if (oldPasswordController.text.isEmpty) {
                      CoreUtils.showSnackBar(
                        context,
                        'Please enter your old password',
                      );
                      return;
                    }
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.password,
                        userData: jsonEncode({
                          'oldPassword': oldPasswordController.text.trim(),
                          'newPassword': passwordController.text.trim(),
                        }),
                      ),
                    );
                  }

                  if (nameChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.displayName,
                        userData: fullNameController.text.trim(),
                      ),
                    );
                  }

                  if (emailChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.email,
                        userData: emailController.text.trim(),
                      ),
                    );
                  }

                  if (bioChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.bio,
                        userData: bioController.text.trim(),
                      ),
                    );
                  }

                  if (imageChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.profilePicture,
                        userData: pickedImage,
                      ),
                    );
                  }
                },
                child: state is AuthenticationLoading
                    ? const Center(child: CircularProgressIndicator())
                    : StatefulBuilder(
                        builder: (_, refresh) {
                          fullNameController.addListener(() => refresh(() {}));
                          emailController.addListener(() => refresh(() {}));
                          passwordController.addListener(() => refresh(() {}));
                          bioController.addListener(() => refresh(() {}));
                          return Text(
                            'Done',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: nothingChanged
                                  ? Colors.grey
                                  : Colors.blueAccent,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          body: GradientBackground(
            image: MediaRes.profileGradientBackground,
            child: ListView(
              children: [
                Builder(
                  builder: (context) {
                    final user = context.currentUser!;
                    debugPrint(user.toString());
                    debugPrint(user.profilePicture);
                    final userImage = user.profilePicture == null ||
                            user.profilePicture!.isEmpty
                        ? null
                        : user.profilePicture;
                    return Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: pickedImage != null
                              ? FileImage(pickedImage!)
                              : userImage != null
                                  ? NetworkImage(userImage)
                                  : const AssetImage(MediaRes.user)
                                      as ImageProvider,
                        ),
                      ),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(.5),
                            ),
                          ),
                          IconButton(
                            onPressed: pickImage,
                            icon: Icon(
                              (pickedImage != null ||
                                      user.profilePicture != null)
                                  ? Icons.edit
                                  : Icons.add_a_photo,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
