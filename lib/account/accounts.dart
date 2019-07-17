import 'package:rxdart/subjects.dart';
import 'package:stuttherapy/account/feed.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';


class RequiredAuthentification implements Exception {
  @override
  String toString() => "This action required user authentification. Please log in.";
}

///
abstract class User {
  static const String userIdentifier = "";

  LoggedUser loggedUser;
  BehaviorSubject<LoggedUser> loggedUserStream = BehaviorSubject<LoggedUser>();

  BehaviorSubject<List<String>> savedWords = BehaviorSubject<List<String>>(seedValue: []); // List used to have sorted words
  Set<String> _savedWords = {};

  BehaviorSubject<Map<ExerciseTheme, Map<int, Exercise>>> progression = BehaviorSubject<Map<ExerciseTheme, Map<int, Exercise>>>();
  Map<ExerciseTheme, Map<int, Exercise>> _progression = {}; 

  User.create();

  bool get isLogged => loggedUser != null && loggedUser.uid != null;

  removeLoggedUsed() {
    loggedUser = null;
    loggedUserStream.add(null);
  }


  initSavedWords(Iterable<String> words) {
    List<String> wordsSorted = words.toList();
    wordsSorted.sort();
    savedWords.add(wordsSorted);
  }

  Set<String> addSavedWords(Iterable<String> words) {
    _savedWords.addAll(words);
    List<String> wordsSorted = _savedWords.toList();
    wordsSorted.sort();
    savedWords.add(wordsSorted);
    return _savedWords;
  }

  wipeSavedwords() {
    _savedWords = {};
    savedWords.add([]);
  }


  addProgressions(List<Exercise> restoredProgression) {
    restoredProgression.forEach((Exercise ex) => addProgression(ex));
    // Map<ExerciseTheme, Map<int, Exercise>> exercises = {};
    // restoredProgression.keys.forEach((ExerciseTheme t) {
    //   Map<int, Exercise> themeExercises = {};
    //   restoredProgression[t].forEach((Exercise ex) => themeExercises[ex.key] = ex);
    //   exercises[t] = themeExercises;
    // });
    // _progression.addAll(exercises);
    // progression.add(_progression);
  }

  addProgression(Exercise exercise) {
    if(_progression[exercise.theme] == null) _progression[exercise.theme] = {};
    _progression[exercise.theme][exercise.key] = exercise;
    progression.add(_progression);
  }

  wipeProgressions() {
    _progression = {};
    progression.add(_progression);
  }

  setLoggedUser(LoggedUser user) {
    loggedUser = user;
    loggedUserStream.add(loggedUser);
  }

  String get identifier;
}


///
class TherapistUser extends User {
  static const String userIdentifier = "Therapist";

  BehaviorSubject<List<LoggedUserMeta>> patients = BehaviorSubject<List<LoggedUserMeta>>();

  TherapistUser.create() : super.create();

  initPatient(List<LoggedUserMeta> _patients) {
    patients.add(_patients);
  }

  @override
  String get identifier => userIdentifier;

}


///
class StutterUser extends User {
  static const String userIdentifier = "Stutter";

  LoggedUserMeta idTherapist;

  StutterUser.create() : super.create();

  @override
  String get identifier => userIdentifier;

}

