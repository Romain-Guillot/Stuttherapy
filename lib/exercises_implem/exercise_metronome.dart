
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/exercise_library/settings.dart';
import 'package:stutterapy/strings.dart';

class MetronomeExercise extends ExerciseTheme{
  MetronomeExercise() : super(
    name: Strings.METRONOME_TITLE,
    shortDescription: Strings.METRONOME_DESCRIPTION_SHORT,
    longDescription: Strings.METRONOME_DESCRIPTION_LONG,
    exercisesSettings: {
      'metronome_pulse': IntegerSliderField(label: "Metronome BPM", min: 50, max: 250, initialValue: 100),
      'metronome_signal': BooleanField(label: "Disable audio metronome signal")
    },
  ) {
    settings.items['cover_sentences'].disable = true;
  }
  
}