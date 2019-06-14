import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:stutterapy/account/accounts.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/providers/exercises_loader.dart';


///
///
///
class Manager {
  User user;
  Stream<UnmodifiableListView<ExerciseTheme>> themes;

    // Providers
  final ExercisesLoader _exercisesLoader = ExercisesLoader();

  Manager({@required this.user}) : assert(user != null) {
    themes = _exercisesLoader.getThemes();
  }
  

  
}