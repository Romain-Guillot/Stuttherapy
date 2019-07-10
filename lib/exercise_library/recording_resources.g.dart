// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording_resources.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordingResource _$RecordingResourceFromJson(Map<String, dynamic> json) {
  return RecordingResource(
      uri: json['uri'] as String,
      type: _$enumDecodeNullable(_$RecordingTypeEnumMap, json['type']));
}

Map<String, dynamic> _$RecordingResourceToJson(RecordingResource instance) =>
    <String, dynamic>{
      'uri': instance.uri,
      'type': _$RecordingTypeEnumMap[instance.type]
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

const _$RecordingTypeEnumMap = <RecordingType, dynamic>{
  RecordingType.AUDIO: 'AUDIO',
  RecordingType.VIDEO: 'VIDEO'
};
