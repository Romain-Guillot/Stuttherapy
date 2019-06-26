import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/ui/components/secondary_appbar.dart';

class ExerciseProgressionItemWidget extends StatelessWidget {

  final Exercise exercise;

  ExerciseProgressionItemWidget({Key key, @required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        context: context,
        title: exercise.theme.name,
        subtitle: "Progression",
      )
    );
  }
}