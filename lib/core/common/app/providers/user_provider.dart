import 'package:flutter/cupertino.dart';
import 'package:tdd_education_app/src/authentication/data/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  LocalUserModel? _user;

  LocalUserModel? get user => _user;

  void initUser(LocalUserModel? user) {
    if (_user != user) _user = user;
  }

  set user(LocalUserModel? user) {
    if (_user != user) {
      _user = user;

      Future.delayed(Duration.zero, notifyListeners);
    }
  }
}
