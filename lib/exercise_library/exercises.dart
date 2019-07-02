import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:stutterapy/exercise_library/exercise_ressources.dart';
import 'package:stutterapy/exercise_library/settings.dart';


/// Type of exercises, theme have a [name] two type of descri$tion,
/// one short ([shortDescription]) and a longer one to provide more
/// informations [longDescription].
/// 
/// [ExerciseTheme] defined the structure of an exercise with two 
/// important properties :
/// - [settings] : describe the exerises parameters (e.g. cover / uncover resource,
///     audio / textual resource perception, etc)
/// - [exerciseStructure] : describe the widget stucture of the exercise (which widget
///     used by the exercise, e.g. recorder, metronome, etc.)
/// 
/// Note : This whole package is a library, it has to come with an library implementation
/// to defined concrete exercises' themes (eg: DAF, metronome, etc.)
abstract class ExerciseTheme {

  /// Constants to characterized settings
  static const SETTINGS_PERCEPTION = "perception";
  static const SETTINGS_RESOURCE = "resource";
  static const SETTINGS_MANUALLY_CHECK = "pronuncation";
  
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

  /// {widget id (int) : description (string)} Map to describe which 
  /// widget used to display the exercise. 
  /// NOTE : Widgets IDs are defined by the exercise library implementation
  ///         e.g : a providers that associate widget with IDs.
  ///        Typically an Widget have access to the [Exercise] instance to
  ///         modify or read this properties
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
  }) :  assert(name != null, "name property cannot be null."),
        assert(shortDescription != null, "shortDescription cannot be null"),
        assert(longDescription != null, "longDescription cannot be null"),
        assert(exerciseStructure != null, "exerciseStructure cannot be null")
  {
    // Definied initial settings common to all exercises, can be modified by exercise implementation of course
    Map<String, ExerciseSettingsItem> _settings = {
      ...{
        SETTINGS_RESOURCE : ComboBoxField(
          label: "Resources", 
          items: ExerciseResourceEnum.values, 
          toStringItem: ExerciseResourceString(), 
          initialValue: ExerciseResourceEnum.SENTENCES
        ),
        SETTINGS_PERCEPTION : ComboBoxField(
          label: "Perception", 
          items: ResourcePerception.values, 
          initialValue: ResourcePerception.TEXT_UNCOVER, 
          toStringItem: ResourcePerceptionString()
        ),
        SETTINGS_MANUALLY_CHECK: BooleanField(
          label: "Manually check your pronuncation", 
          initialValue: true
        )
      },
      ...(exercisesSettings??{}) // list concatenation
    };
    settings = ExerciseSettings(items: _settings);
  }
}


/// Class that defined a training of the [theme].
/// An exercise is associated with [resources] basically text.
/// Some words can be added to the  [savedWords] set if needed.
/// 
/// An [Exercise] not only live in the training mode, it can be 
/// visualize in reading mode when it is finished. It's why it can
/// contain a [feedback].
/// 
/// NOTE : This extends [Comparable] to sort [Exercise]s by their [date].
class Exercise implements Comparable {

  ///Theme of the exercise
  final ExerciseTheme theme;

  /// Defined resources used by the exercise,it's
  /// the exercise content
  final CollectionExerciseResource resources;

  /// When the exercise has been started.
  final MyDateTime date;

  /// Set of words that have to be saved (e.g. : difficult words)
  Set<String> savedWords = {};

  /// Feedback provide for this training to keep information or
  /// correction about this exercise and data.
  ExerciseFeedback feedback;

  /// Stream that typically can be read by widgets to display informations
  /// 
  /// stream seeded with the false value, when the exercise has
  /// to be finished (e.g. : no resources available, finished button) true boolean object is
  /// added to this stream to indicate widgets that is the end of the training
  /// 
  /// This streams can be modify with the [stop] function to indicate it's the end of the
  /// exercise (fill the stream with true)
  final StreamController<bool> flagEndOfExercise = BehaviorSubject<bool>(seedValue: false);

   /// Stream that typically can be read by widgets to display informations
   /// 
   /// stream filled with current resource used by the exercise.
   /// This streams can be modifify with [moveNextResource] function to add a new resource inside 
   /// the stream.
  final StreamController<ExerciseResource> currentResource = BehaviorSubject<ExerciseResource>();

  /// Main constructor to ceate an [Exercise] instance for the first
  /// time. [currentResource] is init with a resource..
  Exercise({
    @required this.theme, 
    @required this.resources
  }) : this.date = MyDateTime.now() /*: assert(resources != null, "Please provide resources.")*/
  {
    moveNextResource(); // init [currentResource] stream with a resource
  }

  /// Constructor useful to restore an [Exercise] object. Typically
  /// to reconstruct an object from a file.
  Exercise.restore({
    @required this.theme,
    @required this.resources,
    @required this.date,
    @required this.savedWords,
    this.feedback
  });

  /// Load next resource in the stream if a resoruce is available
  /// to be add. If not, set the [flagEndOfExercise] to false to indicate
  /// the end of the exercise.
  moveNextResource() {
    ExerciseResource _res = resources?.nextResource;
    if(_res != null) {
      currentResource.add(_res);
    } else {
      flagEndOfExercise.add(true);
    }
  }

  /// Add a list of words to the current [savedWords] set.
  /// Words and lowercased before to be added.
  addSavedWords(Iterable<String> _words) {
    List<String> words = [];
    for(String word in _words) {
      words.add(word.toLowerCase());
    }
    savedWords.addAll(words);
  }

  /// Set the flag [flagEndOfExercise] to true.
  /// (fill the stream with true boolean object)
  stop() => flagEndOfExercise.add(true);

  /// Exercise are compared with their date
  /// (override the compare method with the date compare methode)
  @override
  int compareTo(other) => other.runtimeType == Exercise ? (other as Exercise).date.compareTo(date) : 0;
}


///
/// TODO
///
class ExerciseFeedback {
  String message;
}


/// Encapsulation of [DateTime] object to redefined the
/// [toString] method to return a String representation
/// that follow the following format : yyyy-MM-dd
class MyDateTime extends DateTime {

  static DateFormat _formatter =  DateFormat('yyyy-MM-dd');

  MyDateTime.now() : super.now();
  
  /// String representation of the date with the following format :
  /// yyyy-MM-dd
  @override
  String toString() {
    return _formatter.format(this);
  }
}