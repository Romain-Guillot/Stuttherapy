import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';
import 'package:stutterapy/exercise_library/exercises.dart';


abstract class User {
  static const String userIdentifier = "";

  BehaviorSubject<List<String>> savedWords = BehaviorSubject<List<String>>(seedValue: []); // List used to have sorted words
  Set<String> _savedWords = {};

  Map<ExerciseTheme, List<Exercise>> progression = {}; 

  User.create();

  User.restore({@required Set<String> userSavedWord, @required this.progression}) {
    addSavedWords(userSavedWord);
  }

  bool isLogged = false;
  String pseudo;

  addSavedWords(Iterable<String> words) {
    for(String w in words)
      _savedWords.add(w.toLowerCase());
    List<String> wordsSorted = _savedWords.toList();
    wordsSorted.sort();
    savedWords.add(wordsSorted);
  }

  addProgression(Exercise exercise) {
    progression[exercise.theme] = [
      ...progression[exercise.theme]??[], 
      exercise
    ];
  }
}



class TherapistUser extends User {
  static const String userIdentifier = "Therapist";

  TherapistUser.create() : super.create();

  TherapistUser.restore({
    @required Set<String> userSavedWord, 
    @required progression}
  ) : super.restore(userSavedWord: userSavedWord, progression: progression);
}

class StutterUser extends User {
  static const String userIdentifier = "Stutter";

  StutterUser.create() : super.create();

  StutterUser.restore({
    @required Set<String> userSavedWord, 
    @required progression}
  ) : super.restore(userSavedWord: userSavedWord, progression: progression);

}

