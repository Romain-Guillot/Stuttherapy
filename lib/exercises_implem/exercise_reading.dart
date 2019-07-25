import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/exercises_implem/exercise_structure_provider.dart';
import 'package:stuttherapy/strings.dart';

class ReadingExercise extends ExerciseTheme {
  ReadingExercise() : super(
    name: Strings.READING_TITLE, 
    shortDescription: Strings.READING_DESCRIPTION_SHORT, 
    longDescription: Strings.READING_DESCRIPTION_LONG,
    exerciseStructure: {
      ExerciseStructureEnum.AUDIO_RECORDER: "",
      ExerciseStructureEnum.RESOURCE: "",
      ExerciseStructureEnum.SUBMIT: "",
    }
  );
}