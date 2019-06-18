import 'dart:collection';

import 'package:flutter/foundation.dart';

class ExerciseSettings {

  Map<String, ExerciseSettingsItem> items;

  ExerciseSettings({
    @required this.items
  });

  bool isValid() {
    for(ExerciseSettingsItem item in items.values) {
      if(!item.isValid())
        return false;
    }
    return true;
  }
}

abstract class ExerciseSettingsItem {
  String label;
  bool disable;
  Object value;
  bool requiredField;

  ExerciseSettingsItem({
    @required this.label,
    this.value,
    this.disable = false,
    this.requiredField = true
  }) : 
  assert(disable != null),
  assert(label != null, "Label cannot be null");

  bool isValid() => (requiredField && (value != null)) || !requiredField;
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
    bool disable = false,
    bool requiredField = true
  }) : 
  assert(items != null && items.length >= 1),
  assert((disable && initialValue != null) || !disable),
  super(
        label: label, 
        disable: disable,
        value: initialValue,
        requiredField: requiredField
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
    int initialValue,
    bool requiredField = true
  }) : 
    assert(max != null || percentageValues, "Max value cannot be null (except if percentageValues is set to true)"),
    assert(percentageValues || max > min, "Max value have to be higher than min value"),
    assert((percentageValues && (max == null || max <= 100)) || !percentageValues, "Max value has to be less than 100 if percentageValues is set to true"),
    super(
      label: label,
      disable: disable,
      value: initialValue??min,
      requiredField: requiredField
  ) {
    if(percentageValues)
      max = max??100;
  }

  bool isValid() => super.isValid() && ((value as int) >= min && (value as int) <= max);


}

/// requird field ==> checkbox check
class BooleanField extends ExerciseSettingsItem {

  BooleanField({
    @required String label,
    bool disable = false,
    bool initialValue = false,
    bool requiredField = false
  }) : 
  assert(initialValue != null),
  assert(!disable || (disable && requiredField && initialValue)),
  super(
    label: label,
    disable: disable,
    value: initialValue,
    requiredField: requiredField
  );

  bool isValid() => super.isValid() && ((requiredField && value == true) || !requiredField);

}