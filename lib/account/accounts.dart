import 'package:rxdart/subjects.dart';
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

  BehaviorSubject<Map<ExerciseTheme, List<Exercise>>> progression = BehaviorSubject<Map<ExerciseTheme, List<Exercise>>>();
  Map<ExerciseTheme, List<Exercise>> _progression = {}; 

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


  initProgressions(Map<ExerciseTheme, List<Exercise>> restoredProgression) {
    _progression = restoredProgression;
    progression.add(_progression);
  }

  addProgression(Exercise exercise) {
    _progression[exercise.theme] = [
      ..._progression[exercise.theme]??[], 
      exercise
    ];
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
}


///
class TherapistUser extends User {
  static const String userIdentifier = "Therapist";

  TherapistUser.create() : super.create();

}


///
class StutterUser extends User {
  static const String userIdentifier = "Stutter";

  StutterUser.create() : super.create();


}

