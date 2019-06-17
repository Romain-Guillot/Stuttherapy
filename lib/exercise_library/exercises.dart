import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/exercise_ressources.dart';
import 'package:stutterapy/exercise_library/settings.dart';

abstract class ExerciseTheme {
  final String name;
  final String shortDescription;
  final String longDescription;
  ExerciseSettings settings;

  ExerciseTheme({@required this.name, @required this.shortDescription, @required this.longDescription, Map<String, ExerciseSettingsItem> exercisesSettings}) {
    Map _basicSettings = {
      'cover_sentences' : BooleanField(label: "Cover sentences"),
      'resource' : ComboBoxField(label: "Resources", items: ["dfgfd"]),
      'perception': ComboBoxField(label: "Perception", items: ResourcePerception.values, initialValue: ResourcePerception.TEXT_COVER, toStringItem: ResourcePerceptionString.getString)
    };



    Map<String, ExerciseSettingsItem> _settings = {
      ..._basicSettings,
      ...(exercisesSettings??{})
    };
    settings = ExerciseSettings(items: _settings);
  }
}

class Exercise {

}

class ExerciseProgression {

}

class ExerciseFeedback {

}