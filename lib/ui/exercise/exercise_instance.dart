import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/exercises_implem/exercise_structure_enum.dart';
import 'package:stutterapy/exercises_implem/ui/metronome.dart';
import 'package:stutterapy/ui/components/secondary_appbar.dart';

class ExerciseInstanceWidget extends StatelessWidget {
  
  final Exercise exercise;

  ExerciseInstanceWidget({Key key, @required this.exercise}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        title: exercise.theme.name, 
        subtitle: "Exercise", 
        context: context,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.check, color: Colors.green), 
            label: Text("Finish".toUpperCase(), 
            style: TextStyle(color: Colors.green),), 
            onPressed: () {},
          )
        ],
      ),
      body: exercise.theme.exerciseStructure.keys.length > 0 
      ? Column(
        children : exercise.theme.exerciseStructure.keys.map((int id) =>
          ExerciseStructureProvider.getWidget(id, exercise.theme.settings)
        ).toList(),
      )
      : Text("Nothing to display ...")
    );
  }
}