import 'package:flutter/foundation.dart';
import 'package:stutterapy/exercise_library/exercise_ressources.dart';


/// Provide of way to describe [Exercise] settings parameters.
/// Basically it's a [Map] with each pair of key / value means :
/// * the key : a string ID that to identify the setting
/// * the value : an [ExerciseSettingsItem] that represent the content of the settings
class ExerciseSettings {

  Map<String, ExerciseSettingsItem> _items;

  ExerciseSettings({
    @required Map<String, ExerciseSettingsItem> items
  }) : _items = items;

  /// Return if the settings are correctly fill according
  /// to each [ExerciseSettingsItem] requirements.
  /// Maybe find a more elegant way to write this ...
  bool isValid() {
    for(ExerciseSettingsItem item in _items.values) {
      if(!item.isValid())
        return false;
    }
    return true;
  }

  /// Redefined [] operator to return directly the value
  /// associated to the item identified by the String [id]
  operator [](String id) => _items[id].value;

  /// Getter to return all [_items]
  Map<String, ExerciseSettingsItem> all() => _items;

  /// Getter to return a specific item (consider using)
  /// the operator [] if you want to read directly the
  /// value associated to the item [id]
  ExerciseSettingsItem get(String id) => _items[id];
}


/// Abstract class that every settings item has to extends
/// An [ExerciseSettingsItem] object has a [name] to desccribe
/// its purpose.
abstract class ExerciseSettingsItem {

  /// parameter purpose (what it handle)
  String label;

  /// set to true if this the settings cannot be modified
  bool disable;

  /// value associated with this settings
  Object _value;

  /// indicate if it's a required field (can be interpreted 
  /// differently by the implementations)
  bool requiredField;

  ExerciseSettingsItem({
    @required this.label,
    value,
    this.disable = false,
    this.requiredField = true
  }) :  _value = value,
        assert(disable != null),
        assert(label != null, "Label cannot be null");

  /// get the value associated with this setting item
  Object get value => _value;

  /// change the current value of the item (if possible)
  set value(Object newValue) {
    if(!disable)
      _value = newValue;
    else
      throw Exception("Cannot change settings value (disable set to true)");
  }

  /// Return the validity of the parameter according to the
  /// properties ([value] and [requiredField])
  bool isValid() => (requiredField && (value != null)) || !requiredField;
}


/// [ExerciseSettingsItem] implementation to provide combobox
/// settings (list of selectionnable [items]), only one can
/// be selectionnable at time. [toStringItem] is an object of
/// [EnumToString] implementation that provide a service to
/// transform an Object to a String (useful if the [items]) are
/// enum Object ! See [EnumToString] to understand this "limitiation"...
class ComboBoxField extends ExerciseSettingsItem {

  List<Object> items;
  EnumToString toStringItem;
  
  ComboBoxField({
    @required String label,
    @required this.items,
    Object initialValue,
    this.toStringItem,
    bool disable = false,
    bool requiredField = true
  }) : assert(items != null && items.length >= 1),
       assert((disable && initialValue != null) || !disable),
       super(
         label: label, 
         disable: disable,
         value: initialValue,
         requiredField: requiredField);
}


/// [ExerciseSettingsItem] implementation to provide an integer
/// slider that can takes integer value between [min] and [max]
/// Slider can be slider for percentage value, so [percentageValues] can
/// be set to true. (if [percentageValues] is NOT set to true, [max] value is required)
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
  }) : assert(max != null || percentageValues, "Max value cannot be null (except if percentageValues is set to true)"),
       assert(percentageValues || max > min, "Max value have to be higher than min value"),
       assert((percentageValues && min >= 0 && (max == null || max <= 100)) || !percentageValues, "Max value has to be less than 100 if percentageValues is set to true (and min > 0"),
       super(
         label: label,
         disable: disable,
         value: initialValue??min,
         requiredField: requiredField) 
  {
    if(percentageValues)
      max = max??100;
  }

  @override
  bool isValid() => super.isValid() && ((value as int) >= min && (value as int) <= max);
}


/// [ExerciseSettingsItem] implementation to provide an a checbox
/// setting item.
/// 
/// Note that in this implementation [requiredField] means that
/// the checkbox has to be checked !
class BooleanField extends ExerciseSettingsItem {

  BooleanField({
    @required String label,
    bool disable = false,
    bool initialValue = false,
    bool requiredField = false
  }) : assert(initialValue != null),
       assert(!disable || (disable && requiredField && initialValue)),
       super(
         label: label,
         disable: disable,
         value: initialValue,
         requiredField: requiredField);

  @override
  bool isValid() => super.isValid() && ((requiredField && value == true) || !requiredField);
}