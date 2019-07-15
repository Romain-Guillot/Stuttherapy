import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/exercise_library/recording_resources.dart';
import 'package:stuttherapy/exercises_implem/ui/audio_recorder.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/providers/exercise_cloud_storage.dart';
import 'package:stuttherapy/ui/account/account_log_in.dart';
import 'package:stuttherapy/ui/components/secondary_appbar.dart';
import 'package:stuttherapy/ui/dimen.dart';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimen.PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getSyncStatus(context),
            padding,
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

  Widget getSyncStatus(context) {
    return StreamBuilder(
      stream: syncButtonFuture(context).stream,
      builder: (BuildContext context, AsyncSnapshot<Widget> buttonSnap) {
        if(!buttonSnap.hasData) {
          return Row(
            children: <Widget>[
              CircularProgressIndicator(),
              Text("Loading...")
            ],
          );
        } else {
          return buttonSnap.data;
        }
      },
    );
  }

  BehaviorSubject<Widget> syncButtonFuture(context) {
    var textColor = Theme.of(context).primaryColor;
    BehaviorSubject<Widget> widgetStream = BehaviorSubject<Widget>();
    if(AccountProvider.user.isLogged) {
      FirebaseCloudStorageProvider().isSync(exercise, AccountProvider.user.loggedUser).listen((bool isSync) {
        if(isSync) 
          widgetStream.add(
            FlatButton.icon(
              textColor: Colors.green,
              icon: Icon(Icons.check, color: Colors.green,), 
              label: Text("Synchronized"), 
              onPressed: () {
                showUnsyncExercise(context);
              })
          );
        else
          widgetStream.add(
            FlatButton.icon(
              textColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.sync, color: Theme.of(context).primaryColor,), 
              label: Text("Synchronize"), 
              onPressed: () {
                AccountProvider.syncProgression(exercise);
              })
          );
      }); 
    } else {
      widgetStream.add(
        FlatButton.icon(
          label: Text("Synchronization required to be logged"), 
          icon: Icon(Icons.account_circle), 
          textColor: textColor,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AccountLogIn(initialFormMode: FormMode.SIGNIN,))),
        )
      );
    }
    return widgetStream;
  }

  showUnsyncExercise(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sesynchronize exercise ?"),
        content: Text("Do you want to remove the exercise from the cloud ?"),
        actions: <Widget>[
          FlatButton(
            child: Text("No"), 
            textColor: Colors.grey, 
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            child: Text("Yes, desynchronis"), 
            textColor: Theme.of(context).errorColor, 
            onPressed: () {
              AccountProvider.unsyncProgression(exercise);
              Navigator.pop(context);
            }
          )
        ],
      )
    );
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