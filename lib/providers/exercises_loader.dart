import 'package:rxdart/rxdart.dart';
import 'dart:async';

import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/exercises_implem/exercise_daf.dart';
import 'package:stuttherapy/exercises_implem/exercise_metronome.dart';
import 'package:stuttherapy/exercises_implem/exercise_mirroring.dart';
import 'package:stuttherapy/exercises_implem/exercise_reading.dart';

/// Provider that handle the [ExerciseTheme] of the application
/// ExerciseThemes are available when there are ready into the
/// stream [themes]. So, this stream contain a [List] of [ExerciseTheme].
/// 
/// When the getter [themes] is called this provider return the
/// stream of the list of themes (is the themes are not initialized
/// the provided create theme and add it to the themes stream)
class ExercisesLoader {

  static BehaviorSubject<List<ExerciseTheme>> _themes;

  /// Stream of the list of [ExerciseTheme]
  static BehaviorSubject<List<ExerciseTheme>> get  themes {
    if(_themes == null) {
      _getThemes();
    }
    return _themes;
  }

  /// Themes initialization
  static Stream<List<ExerciseTheme>> _getThemes() {
    _themes = BehaviorSubject<List<ExerciseTheme>>();
    _themes.add([
      MetronomeExercise(),
      ReadingExercise(),
      MirroringExercise(),
      // DAFExercise(),
    ]);
    return _themes.stream;
  }
}