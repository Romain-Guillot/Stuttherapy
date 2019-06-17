import 'dart:collection';

import 'package:flutter/foundation.dart';

class ExerciseSettings {

  Map<String, ExerciseSettingsItem> items;

  ExerciseSettings({
    @required this.items
  });
}

abstract class ExerciseSettingsItem {
  String label;
  bool disable;
  Object value;

  ExerciseSettingsItem({
    @required this.label,
    this.value,
    this.disable = false,
  }) : 
  assert(disable != null),
  assert(label != null, "Label cannot be null");
}

class ComboBoxField extends ExerciseSettingsItem {
  List<Object> items;
  Object _currentValue;
  Function(Object) toStringItem;
  
  Object get currentValue => _currentValue;

  ComboBoxField({
    @required String label,
    @required this.items,
    Object initialValue,
    this.toStringItem,
    bool disable = false
  }) : 
  assert(items != null && items.length >= 1),
  assert((disable && initialValue != null) || !disable),
  super(
        label: label, 
        disable: disable,
        value: initialValue
       );
}

class IntegerSliderField extends ExerciseSettingsItem {
  bool percentageValues;
  int min;
  int max;

  IntegerSliderField({
    @required String label,
    bool disable = false,
    this.percentageValues = false,
    this.min = 0,
    this.max,
    int initialValue
  }) : 
    assert(max != null || percentageValues, "Max value cannot be null (except if percentageValues is set to true)"),
    assert(percentageValues || max > min, "Max value have to be higher than min value"),
    assert((percentageValues && (max == null || max <= 100)) || !percentageValues, "Max value has to be less than 100 if percentageValues is set to true"),
    super(
      label: label,
      disable: disable,
      value: initialValue??min
  );

}

class BooleanField extends ExerciseSettingsItem {

  BooleanField({
    @required String label,
    bool disable = false,
    bool initialValue = false,
  }) : 
  assert(initialValue != null),
  super(
    label: label,
    disable: disable,
    value: initialValue
  );

}