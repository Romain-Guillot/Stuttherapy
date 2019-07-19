import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/exercises_implem/exercise_structure_provider.dart';
import 'package:stuttherapy/strings.dart';

class DAFExercise extends ExerciseTheme {
  DAFExercise() : super(
    name: Strings.DAF_TITLE, 
    shortDescription: Strings.DAF_DESCRIPTION_SHORT, 
    longDescription: Strings.DAF_DESCRIPTION_LONG,
    exerciseStructure: {
      ExerciseStructureEnum.DAF: "",
      ExerciseStructureEnum.RESOURCE: "",
      ExerciseStructureEnum.SUBMIT: ""
    }
  );
}