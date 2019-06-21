import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/settings.dart';
import 'package:stutterapy/exercises_implem/ui/metronome.dart';

class ExerciseStructureEnum {
  static const RESOURCE = 1;
  static const METRONOME = 2;
  static const SUBMIT = 3;
}

class ExerciseStructureProvider {

  static Widget getWidget(int id, ExerciseSettings settings) {
    switch (id) {
      case ExerciseStructureEnum.METRONOME: return MetronomeWidget(settings: settings,);
      default: return Text("Not implemented ...");
    }
  }
}