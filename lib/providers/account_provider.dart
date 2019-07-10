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
    _restoreSavedWords();
    _restoreProgression();
  }

  static _restoreSavedWords() async {
    Set<String> savedWords = await SavedWordsLocalStorageProvider().all();
    user.initSavedWords(savedWords);
  }

  static _restoreProgression() async {
    StreamSubscription subscr;
    subscr = ExercisesLoader.themes.listen((List<ExerciseTheme> themes) async {
      Map<String, ExerciseTheme> themesMap = {};
      themes.forEach((ExerciseTheme t) => themesMap[t.name] = t);
      Map<ExerciseTheme, List<Exercise>> progressions = await ExerciseLocalStorageProvider().all(themes:themesMap);
      user.initProgressions(progressions);
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
    await ExerciseLocalStorageProvider().wipe();
    user.wipeProgressions();
  }

  static wipeSavedwords() async {
    await SavedWordsLocalStorageProvider().wipe();
    user.wipeSavedwords();
  }

  static deleteSavedWord(String word) async {
    await SavedWordsLocalStorageProvider().delete(word);
    _restoreSavedWords();
  }

    
}