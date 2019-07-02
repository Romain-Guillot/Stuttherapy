import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/exercises_implem/ui/audio_recorder.dart';
import 'package:stutterapy/exercises_implem/ui/metronome.dart';
import 'package:stutterapy/exercises_implem/ui/resource.dart';
import 'package:stutterapy/exercises_implem/ui/submit.dart';

class ExerciseStructureEnum {
  static const RESOURCE = 1;
  static const METRONOME = 2;
  static const SUBMIT = 3;
  static const AUDIO_RECORDER = 4;
}

class ExerciseStructureProvider {

  static Widget getWidget(int widgetId, Exercise exercise) {
    switch (widgetId) {
      case ExerciseStructureEnum.METRONOME: return MetronomeWidget(exercise: exercise);
      case ExerciseStructureEnum.RESOURCE: return ResourceWidget(exercise: exercise,);
      case ExerciseStructureEnum.SUBMIT: return SubmitWidget(exercise: exercise,);
      case ExerciseStructureEnum.AUDIO_RECORDER: return AudioRecorder(exercise: exercise);
      default: return Text("Not implemented ...");
    }
  }
}