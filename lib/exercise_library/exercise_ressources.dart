import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exercise_ressources.g.dart';

/// Enum that lists all resoruce perception way
/// available
enum ResourcePerception {
  /// textual resource but initially covered (an action is needed to uncover the resource)
  TEXT_COVER,

  /// textual resource directly perceptible
  TEXT_UNCOVER,

  /// for resource available with an audio generated message
  AUDIO,
}


/// Enum that lists all different type of resources
enum ExerciseResourceEnum {
  /// Long text with several words, sentences, no restrictions
  TEXT,

  /// Sentence only allowed  (group of several words)
  SENTENCES,

  /// Word only allowed (so without spaces / punctuations ...)
  WORDS,
}


/// Class associated with an enum to defined a [getString] method
/// to convert enum object to string object.
/// 
/// Not really clean ... Hope that in future dart released 
/// method and constructor will be available for enum objects (so toString ...) ! 
/// note current dart version : Dart 2.3.3 (build 2.3.3-dev.0.0 b37aa3b036)
/// A cleaner solution can to migrate to class object with constant string
/// that represent enum and the value, much simpler  !!
abstract class EnumToString {
  getString(Object _);
}


/// [EnumToString] implementation for [ResourcePerception] enum
class ResourcePerceptionString implements EnumToString {
  getString(Object p) {
    switch (p) {
      case ResourcePerception.TEXT_COVER: return "Covered";
      case ResourcePerception.TEXT_UNCOVER: return "Uncovered";
      case ResourcePerception.AUDIO: return "Audio";
      default: return "Unknown perception";
    }
  }
}


/// [EnumToString] implementation for [ExerciseResourceEnum] enum
class ExerciseResourceString implements EnumToString {
  getString(Object r) {
    switch (r) {
      case ExerciseResourceEnum.TEXT: return "Medium / long text";
      case ExerciseResourceEnum.SENTENCES: return "Short sentences";
      case ExerciseResourceEnum.WORDS: return "Words";
      default: return "Unknown resource";
    }
  }
}


/// Resource used by [Exercise], basically it contain the 
/// [resource] a String value. Its type is characterized by 
/// the [resourceType] propertie (e.g. [ExerciseResourceEnum.TEXT])
@JsonSerializable()
class ExerciseResource {

  /// maincontent of the resource
  final String resource;

  /// type of the resource (e.g. sentences, words, text)
  final ExerciseResourceEnum resourceType;

  ExerciseResource({
    @required this.resource,
    @required this.resourceType
  }) :  assert(resource != null && resource.length > 0, "resource cannot be empty or null"),
        assert(resourceType != null, "Resource type has to be specified, it cannot be null");

  factory ExerciseResource.fromJson(Map<String, dynamic> json) => _$ExerciseResourceFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseResourceToJson(this);

  /// Return the list of words that composed the
  /// [resource]
  List<String> getWords() {
    RegExp reg = RegExp(r"(\w[\w']*)");
    return reg.allMatches(resource).map(
      (RegExpMatch match) => match.group(0)
    ).toList();
  }
}


/// Just an encapsulation of the to handle a collection
/// of [ExerciseResource]. This encapsulation used a [List]
/// object to handle the resources. It provide an iterator 
/// to iterate over [ExerciseResource]
@JsonSerializable()
class CollectionExerciseResource {
  final Iterable<ExerciseResource> resources;

  @JsonKey(ignore: true)
  final Iterator<ExerciseResource> _iterator;

  CollectionExerciseResource({
    @required this.resources
  }) : _iterator = resources.iterator;

  factory CollectionExerciseResource.fromJson(Map<String, dynamic> json) => _$CollectionExerciseResourceFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionExerciseResourceToJson(this);

  /// return the next [ExerciseResource] or null if no
  /// resource is available
  ExerciseResource get nextResource => _iterator.moveNext() ? _iterator.current : null;

}
