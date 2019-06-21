import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:stutterapy/exercise_library/exercise_ressources.dart';
import 'package:stutterapy/exercise_library/settings.dart';

///
///
///
abstract class ExerciseTheme {

  static const SETTINGS_PERCEPTION = "perception";
  static const SETTINGS_RESOURCE = "resource";
  static const SETTINGS_COVER_RES = "cover_res";
  
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

  Map<int, String> exerciseStructure;


  /// Exercise share common setting properties (e.g. : which type of resource, 
  /// which type of perception, etc)
  /// Sometime an exercise need also its own properties, this settings items 
  /// can be specified with the [Map] [exercisesSettings] (key : identifiant,
  /// value: the [ExerciseSettingsItem]).
  ExerciseTheme({
    @required this.name, 
    @required this.shortDescription, 
    @required this.longDescription, 
    @required this.exerciseStructure,
    Map<String, ExerciseSettingsItem> exercisesSettings
  }) {
    Map<String, ExerciseSettingsItem> _settings = {
      ...{
        SETTINGS_COVER_RES : BooleanField(label: "Cover sentences", requiredField: false),
        SETTINGS_RESOURCE : ComboBoxField(label: "Resources", items: ExerciseResourceEnum.values, toStringItem: ExerciseResourceString.getString, initialValue: ExerciseResourceEnum.SENTENCES),
        SETTINGS_PERCEPTION : ComboBoxField(label: "Perception", items: ResourcePerception.values, initialValue: ResourcePerception.TEXT_COVER, toStringItem: ResourcePerceptionString.getString)
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
  final ExerciseTheme theme;
  final CollectionExerciseResource resources;

  final StreamController<bool> flagEndOfExercise = BehaviorSubject<bool>(seedValue: false);
  final StreamController<ExerciseResource> currentResource = BehaviorSubject<ExerciseResource>();

  Exercise({
    @required this.theme, 
    @required this.resources}
  ) /*: assert(resources != null, "Please provide resources.")*/
  {
    moveNextResource();
  }

  moveNextResource() {
    ExerciseResource _res = resources?.nextResource;
    if(_res != null) {
      currentResource.add(_res);
    } else {
      flagEndOfExercise.add(true);
    }
  }
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