import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recording_resources.g.dart';

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
@JsonSerializable()
class RecordingResource {
  String uri;
  RecordingType type;

  RecordingResource({
    @required this.uri,
    @required this.type,
  });

  factory RecordingResource.fromJson(Map<String, dynamic> json) => _$RecordingResourceFromJson(json);

  Map<String, dynamic> toJson() => _$RecordingResourceToJson(this);
}

