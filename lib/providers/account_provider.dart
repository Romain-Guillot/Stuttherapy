import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stutterapy/account/accounts.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/providers/exercise_local_storage.dart';
import 'package:stutterapy/providers/exercises_loader.dart';
import 'package:stutterapy/providers/shared_pref_provider.dart';


class AccountProvider {
  static User user;

  static const existingAccount = "existingAccount";

  
  static setUser(User _user) {
    user = _user;
  }

  /// Retreive user date (progressions, etc.)
  ///  
  static Future<bool> getSavedUser() async {
    SharedPreferences _prefs = await SharedPrefProvider.prefs;
    String accountType = _prefs.getString(existingAccount);
    if(accountType == null)
      return false;

    switch (accountType) {
      case StutterUser.userIdentifier:
        user = StutterUser.create();
        restore();
        return true;
      case TherapistUser.userIdentifier:
        user = TherapistUser.create();
        restore();
        return true;
      default:
        return false;
    }
  }

  static restore() {
    StreamSubscription subscr;
    subscr = ExercisesLoader.themes.listen((List<ExerciseTheme> themes) async {
      Map<String, ExerciseTheme> themesMap = {};
      themes.forEach((ExerciseTheme t) => themesMap[t.name] = t);
      Map<ExerciseTheme, List<Exercise>> progressions = await ExerciseLocalStorageProvider.all(themesMap);
      user.restore(userProgression: progressions, userSavedWord: {});
      subscr.cancel();
    });
  }

  static setSavedUser(User _user) async {
    SharedPreferences _prefs = await SharedPrefProvider.prefs;
    switch (_user.runtimeType) {
      case StutterUser:
        _prefs.setString(existingAccount, StutterUser.userIdentifier);
        break;
      case TherapistUser:
        _prefs.setString(existingAccount, TherapistUser.userIdentifier);
        break;
    }
  }

  static Future wipeProgressions() async {
    await ExerciseLocalStorageProvider.wipe();
    user.wipeProgressions();
  }

    
}