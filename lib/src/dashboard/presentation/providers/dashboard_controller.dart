import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tdd_education_app/core/common/app/providers/tab_navigator.dart';
import 'package:tdd_education_app/core/common/views/persistent_view.dart';
import 'package:tdd_education_app/core/services/injection_container.dart';
import 'package:tdd_education_app/src/course/features/videos/presentation/cubit/video_cubit.dart';
import 'package:tdd_education_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:tdd_education_app/src/home/presentation/views/home_view.dart';
import 'package:tdd_education_app/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:tdd_education_app/src/profile/presentation/views/profile_view.dart';

class DashboardController extends ChangeNotifier {
  List<int> _indexHistory = [0];

  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => serviceLocator<CourseCubit>()),
              BlocProvider(create: (_) => serviceLocator<VideoCubit>()),
              BlocProvider(create: (_) => serviceLocator<NotificationCubit>()),
            ],
            child: const HomeView(),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: const Placeholder(),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: const Placeholder(),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: const ProfileView(),
        ),
      ),
      child: const PersistentView(),
    ),
  ];

  List<Widget> get screens => _screens;

  int _currentIndex = 3; // profile

  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    _indexHistory.add(index);
    notifyListeners();
  }

  void goBack() {
    if (_indexHistory.length == 1) return;
    _indexHistory.removeLast();
    _currentIndex = _indexHistory.last;
    notifyListeners();
  }

  void resetIndex() {
    _indexHistory = [0];
    _currentIndex = 0;
    notifyListeners();
  }
}
