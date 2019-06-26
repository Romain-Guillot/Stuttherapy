import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';
import 'package:stutterapy/exercise_library/exercises.dart';


abstract class User {
  static const String userIdentifier = "";

  BehaviorSubject<Set<String>> savedWords = BehaviorSubject<Set<String>>(seedValue: {});
  Set<String> _savedWords = {};

  HashMap<ExerciseTheme, List<ExerciseProgression>> progression; 

  User.create();

  User.restore({@required Set<String> userSavedWord, @required this.progression}) : _savedWords = userSavedWord {
    savedWords.add(_savedWords);
  }

  bool isLogged = false;
  String pseudo;

  addSavedWords(Iterable<String> words) {
    _savedWords.addAll(words);
    savedWords.add(_savedWords);
  }
}



class TherapistUser extends User {
  static const String userIdentifier = "Therapist";

  TherapistUser.create() : super.create();

  TherapistUser.restore({
    @required Set<String> userSavedWord, 
    @required progression}
  ) : super.restore(userSavedWord: userSavedWord, progression: progression);

  // List<StutterUser> patients = [];
}

class StutterUser extends User {
  static const String userIdentifier = "Stutter";

  StutterUser.create() : super.create();

  StutterUser.restore({
    @required Set<String> userSavedWord, 
    @required progression}
  ) : super.restore(userSavedWord: userSavedWord, progression: progression);


  // TherapistUser therapist;
  // Feed feed;
}

