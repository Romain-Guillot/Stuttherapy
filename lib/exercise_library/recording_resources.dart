import 'package:flutter/material.dart';

enum RecordingType {
  AUDIO,
  VIDEO,
}

/// TODO
class RecordingResource {
  String uri;
  RecordingType type;

  RecordingResource({
    @required this.uri,
    @required this.type,
  });
}

