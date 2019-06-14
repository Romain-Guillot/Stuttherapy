import 'dart:collection';

import 'package:stutterapy/exercise_library/exercises.dart';


abstract class User {
  static const String userIdentifier = "";

  List<String> savedWord = [];
  HashMap<ExerciseTheme, List<ExerciseProgression>> progression; 

  bool isLogged = false;
  String pseudo;
}



class TherapistUser extends User {
  static const String userIdentifier = "Therapist";

  // List<StutterUser> patients = [];
}

class StutterUser extends User {
  static const String userIdentifier = "Stutter";


  // TherapistUser therapist;
  // Feed feed;
}

class UninitializeUser extends User {}

