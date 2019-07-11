import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stuttherapy/account/accounts.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/providers/exercise_local_storage.dart';
import 'package:stuttherapy/providers/exercises_loader.dart';
import 'package:stuttherapy/providers/shared_pref_provider.dart';


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

  static restore() {
    _restoreSavedWords();
    _restoreProgression();
  }

  static _restoreSavedWords() async {
    Set<String> savedWords = await SavedWordsLocalStorageProvider().all();
    user.initSavedWords(savedWords);
  }

  static wipeSavedwords() async {
    await SavedWordsLocalStorageProvider().wipe();
    user.wipeSavedwords();
  }

  static deleteSavedWord(String word) async {
    await SavedWordsLocalStorageProvider().delete(word);
    _restoreSavedWords();
  }

  static addSavedWords(Iterable<String> words) async {
    words = words.map((String w) => w.toLowerCase());
    user.addSavedWords(words);
    SavedWordsLocalStorageProvider().insertAll(words.toSet());
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

  static Future wipeProgressions() async {
    ExerciseLocalStorageProvider().wipe();
    user.wipeProgressions();
  }

  static addProgression(Exercise exercise) async {
    user.addProgression(exercise);
    ExerciseLocalStorageProvider().insert(exercise);
  }





    
}