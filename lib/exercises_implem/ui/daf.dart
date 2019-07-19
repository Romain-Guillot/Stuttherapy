import 'package:flutter/material.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/exercises_implem/ui/exercice_widget.dart';

class DAFWidget extends StatelessWidget implements ExerciseWidget {
  
  final Exercise exercise;

  DAFWidget({Key key, @required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      fallbackHeight: 400,
    );
  }
}