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
      case ExerciseResourceEnum.SENTENCES:
        return CollectionExerciseResource(resources: [
          ExerciseResource(resource: "Please wait outside of the house wait.", resourceType: ExerciseResourceEnum.SENTENCES), 
          ExerciseResource(resource: "Abstraction is often one floor above you.", resourceType: ExerciseResourceEnum.SENTENCES), 
          ExerciseResource(resource: "The body may perhaps compensates for the loss of a true metaphysics.", resourceType: ExerciseResourceEnum.SENTENCES), 

        ]);
      default:
        return null;
    }
  }
}