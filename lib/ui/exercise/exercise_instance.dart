import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/exercises_implem/exercise_structure_provider.dart';
import 'package:stutterapy/exercises_implem/ui/resource.dart';
import 'package:stutterapy/exercises_implem/ui/submit.dart';
import 'package:stutterapy/ui/components/secondary_appbar.dart';

class ExerciseInstanceWidget extends StatelessWidget {
  
  final Exercise exercise;

  final paddingBottom = SizedBox(height: 20,);

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
      body: 
        (exercise.theme.exerciseStructure.keys.length > 0)
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children : [
            ...exercise.theme.exerciseStructure.keys.map((int id) =>
              Column(
                children: <Widget>[
                  ExerciseStructureProvider.getWidget(id, exercise.theme.settings),
                  paddingBottom
                ],
              )
            ).toList(),
            ResourceWidget(exercise: exercise,),
            paddingBottom,
            SubmitWidget()
          ]
        )
        : Text("Nothing to display ..."),
    );
  }
}