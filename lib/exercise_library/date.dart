import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'date.g.dart';

/// Encapsulation of [DateTime] object to redefined the
/// [toString] method to return a String representation
/// that follow the following format : yyyy-MM-dd
@JsonSerializable()
class MyDateTime implements Comparable {

  DateTime date;

  @JsonKey(ignore: true)
  static DateFormat _formatter =  DateFormat('yyyy-MM-dd HH:mm');

  MyDateTime(this.date);

  factory MyDateTime.fromJson(Map<String, dynamic> json) => _$MyDateTimeFromJson(json);

  Map<String, dynamic> toJson() => _$MyDateTimeToJson(this);
  
  /// String representation of the date with the following format :
  /// yyyy-MM-dd
  @override 
  String toString() => _formatter.format(date);

  @override 
  int compareTo(other) => other.runtimeType == MyDateTime ? (date.compareTo((other as MyDateTime).date)) : 0;
}