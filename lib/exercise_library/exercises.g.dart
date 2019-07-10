// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercises.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseTheme _$ExerciseThemeFromJson(Map<String, dynamic> json) {
  return ExerciseTheme(
      name: json['name'] as String,
      shortDescription: json['shortDescription'] as String,
      longDescription: json['longDescription'] as String);
}

Map<String, dynamic> _$ExerciseThemeToJson(ExerciseTheme instance) =>
    <String, dynamic>{
      'name': instance.name,
      'shortDescription': instance.shortDescription,
      'longDescription': instance.longDescription
    };

Exercise _$ExerciseFromJson(Map<String, dynamic> json) {
  return Exercise(
      theme: json['theme'] == null
          ? null
          : ExerciseTheme.fromJson(json['theme'] as Map<String, dynamic>),
      resources: json['resources'] == null
          ? null
          : CollectionExerciseResource.fromJson(
              json['resources'] as Map<String, dynamic>))
    ..recordingResource = json['recordingResource'] == null
        ? null
        : RecordingResource.fromJson(
            json['recordingResource'] as Map<String, dynamic>)
    ..savedWords =
        (json['savedWords'] as List)?.map((e) => e as String)?.toSet()
    ..feedback = json['feedback'] == null
        ? null
        : ExerciseFeedback.fromJson(json['feedback'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ExerciseToJson(Exercise instance) => <String, dynamic>{
      'theme': instance.theme,
      'resources': instance.resources,
      'recordingResource': instance.recordingResource,
      'savedWords': instance.savedWords?.toList(),
      'feedback': instance.feedback
    };

ExerciseFeedback _$ExerciseFeedbackFromJson(Map<String, dynamic> json) {
  return ExerciseFeedback(message: json['message'] as String);
}

Map<String, dynamic> _$ExerciseFeedbackToJson(ExerciseFeedback instance) =>
    <String, dynamic>{'message': instance.message};
