import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/settings.dart';


///
///
///
abstract class SettingsItemWidget extends StatefulWidget {

  ///
  final ExerciseSettingsItem field;

  SettingsItemWidget({
    Key key, 
    @required this.field
  }) : super(key: key);
}