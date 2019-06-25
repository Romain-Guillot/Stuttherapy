import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stutterapy/exercise_library/exercises.dart';

class SubmitWidget extends StatelessWidget {

  final Exercise exercise;
  final bool manuallyCheck;

  final double _iconSize = 40.0;

  SubmitWidget({
    Key key, 
    @required this.exercise
  }) :  manuallyCheck = exercise.theme.settings[ExerciseTheme.SETTINGS_MANUALLY_CHECK],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (!manuallyCheck)
      ? IconButton(
          icon: Icon(Icons.navigate_next, color: Colors.blue,),
          iconSize: _iconSize,
          onPressed: () {
            exercise.moveNextResource();
          },
        )
      : Wrap(
        spacing: 15,
        children: [
          IconButton(
            icon: Icon(Icons.thumb_up, color: Colors.green), 
            iconSize: _iconSize,
            onPressed: () {
              exercise.moveNextResource();
            },),
          IconButton(
            icon: Icon(Icons.thumb_down, color: Colors.red),
            iconSize: _iconSize,
            onPressed: () {
              exercise.moveNextResource();
            }, 
          )
        ]
      ),
    );
  }


}