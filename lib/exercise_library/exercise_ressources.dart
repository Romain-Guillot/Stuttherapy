enum ResourcePerception {
  TEXT_COVER,
  TEXT_UNCOVER,
  AUDIO,
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