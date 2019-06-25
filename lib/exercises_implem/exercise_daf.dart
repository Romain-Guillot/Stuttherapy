import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/exercises_implem/exercise_structure_provider.dart';
import 'package:stutterapy/strings.dart';

class DAFExercise extends ExerciseTheme {
  DAFExercise() : super(
    name: Strings.DAF_TITLE, 
    shortDescription: Strings.DAF_DESCRIPTION_SHORT, 
    longDescription: Strings.DAF_DESCRIPTION_LONG,
    exerciseStructure: {
      ExerciseStructureEnum.AUDIO_RECORDER: "",
      ExerciseStructureEnum.RESOURCE: "",
      ExerciseStructureEnum.SUBMIT: ""
    }
  );
}