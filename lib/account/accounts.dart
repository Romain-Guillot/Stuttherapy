import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:stutterapy/account/feed.dart';
import 'package:stutterapy/exercise_library/exercises.dart';


abstract class User {
  static String userIdentifier;

  bool isLogged = false;
  String pseudo;
}


class TherapistUser extends User {
  static String userIdentifier = "Therapist";

  // List<StutterUser> patients = [];


}

class StutterUser extends User {
  static String userIdentifier = "Stutter";

  List<String> savedWord = [];
  HashMap<ExerciseTheme, List<ExerciseProgression>> progression; 
  // TherapistUser therapist;
  // Feed feed;

}

