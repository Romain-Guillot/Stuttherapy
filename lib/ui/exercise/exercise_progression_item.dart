import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/exercise_library/recording_resources.dart';
import 'package:stutterapy/exercises_implem/ui/audio_recorder.dart';
import 'package:stutterapy/ui/components/secondary_appbar.dart';
import 'package:stutterapy/ui/dimen.dart';

class ExerciseProgressionItemWidget extends StatelessWidget {

  final Exercise exercise;
  static const SizedBox padding = SizedBox(height: Dimen.PADDING,);

  ExerciseProgressionItemWidget({
    Key key, 
    @required this.exercise
  }) : assert(exercise != null), 
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        context: context,
        title: exercise.theme.name,
        subtitle: "Progression : " + exercise.date.toString(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Dimen.PADDING),
        children: <Widget>[
          _FeedbackWidget(feedback: exercise.feedback),
          padding,
          Text("Theme : " + exercise.theme.name),
          padding,
          Text("Date : " + exercise.date.toString()),
          padding,
          Text("Recording resource"),
          getRecorginWidget(),
          padding,
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

  Widget getRecorginWidget() {
    if(exercise?.recordingResource != null) {
      switch (exercise.recordingResource.type) {
        case RecordingType.AUDIO:
          return AudioPlayer(uri: exercise.recordingResource.uri,);
        case RecordingType.VIDEO:
          return Placeholder(fallbackHeight: 200,);
        default:
          return Text("Recording type not supported.");
      }
    } else {
      return Text("No recording data.");
    }
  }
}


// Feedback can be null
class _FeedbackWidget extends StatelessWidget {

  final ExerciseFeedback feedback;

  _FeedbackWidget({Key key, @required this.feedback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return feedback?.message == null 
    ? Text("No feedback.", style: TextStyle(fontStyle: FontStyle.italic),)
    : Container(
        padding: const EdgeInsets.all(Dimen.PADDING),
        color: Theme.of(context).accentColor,
        child: Text(feedback?.message)
      );
  }
}