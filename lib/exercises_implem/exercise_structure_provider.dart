import 'package:flutter/material.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/exercises_implem/ui/audio_recorder.dart';
import 'package:stuttherapy/exercises_implem/ui/daf.dart';
import 'package:stuttherapy/exercises_implem/ui/metronome.dart';
import 'package:stuttherapy/exercises_implem/ui/mirror.dart';
import 'package:stuttherapy/exercises_implem/ui/resource.dart';
import 'package:stuttherapy/exercises_implem/ui/submit.dart';

class ExerciseStructureEnum {
  static const RESOURCE = 1;
  static const METRONOME = 2;
  static const SUBMIT = 3;
  static const AUDIO_RECORDER = 4;
  static const DAF = 5;
  static const MIRROR = 6;
}

class ExerciseStructureProvider {

  static Widget getWidget(int widgetId, Exercise exercise) {
    switch (widgetId) {
      case ExerciseStructureEnum.METRONOME: return MetronomeWidget(exercise: exercise);
      case ExerciseStructureEnum.RESOURCE: return ResourceWidget(exercise: exercise,);
      case ExerciseStructureEnum.SUBMIT: return SubmitWidget(exercise: exercise,);
      case ExerciseStructureEnum.AUDIO_RECORDER: return AudioRecorder(exercise: exercise);
      case ExerciseStructureEnum.DAF: return DAFWidget(exercise: exercise);
      case ExerciseStructureEnum.MIRROR: return MirrorWidget(exercise: exercise,);
      default: return Text("Not implemented ...");
    }
  }
}