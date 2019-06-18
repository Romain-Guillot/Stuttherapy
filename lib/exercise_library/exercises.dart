import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/exercise_ressources.dart';
import 'package:stutterapy/exercise_library/settings.dart';

///
///
///
abstract class ExerciseTheme {
  
  /// Title that describe the theme (has to be short)
  final String name;

  /// Short descrition to desribe in few words the theme
  final String shortDescription;

  /// A longer descrition to describe the purpose of the exercise 
  /// It can provide answers to these questions :
  ///   - why the theme can help "insert whatever"
  ///   - how to properly do the exercise
  final String longDescription;

  /// Theme settings, refer to the constructor to see basic settings
  /// Constructor comment provide helps about the theme settings.
  ExerciseSettings settings;


  /// Exercise share common setting properties (e.g. : which type of resource, 
  /// which type of perception, etc)
  /// Sometime an exercise need also its own properties, this settings items 
  /// can be specified with the [Map] [exercisesSettings] (key : identifiant,
  /// value: the [ExerciseSettingsItem]).
  ExerciseTheme({@required this.name, @required this.shortDescription, @required this.longDescription, Map<String, ExerciseSettingsItem> exercisesSettings}) {
    Map<String, ExerciseSettingsItem> _settings = {
      ...{
        'cover_sentences' : BooleanField(label: "Cover sentences", requiredField: false),
        'resource' : ComboBoxField(label: "Resources", items: ["dfgfd"]),
        'perception': ComboBoxField(label: "Perception", items: ResourcePerception.values, initialValue: ResourcePerception.TEXT_COVER, toStringItem: ResourcePerceptionString.getString)
      },
      ...(exercisesSettings??{})
    };
    settings = ExerciseSettings(items: _settings);
  }
}


///
///
///
class Exercise {

}


///
///
///
class ExerciseProgression {

}


///
///
///
class ExerciseFeedback {

}