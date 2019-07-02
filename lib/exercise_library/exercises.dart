import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/settings.dart';

abstract class ExerciseTheme {
  final String name;
  final String shortDescription;
  final String longDescription;
  Settings settings;

  ExerciseTheme({@required this.name, @required this.shortDescription, @required this.longDescription});
}

class Exercise {

}

class ExerciseProgression {

}

class ExerciseFeedback {

}