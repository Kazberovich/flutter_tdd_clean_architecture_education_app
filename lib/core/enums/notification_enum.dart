// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tdd_education_app/core/res/media_resources.dart';

enum NotificationCategory {
  TEST(value: 'test', image: MediaRes.test),
  VIDEO(value: 'video', image: MediaRes.video),
  MATERIAL(value: 'material', image: MediaRes.material),
  COURSE(value: 'course', image: MediaRes.course),
  NONE(value: 'none', image: MediaRes.course);

  const NotificationCategory({required this.value, required this.image});

  final String value;
  final String image;
}
