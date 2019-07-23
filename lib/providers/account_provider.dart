import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stuttherapy/account/accounts.dart';
import 'package:stuttherapy/account/feed.dart';
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
    initLoggedUser();
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
    initLoggedUser();
  }

  static initLoggedUser() {
    AuthentificationProvider.currentUser().then((LoggedUser loggedUser) {
      if(loggedUser != null) {
        user.setLoggedUser(loggedUser);
      }

    });
    user.loggedUserStream.listen((LoggedUser loggedUser) {
      if(user is StutterUser)
        initTherapist();
      if(user is TherapistUser)
        initPatients();
    });
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
      FirebaseCloudStorageProvider().uploadExercise(user.loggedUser, exercise);
    else throw RequiredLoggedUserException();
  }

  static Future unsyncProgression(Exercise exercise) async {
    if(user.isLogged) FirebaseCloudStorageProvider().deleteExercise(user.loggedUser, exercise);
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

  static initTherapist() {
    if(user is StutterUser && user.isLogged) {
      FirebaseCloudTherapistProvider().getTherapist(user.loggedUser).listen((LoggedUserMeta therapist) {
        (user as StutterUser).addTherapist(therapist);
      });
    }
  }

  static Future<void> addTherapist(String uid) async {
    return FirebaseCloudTherapistProvider().addTherapist(user.loggedUser, uid);
  }

  static Future<void> revoqueTherapist() async {
    return FirebaseCloudTherapistProvider().deleteTherapist(user.loggedUser, user.loggedUser.uid);
  }

  static Future<void> removePatient(patientUID) {
    return FirebaseCloudTherapistProvider().deleteTherapist(user.loggedUser, patientUID);
  }


  static BehaviorSubject<Feed> getUserFeed({userUID}) {
    BehaviorSubject<Feed> feed = BehaviorSubject<Feed>();
    if(userUID == null) {
      user.loggedUserStream.listen((LoggedUser user) {
        FeedProvider.getUserFeed(user, user.uid).listen((Feed _feed) {
          feed.add(_feed);
        });
      });
      return feed;
    } else {
      return FeedProvider.getUserFeed(user.loggedUser, userUID);
    }
    
  }
}

class RequiredLoggedUserException implements Exception {
  @override
  String toString() => "This action required to be logged";
}