// ignore_for_file: constant_identifier_names

enum NotificationCategory {
  TEST('test'),
  VIDEO('video'),
  MATERIAL('material'),
  COURSE('course'),
  NONE('none');

  const NotificationCategory(this.value);

  final String value;
}

void main () {
  final category = NotificationCategory.TEST;
  category.value;
}
