import 'package:stutterapy/exercise_library/exercise_ressources.dart';

class ResourceProvider {
  static CollectionExerciseResource getResources(ExerciseResourceEnum resType) {
    switch (resType) {
      case ExerciseResourceEnum.WORDS:
        return CollectionExerciseResource(resources: [
          ExerciseResource(resource: "Giraphe", resourceType: ExerciseResourceEnum.WORDS), 
          ExerciseResource(resource: "Monkey", resourceType: ExerciseResourceEnum.WORDS),
          ExerciseResource(resource: "Zebra", resourceType: ExerciseResourceEnum.WORDS),
        ]);
      default:
        return null;
    }
  }
}