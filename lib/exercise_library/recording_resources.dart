import 'package:flutter/material.dart';

/// Different type of the recording resource that can
/// exists.
enum RecordingType {
  /// only audio will be recorded
  AUDIO,

  /// video and audio will be recorded
  VIDEO,
}

/// Data class for the recording resources. It contain the [uri] of the 
/// resource store on the device and the [type] of the resource
class RecordingResource {
  String uri;
  RecordingType type;

  RecordingResource({
    @required this.uri,
    @required this.type,
  });
}

