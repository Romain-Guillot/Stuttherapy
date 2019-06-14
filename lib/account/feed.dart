import 'package:flutter/foundation.dart';

class Feed {
  List<FeedItem> items;
}

abstract class FeedItem {
  String label;

  FeedItem({@required this.label}) : assert(label != null);
}

class Comment extends FeedItem {
  Comment() : super(label: "Comment");
}

class SuggestedExercise extends FeedItem {
  SuggestedExercise() : super(label: "Suggested Exercise");
} 

class ExerciseFeedback extends FeedItem {
  ExerciseFeedback() : super(label: "Exercise Feedback");
}