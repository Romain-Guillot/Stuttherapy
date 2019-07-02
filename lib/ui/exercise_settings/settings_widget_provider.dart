
import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/settings.dart';
import 'package:stutterapy/ui/exercise_settings/boolean_widget.dart';
import 'package:stutterapy/ui/exercise_settings/combo_box_widget.dart';
import 'package:stutterapy/ui/exercise_settings/integer_slider_widget.dart';

/// Provide an unique method to get the [Widget] corresponding to
/// the [ExerciseSettingsItem] pass as argument.
/// Return [null] if no [Widget] is implemented for this [ExerciseSettingsItem]
/// subtype.
class SettingsWidgetProvider {
  static Widget getWidget(ExerciseSettingsItem item) {
    switch (item.runtimeType) {
      case BooleanField:
        return BooleanFieldWidget(field: item);
      case ComboBoxField:
        return ComboBoxWidget(field: item);
      case IntegerSliderField:
        return IntegerSliderWidget(field: item);
      default: 
        return null;
    }
  }
}