import 'package:stuttherapy/exercise_library/exercise_ressources.dart';

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
      case ExerciseResourceEnum.TEXT:
      return CollectionExerciseResource(resources: [
        ExerciseResource(
          resourceType: ExerciseResourceEnum.TEXT,
          resource: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum")
      ]);
      default:
        return null;
    }
  }
}