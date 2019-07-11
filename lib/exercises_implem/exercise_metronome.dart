
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/exercise_library/settings.dart';
import 'package:stuttherapy/exercises_implem/exercise_structure_provider.dart';
import 'package:stuttherapy/exercises_implem/ui/metronome.dart';
import 'package:stuttherapy/strings.dart';

class MetronomeExercise extends ExerciseTheme{
  MetronomeExercise() : super(
    name: Strings.METRONOME_TITLE,
    shortDescription: Strings.METRONOME_DESCRIPTION_SHORT,
    longDescription: Strings.METRONOME_DESCRIPTION_LONG,
    exercisesSettings: {
      MetronomeWidget.SETTINGS_BPM: IntegerSliderField(label: "Metronome BPM", min: 50, max: 250, initialValue: 100),
      'metronome_signal': BooleanField(label: "Disable audio metronome signal")
    },
    exerciseStructure: {
      ExerciseStructureEnum.METRONOME: "",
      ExerciseStructureEnum.AUDIO_RECORDER: "",
      ExerciseStructureEnum.RESOURCE: "",
      ExerciseStructureEnum.SUBMIT: ""
    }
  );
  
}
