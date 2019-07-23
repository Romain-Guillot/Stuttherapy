import 'package:flutter/material.dart';
import 'package:stuttherapy/exercise_library/settings.dart';


/// Widget to give a grahical representation of the [ExerciseSettingsItem]
/// property [field].
/// E.g. Imlementers can be Widgets that display a checkbox, a slider, etc.
abstract class SettingsItemWidget extends StatefulWidget {

  /// Settings item to display
  final ExerciseSettingsItem field;

  SettingsItemWidget({
    Key key, 
    @required this.field
  }) : super(key: key);
}