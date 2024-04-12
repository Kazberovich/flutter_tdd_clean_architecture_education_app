import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsNotifier extends ChangeNotifier {
  NotificationsNotifier(this._preferences) {
    _muteNotifications = _preferences.getBool(key) ?? false;
  }

  static const key = 'muteNotifications';

  final SharedPreferences _preferences;
  late bool _muteNotifications;

  bool get muteNotifications => _muteNotifications;

  void enableNotificationsSounds() {
    _muteNotifications = false;
    _preferences.setBool(key, false);
    notifyListeners();
  }

  void disableNotificationsSounds() {
    _muteNotifications = true;
    _preferences.setBool(key, true);
    notifyListeners();
  }

  void toggleMuteNotifications() {
    _muteNotifications = !_muteNotifications;
    _preferences.setBool(key, _muteNotifications);
    notifyListeners();
  }
}
