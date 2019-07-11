import 'package:flutter/material.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';

abstract class ExerciseWidget {
  final Exercise exercise;

  ExerciseWidget({@required this.exercise});
  
}