
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stuttherapy/account/accounts.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/exercise_library/recording_resources.dart';
import 'package:stuttherapy/exercises_implem/ui/audio_recorder.dart';
import 'package:stuttherapy/exercises_implem/ui/mirror.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';
import 'package:stuttherapy/providers/exercise_cloud_storage.dart';
import 'package:stuttherapy/providers/feed_provider.dart';
import 'package:stuttherapy/strings.dart';
import 'package:stuttherapy/ui/account/account_log_in.dart';
import 'package:stuttherapy/ui/components/secondary_appbar.dart';
import 'package:stuttherapy/ui/dimen.dart';

const SizedBox padding = SizedBox(height: Dimen.PADDING,);

class ExerciseProgressionItemWidget extends StatelessWidget {

  final Exercise exercise;
  final String patientUID;

  ExerciseProgressionItemWidget({
    Key key, 
    @required this.exercise,
    this.patientUID,
  }) : assert(exercise != null), 
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        context: context,
        title: exercise.theme.name,
        subtitle: Strings.PROGRESS_TITLE + exercise.date.toString(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            (AccountProvider.user is StutterUser // Not really good verification ...
              ? Padding(
                  padding: const EdgeInsets.all(Dimen.PADDING),
                  child: getSyncStatus(context),
                )
              : SizedBox()
            ),
            ExerciseProgressionItemContent(exercise: exercise, patientUID: patientUID,),
          ],
        ),
      ),
      
      
    );
  }


  Widget getSyncStatus(context) {
    return StreamBuilder(
      stream: syncButtonFuture(context).stream,
      builder: (BuildContext context, AsyncSnapshot<Widget> buttonSnap) =>
        !buttonSnap.hasData
          ? syncStatusLoading()
          : buttonSnap.data
    );
  }

  BehaviorSubject<Widget> syncButtonFuture(context) {
    var textColor = Theme.of(context).primaryColor;
    BehaviorSubject<Widget> widgetStream = BehaviorSubject<Widget>(
      seedValue: AccountProvider.user.isLogged 
        ? syncStatusLoading()
        : FlatButton.icon(
            label: Text(Strings.PROGRESS_SYNC_LOGGED_REQUIRED), 
            icon: Icon(Icons.account_circle), 
            textColor: textColor,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AccountLogIn(initialFormMode: FormMode.SIGNIN,))),
          )
    );

    AccountProvider.user.loggedUserStream.listen((LoggedUser loggedUser) {
      FirebaseCloudStorageProvider().isSync(loggedUser, exercise).listen((bool isSync) {
      if(isSync) 
        widgetStream.add(
          FlatButton.icon(
            textColor: Colors.green,
            icon: Icon(Icons.check, color: Colors.green,), 
            label: Text(Strings.PROGRESS_SYNC_STATE), 
            onPressed: () {
              showUnsyncExercise(context);
            })
        );
      else
        widgetStream.add(
          FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.sync, color: Theme.of(context).primaryColor,), 
            label: Text(Strings.PROGRESS_SYNC_BUTTON), 
            onPressed: () {
              AccountProvider.syncProgression(exercise);
            })
        );
      });
    });
    return widgetStream;
  }

  Widget syncStatusLoading() {
    return Wrap(
      spacing: 10,
      children: <Widget>[
        SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(strokeWidth: 2,)
        ),
        Text(Strings.LOADING, style: TextStyle(fontStyle: FontStyle.italic),)
      ],
    );
  }

  showUnsyncExercise(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Strings.PROGRESS_DESYNC_TITLE),
        content: Text(Strings.PROGRESS_DESYNC_INFO),
        actions: <Widget>[
          FlatButton(
            child: Text(Strings.PROGRESS_DESYNC_NO), 
            textColor: Colors.grey, 
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            child: Text(Strings.PROGRESS_DESYNC_YES), 
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

class ExerciseProgressionItemContent extends StatelessWidget {
  final Exercise exercise;
  final String patientUID;

  ExerciseProgressionItemContent({@required this.exercise, @required this.patientUID});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _FeedbackWidget(exercise: exercise, patientUID: patientUID,),
        padding,
        Padding(
          padding: const EdgeInsets.all(Dimen.PADDING),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Theme : " + exercise.theme.name),
              padding,
              Text("Date : " + exercise.date.toString()),
              padding,
              Text("Recording resource"),
              getRecorginWidget(),
              padding,
              Text("Saved words :"),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: exercise.savedWords.map((String word) => 
                  Text(word)
                ).toList(),
              )
            ],
          )
        )
      ],
    );
  }


  Widget getRecorginWidget() {
    if(exercise?.recordingResource != null) {
      switch (exercise.recordingResource.type) {
        case RecordingType.AUDIO:
          return AudioPlayer(uri: exercise.recordingResource.uri,);
        case RecordingType.VIDEO:
          return VideoResourcePlayer(uri: exercise.recordingResource.uri,);
        default:
          return Text("Recording type not supported.");
      }
    } else {
      return Text("No recording data.");
    }
  }
}


// Feedback can be null
class _FeedbackWidget extends StatefulWidget {

  final Exercise exercise;
  final String patientUID;

  _FeedbackWidget({Key key, @required this.exercise, @required this.patientUID}) : super(key: key);

  @override
  __FeedbackWidgetState createState() => __FeedbackWidgetState();
}

class __FeedbackWidgetState extends State<_FeedbackWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimen.PADDING),
      color: Theme.of(context).primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            (widget.exercise.feedback?.message == null 
              ? "No feedback."
              : widget.exercise.feedback?.message),
            style: TextStyle(
              fontStyle: widget.exercise.feedback?.message == null? FontStyle.italic : FontStyle.normal, 
              color: Colors.white
            ),
          ),
          (AccountProvider.user is TherapistUser
            ? OutlineButton(
              textColor: Colors.white,
              borderSide: BorderSide(color: Colors.white.withAlpha(100)),
              highlightedBorderColor: Colors.white,
              child: Text("Edit feedback"),
              onPressed: () => onAddFeedback(context),
            )
            : SizedBox() // empty widget
          ),
          SizedBox(width: double.infinity,) // width expand
            
        ],
      ),
    );
  }

  onAddFeedback(context) {
    showDialog(
      context: context,
      builder: (context) => _FeedbackEditor(
        exercise: widget.exercise, 
        patientUID: widget.patientUID,
      )
    ).then((_) {
      setState(() {});
    });
  }
}

class _FeedbackEditor extends StatefulWidget {
  final Exercise exercise;
  final String patientUID;

  _FeedbackEditor({Key key, this.exercise, @required this.patientUID}) : super(key: key);

  @override
  _FeedbackEditorState createState() => _FeedbackEditorState();
}

class _FeedbackEditorState extends State<_FeedbackEditor> {

  final _formKey = GlobalKey<FormState>();
  final feedbackController = TextEditingController();


  @override
  void initState() {
    super.initState();
    feedbackController.text = widget.exercise.feedback?.message;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit feedback"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: feedbackController,
          decoration: InputDecoration(labelText: "Feedback"),
          validator: (value) => value.isEmpty ? "Write your feedback" : null,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Save feedback"),
          onPressed: () async {
            if(_formKey.currentState.validate())
            await _addFeedback(feedbackController.text);
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  _addFeedback(String message) async {
    
    FeedProvider.addFeedback(
      patientUID: widget.patientUID,
      user: AccountProvider.user.loggedUser,
      exercise: widget.exercise,
      feedback: ExerciseFeedback(message: message)
    );
  }
}