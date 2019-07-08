import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/exercise_library/recording_resources.dart';


class AudioRecorder extends StatefulWidget {

  final Exercise exercise;
  final bool recordingEnable; 
  
  AudioRecorder({
    Key key, 
    @required this.exercise
    }) :  recordingEnable = exercise.theme.settings[ExerciseTheme.SETTINGS_RECORD],
          super(key: key);

  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}


class _AudioRecorderState extends State<AudioRecorder> {

  bool isRecording = false;
  bool error = false;
  StreamSubscription _recorderSubscription;
  final FlutterSound recorder = FlutterSound();

  @override
  void initState() {
    super.initState();
    start();
  }

  start() async {
    try {
      final String uri = await recorder.startRecorder((await getApplicationDocumentsDirectory()).path + "/" + DateTime.now().millisecondsSinceEpoch.toString() + ".m4a");
      print("URI : " + uri);
      widget.exercise.recordingResource = RecordingResource(uri: uri, type: RecordingType.AUDIO);
      _recorderSubscription = widget.exercise.flagEndOfExercise.stream.listen((bool end) {
        if(end) 
          stop();
      });
      setState(() => isRecording = true);
    }catch(_) {
      setState(() => error = true);
    }
  }

  
  stop() async {
    print("try stop recorder ...");
    if(isRecording) {
      try {
        await recorder.stopRecorder();
        if (_recorderSubscription != null) {
          _recorderSubscription.cancel();
          _recorderSubscription = null;
        }
        print("Recorder stopped !");
      }catch(err) {
        print("Unable to stop the recorder ... (not normal !)");
        print("err" + err.toString());
      }
      setState(() => isRecording = false);
    } else {
      print("Not in recording status.");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,  
      children: <Widget>[
        getIconStatus(),
        getTextStatus(),
        // RaisedButton(child:Text("STOP"), onPressed: () {stop();},)
      ],
    );
  }
  
  Text getTextStatus() {
    if(error) {
      return Text("Error occured.");
    }else {
      return Text(!widget.recordingEnable 
                ? "Your voice is not recorded" 
                : (isRecording ? "Your voice is recorded" : "Waiting for the recorder ..."));
    }
  } 

  Icon getIconStatus() {
    if(error) {
      return Icon(Icons.error);
    }else {
      return Icon(
        Icons.record_voice_over,
        color: !widget.recordingEnable 
                ? Colors.grey
                : (isRecording ? Colors.green : Colors.grey));
    }
  } 
}



class AudioPlayer extends StatefulWidget {

  final String uri;

  AudioPlayer({Key key, @required this.uri}) : super(key: key) {
    print(uri);
  }
  
  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}


class _AudioPlayerState extends State<AudioPlayer> {
  FlutterSound player = FlutterSound();

  StreamSubscription _playerSubscription;

  bool error = false;
  bool isStarted = false;
  bool isPausing = false;
  
  double maxDuration = 1.0;
  double sliderCurrentPosition = 0.0;


  play() async {
    // surrunding with try catch
    try {
      print(FileSystemEntity.typeSync(widget.uri));
      await player.startPlayer(widget.uri);
      print("START 2");
      _playerSubscription = player.onPlayerStateChanged.listen((PlayStatus status) {
        try {
          if(status != null) {
            sliderCurrentPosition = status.currentPosition;
            maxDuration = status.duration;
            if(sliderCurrentPosition >= maxDuration) {
              player = FlutterSound();
              setState(() {
                isStarted = false;
                isPausing = false;
                sliderCurrentPosition = 0;
              });
            }else {
              setState(() {
                isStarted = true;
              });
            } 
          }
        } catch(err) { // problem with the stream of with the widget (does not exist)
          _playerSubscription.cancel();
          _playerSubscription = null;
        }
      });
    }catch(err) {
      print("Error lo load the audio");
      print(err);
      setState(() {
        error = true;
      });
    }
  }

  pause() async {
    await player.pausePlayer();
    setState(() => isPausing = true);
  }

  resume() async {
    await player.resumePlayer();
    setState(() => isPausing = false);
  }

  stop() async {
    try {
      String result = await player.stopPlayer();
      print('stopPlayer: $result');
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }
    } catch (err) {
      print('error: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return error 
      ? Text("Error to load resource.")
      : Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                !isStarted || isPausing ? Icons.play_arrow : Icons.pause
              ),
              onPressed: !isStarted ? play : (isPausing ? resume : pause),
            ),
            Expanded(
              child: Slider(
                value: sliderCurrentPosition,
                min: 0.0,
                max: maxDuration,
                onChanged: !isStarted ? null : (double newPosition) {
                  player.seekToPlayer(newPosition.toInt());
                },
                divisions: maxDuration.toInt(),
              ),
            )
          ],
        );
  }
}