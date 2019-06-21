import 'package:flutter/foundation.dart';
import 'package:stutterapy/exercise_library/exercises.dart';

enum ResourcePerception {
  TEXT_COVER,
  TEXT_UNCOVER,
  AUDIO,
}

enum ExerciseResourceEnum {
  TEXT,
  SENTENCES,
  WORDS,
}

class ResourcePerceptionString {
  static getString(Object p) {
    switch (p) {
      case ResourcePerception.TEXT_COVER: return "Covered";
      case ResourcePerception.TEXT_UNCOVER: return "Uncovered";
      case ResourcePerception.AUDIO: return "Audio";
      default: return "Unknown perception";
    }
  }
}

class ExerciseResourceString {
  static getString(Object r) {
    switch (r) {
      case ExerciseResourceEnum.TEXT: return "Medium / long text";
      case ExerciseResourceEnum.SENTENCES: return "Short sentences";
      case ExerciseResourceEnum.WORDS: return "Words";
      default: return ("Unknown resource");
    }
  }
}

class ExerciseResource {
  final String resource;
  final ExerciseResourceEnum resourceType;

  ExerciseResource({@required this.resource, @required this.resourceType});
}


class CollectionExerciseResource {
  final List<ExerciseResource> resources;
  final Iterator _iterator;

  CollectionExerciseResource({@required this.resources}) : _iterator = resources.iterator;

  ExerciseResource get nextResource => _iterator.moveNext() ? _iterator.current : null;

}