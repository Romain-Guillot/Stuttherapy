import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/ui/components/secondary_appbar.dart';
import 'package:stutterapy/ui/dimen.dart';

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
      ),
      body: ListView(
        padding: const EdgeInsets.all(Dimen.PADDING),
        children: <Widget>[
          (
            exercise.feedback != null 
            ? _FeedbackWidget(feedback: exercise.feedback,)
            :  Text("No feedback ...")
          ),
          Text("Theme : " + exercise.theme.name),
          Text("Date : " + exercise.date.toString()),
          Text("Saved words :"),
          Column(
            children: exercise.savedWords.map((String word) => 
              Text(word)
            ).toList(),
          )
        ],
      ),
      
      
    );
  }
}

class _FeedbackWidget extends StatelessWidget {

  final ExerciseFeedback feedback;

  _FeedbackWidget({Key key, @required this.feedback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      feedback.message
    );
  }
}