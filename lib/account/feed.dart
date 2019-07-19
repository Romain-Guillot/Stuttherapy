import 'package:flutter/foundation.dart';
import 'package:stuttherapy/exercise_library/date.dart';

class Feed {
  List<FeedItem> items = [];

  addItems(List<FeedItem> _items) {
    items.addAll(_items);
    items.sort();
  }
}

abstract class FeedItem implements Comparable {
  
  MyDateTime date;
  String label;

  @override
  int compareTo(other);
}

class Comment implements FeedItem {
  MyDateTime date;
  String message;
  String label = "Comment";

  Comment({@required this.date, @required this.message});

  @override
  int compareTo(other) => (other.date?.compareTo(date))??0;

  @override
  String toString() => this.message;
}