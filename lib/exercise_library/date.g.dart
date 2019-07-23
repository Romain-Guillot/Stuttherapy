// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyDateTime _$MyDateTimeFromJson(Map<String, dynamic> json) {
  return MyDateTime(
      json['date'] == null ? null : DateTime.parse(json['date'] as String));
}

Map<String, dynamic> _$MyDateTimeToJson(MyDateTime instance) =>
    <String, dynamic>{'date': instance.date?.toIso8601String()};
