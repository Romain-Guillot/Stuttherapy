import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'dart:collection';

import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/exercises_implem/exercise_daf.dart';
import 'package:stutterapy/exercises_implem/exercise_metronome.dart';
import 'package:stutterapy/exercises_implem/exercise_mirroring.dart';
import 'package:stutterapy/exercises_implem/exercise_reading.dart';

class ExercisesLoader {

  static BehaviorSubject<List<ExerciseTheme>> _themes;

  static BehaviorSubject<List<ExerciseTheme>> get  themes {
    if(_themes == null) {
      _getThemes();
    }
    return _themes;
  }


  static Stream<List<ExerciseTheme>> _getThemes() {
    _themes = BehaviorSubject<List<ExerciseTheme>>();
    _themes.add([
      MetronomeExercise(),
      DAFExercise(),
      MirroringExercise(),
      ReadingExercise(),
    ]);
    return _themes.stream;
  }

}