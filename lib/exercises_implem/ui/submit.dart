import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stutterapy/exercise_library/exercises.dart';

class SubmitWidget extends StatelessWidget {

  final Exercise exercise;

  final double _iconSize = 40.0;

  SubmitWidget({Key key, @required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
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