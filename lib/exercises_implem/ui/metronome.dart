import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/exercises_implem/ui/exercice_widget.dart';
import 'package:audioplayers/audioplayers.dart';


class MetronomeWidget extends StatefulWidget implements ExerciseWidget {

  static const SETTINGS_BPM = "metronome_bpm"; 
  static const METRONOME_SOUND_DISABLE = "metronome_sound_off";
  
  final Exercise exercise;

  MetronomeWidget({
    Key key, 
    @required this.exercise
  }) : assert(exercise.theme.settings[SETTINGS_BPM] != null, ""), 
       super(key: key);

  @override
  _MetronomeWidgetState createState() => _MetronomeWidgetState();

  int get bpm => exercise.theme.settings[SETTINGS_BPM] as int;

  bool get soundSignalEnable => !exercise.theme.settings[METRONOME_SOUND_DISABLE];
}

class _MetronomeWidgetState extends State<MetronomeWidget> {

  final StreamController timerStream = BehaviorSubject<bool>();
  AudioCache audioSignal = AudioCache();
  bool _state = true;
  Timer timer;

  @override
  void initState() {
    super.initState();
    if(widget.soundSignalEnable) {
      audioSignal.load("ding.mp3");
    }
    timer = Timer.periodic(Duration(milliseconds: 60000 ~/ widget.bpm), (Timer timer) {
      _state = !_state;
      timerStream.add(_state);
      if(widget.soundSignalEnable)
        triggerAudioSignal();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    timerStream.close();
    audioSignal.clearCache();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 80,
        height: 80,
        child: StreamBuilder<bool>(
          stream: timerStream.stream,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            Color _color;
            switch (snapshot.data) {
              case true:
                _color = Colors.pink[700];
                break;
              case false:
                _color = Colors.pink[300];
                break;
              default:
                _color = Colors.grey;
            }
            return Container(
              decoration: BoxDecoration(
                color: _color, 
                borderRadius: BorderRadius.circular(9999)
              ),
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: widget.bpm.toString(),
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  children: [TextSpan(text: "\nbpm", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300))]
                ),
                
              ),
            );
          }
        ),
      ),
    );
  }

  triggerAudioSignal() {
    audioSignal.play("ding.mp3");
  }
}