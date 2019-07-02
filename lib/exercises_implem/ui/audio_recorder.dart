import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/exercises.dart';

class AudioRecorder extends StatelessWidget {

  final Exercise exercise;
  
  AudioRecorder({Key key, @required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,  
      children: <Widget>[
        Icon(Icons.record_voice_over, color: Colors.red),
        Text("Your voice is recorded.")
      ],
    );
  }
}