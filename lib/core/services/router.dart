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
import 'package:tdd_education_app/src/dashboard/presentation/views/dashboard_screen.dart';
import 'package:tdd_education_app/src/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:tdd_education_app/src/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:tdd_education_app/src/onboarding/presentation/views/onboarding_screen.dart';

part 'router.main.dart';
