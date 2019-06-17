import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/settings.dart';
import 'package:stutterapy/ui/settings/boolean_field.dart';
import 'package:stutterapy/ui/settings/combo_box_widget.dart';

class SettingsWidgetProvider {

  static Widget getSettingsWidget(ExerciseSettingsItem item) {
    switch (item.runtimeType) {
      case BooleanField:
        return BooleanFieldWidget(field: item,);
      case ComboBoxField:
        return ComboBoxWidget(field: item,);
      default: 
        return null;
    }
  }
}