import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/exercises_implem/exercise_structure_provider.dart';
import 'package:stuttherapy/strings.dart';

class MirroringExercise extends ExerciseTheme{
  MirroringExercise() : super(
    name: Strings.MIRRORING_TITLE, 
    shortDescription: Strings.MIRORRING_DESCRIPTION_SHORT, 
    longDescription: Strings.MIRORRNG_DESCRIPTION_LONG,
    exerciseStructure: {
      ExerciseStructureEnum.MIRROR: "",
      ExerciseStructureEnum.RESOURCE: "",
      ExerciseStructureEnum.SUBMIT: "",
    }
  );
}