import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stuttherapy/account/accounts.dart';
import 'package:stuttherapy/account/feed.dart';
import 'package:stuttherapy/exercise_library/date.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';
import 'package:stuttherapy/providers/exercise_cloud_storage.dart';
import 'package:stuttherapy/providers/exercise_local_storage.dart';
import 'package:stuttherapy/providers/exercises_loader.dart';
import 'package:stuttherapy/providers/feed_provider.dart';
import 'package:stuttherapy/providers/shared_pref_provider.dart';
import 'package:stuttherapy/providers/therapist_provider.dart';


class AccountProvider {
  static User user;

  static const existingAccount = "existingAccount";

  
  static setUser(User _user) {
    user = _user;
  }

  static setLoggedUser(LoggedUser loggedUser) {
    user.setLoggedUser(loggedUser);
  }

  static logOutUser() {
    AuthentificationProvider.logout();
    user.removeLoggedUsed();
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
        break;
      case TherapistUser.userIdentifier:
        user = TherapistUser.create();
        restore();
        break;
      default:
        return false;
    }
    AuthentificationProvider.currentUser().then((LoggedUser loggedUser) {
      if(loggedUser != null) {
        user.setLoggedUser(loggedUser);
        if(user is StutterUser)
          FeedProvider.initFeed(loggedUser, user.loggedUser.uid);
        if(user is TherapistUser)
          initPatients();
      }

    });
    return true;
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
      List<Exercise> progressions = await ExerciseLocalStorageProvider().all(themes:themesMap);
      user.addProgressions(progressions);
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

  static syncProgression(Exercise exercise) {
    if(user.isLogged) 
      FirebaseCloudStorageProvider().uploadExercise(exercise, user.loggedUser);
    else throw RequiredLoggedUserException();
  }

  static Future unsyncProgression(Exercise exercise) async {
    if(user.isLogged) FirebaseCloudStorageProvider().deleteExercise(exercise, user.loggedUser);
    else throw RequiredLoggedUserException();
  }

  static Future backupProgression() async {
    if(user.isLogged) {
      StreamSubscription themeSubscr;
      themeSubscr = ExercisesLoader.themes.listen((List<ExerciseTheme> themes) {
        StreamSubscription exerciseSubscr;
        Map<String, ExerciseTheme> themesMap = {};
        themes.forEach((ExerciseTheme t) => themesMap[t.name] = t);
        exerciseSubscr = FirebaseCloudStorageProvider().all(user.loggedUser, themesMap).listen((List<Exercise> exercises) {
          user.addProgressions(exercises);
          exercises.forEach((Exercise ex) => addProgression(ex));
          exerciseSubscr.cancel();
          themeSubscr.cancel();
        });
      });
    } else throw RequiredLoggedUserException();
  }

  static initPatients() {
    if(user is TherapistUser && user.isLogged) {
      FirebaseCloudTherapistProvider().allPatients(user.loggedUser).listen((List<LoggedUserMeta> patients) {
        (user as TherapistUser).initPatient(patients);
      });
    }
  }
}

class RequiredLoggedUserException implements Exception {
  @override
  String toString() => "This action required to be logged";
}