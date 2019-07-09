import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stutterapy/exercise_library/exercises.dart';

class MetronomeWidget extends StatefulWidget {

  static const SETTINGS_BPM = "metronome_bpm"; 
  
  final int bpm;
  final StreamController timerStream = BehaviorSubject<bool>();

  MetronomeWidget({
    Key key, 
    @required Exercise exercise
  }) : /*assert(settings.items[SETTINGS_BPM] != null, ""),*/ 
       this.bpm = exercise.theme.settings[SETTINGS_BPM] as int, 
       super(key: key);

  @override
  _MetronomeWidgetState createState() => _MetronomeWidgetState();
}

class _MetronomeWidgetState extends State<MetronomeWidget> {

  bool _state = true;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 60000 ~/ widget.bpm), (Timer timer) {
      _state = !_state;
      widget.timerStream.add(_state);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 80,
        height: 80,
        child: StreamBuilder<bool>(
          stream: widget.timerStream.stream,
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
}