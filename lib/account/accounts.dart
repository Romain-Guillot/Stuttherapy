import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/providers/exercise_local_storage.dart';


///
abstract class User {
  static const String userIdentifier = "";

  bool isLogged = false;
  String pseudo;

  BehaviorSubject<List<String>> savedWords = BehaviorSubject<List<String>>(seedValue: []); // List used to have sorted words
  Set<String> _savedWords = {};

  BehaviorSubject<Map<ExerciseTheme, List<Exercise>>> progression = BehaviorSubject<Map<ExerciseTheme, List<Exercise>>>();
  Map<ExerciseTheme, List<Exercise>> _progression = {}; 

  User.create();



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
    ExerciseLocalStorageProvider().insert(exercise);
    print("Progression added");
  }

  wipeProgressions() {
    _progression = {};
    progression.add(_progression);
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

