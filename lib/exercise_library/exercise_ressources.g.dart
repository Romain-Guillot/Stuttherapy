// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_ressources.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseResource _$ExerciseResourceFromJson(Map<String, dynamic> json) {
  return ExerciseResource(
      resource: json['resource'] as String,
      resourceType: _$enumDecodeNullable(
          _$ExerciseResourceEnumEnumMap, json['resourceType']));
}

Map<String, dynamic> _$ExerciseResourceToJson(ExerciseResource instance) =>
    <String, dynamic>{
      'resource': instance.resource,
      'resourceType': _$ExerciseResourceEnumEnumMap[instance.resourceType]
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$ExerciseResourceEnumEnumMap = <ExerciseResourceEnum, dynamic>{
  ExerciseResourceEnum.TEXT: 'TEXT',
  ExerciseResourceEnum.SENTENCES: 'SENTENCES',
  ExerciseResourceEnum.WORDS: 'WORDS'
};

CollectionExerciseResource _$CollectionExerciseResourceFromJson(
    Map<String, dynamic> json) {
  return CollectionExerciseResource(
      resources: (json['resources'] as List)?.map((e) => e == null
          ? null
          : ExerciseResource.fromJson(e as Map<String, dynamic>)));
}

Map<String, dynamic> _$CollectionExerciseResourceToJson(
        CollectionExerciseResource instance) =>
    <String, dynamic>{'resources': instance.resources?.toList()};
