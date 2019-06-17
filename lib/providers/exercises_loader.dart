import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'dart:collection';

import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/exercises_implem/exercise_daf.dart';
import 'package:stutterapy/exercises_implem/exercise_metronome.dart';
import 'package:stutterapy/exercises_implem/exercise_mirroring.dart';
import 'package:stutterapy/exercises_implem/exercise_reading.dart';

class ExercisesLoader {

  Stream<UnmodifiableListView<ExerciseTheme>> getThemes() {
    final _themes = BehaviorSubject<UnmodifiableListView<ExerciseTheme>>();
    _themes.add(UnmodifiableListView([
      MetronomeExercise(),
      DAFExercise(),
      MirroringExercise(),
      ReadingExercise(),
    ]));
    return _themes.stream;
  }

}