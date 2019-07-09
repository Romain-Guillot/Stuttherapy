import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/exercises.dart';

abstract class ExerciseWidget {
  final Exercise exercise;

  ExerciseWidget({@required this.exercise});
  
}