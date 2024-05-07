import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_education_app/core/common/views/page_under_construction.dart';
import 'package:tdd_education_app/core/extensions/context_extension.dart';
import 'package:tdd_education_app/core/services/injection_container.dart';
import 'package:tdd_education_app/src/authentication/data/models/user_model.dart';
import 'package:tdd_education_app/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:tdd_education_app/src/authentication/presentation/views/sign_in_screen.dart';
import 'package:tdd_education_app/src/authentication/presentation/views/sign_up_screen.dart';
import 'package:tdd_education_app/src/course/domain/entities/course.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:tdd_education_app/src/course/features/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:tdd_education_app/src/course/features/exams/presentation/app/providers/exam_controller.dart';
import 'package:tdd_education_app/src/course/features/exams/presentation/views/add_exam_view.dart';
import 'package:tdd_education_app/src/course/features/exams/presentation/views/course_exams_view.dart';
import 'package:tdd_education_app/src/course/features/exams/presentation/views/exam_details_view.dart';
import 'package:tdd_education_app/src/course/features/exams/presentation/views/exam_view.dart';
import 'package:tdd_education_app/src/course/features/materials/presentation/app/cubit/material_cubit.dart';
import 'package:tdd_education_app/src/course/features/materials/presentation/views/add_materials_view.dart';
import 'package:tdd_education_app/src/course/features/materials/presentation/views/course_materials_view.dart';
import 'package:tdd_education_app/src/course/features/videos/presentation/cubit/video_cubit.dart';
import 'package:tdd_education_app/src/course/features/videos/presentation/views/add_videos_view.dart';
import 'package:tdd_education_app/src/course/features/videos/presentation/views/course_videos_view.dart';
import 'package:tdd_education_app/src/course/features/videos/presentation/views/video_player_view.dart';
import 'package:tdd_education_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:tdd_education_app/src/course/presentation/views/course_details_screen.dart';
import 'package:tdd_education_app/src/dashboard/presentation/views/dashboard_screen.dart';
import 'package:tdd_education_app/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:tdd_education_app/src/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:tdd_education_app/src/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:tdd_education_app/src/onboarding/presentation/views/onboarding_screen.dart';
import 'package:provider/provider.dart';

part 'router.main.dart';
