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

abstract class ExerciseResource {

}

class TextResource extends ExerciseResource {

}

class WordsResource extends ExerciseResource {

}

class SentencesResource extends ExerciseResource {
  
}