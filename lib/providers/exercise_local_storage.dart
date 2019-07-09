
import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stutterapy/exercise_library/exercises.dart';


class ExerciseLocalStorageProvider {
  static const String DATABASE_NAME = "stuttherapy.db";
  static const int DATABASE_VERSION = 1;
  static const String TABLE_EXERCISE = "exercise";
  static const String TABLE_EXERCISE_ID_COLUMN = "id";
  static const String TABLE_EXERCISE_CONTENT_COLUMN = "content";

  static Database db;
  

  static Future open() async {
    db = await openDatabase(
      join((await getDatabasesPath()), DATABASE_NAME),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $TABLE_EXERCISE (
            $TABLE_EXERCISE_ID_COLUMN INTEGER PRIMARY KEY AUTOINCREMENT,
            $TABLE_EXERCISE_CONTENT_COLUMN TEXT NOT NULL
          )'''
        );
      },
      version: DATABASE_VERSION
    );
  }

  static Future<int> insert(Exercise exercise) async {
    if(db == null)
      await open();
    
    String exerciseJson = jsonEncode(exercise.toJson());
    int id = await db.insert(TABLE_EXERCISE, {TABLE_EXERCISE_CONTENT_COLUMN: exerciseJson});
    return id;
    
  }

  static Future<Map<ExerciseTheme, List<Exercise>>> all(Map<String, ExerciseTheme> themes) async {
    if(db == null)
      await open();
    
    List<Map<String, dynamic>> progressions = await db.query(TABLE_EXERCISE, columns: [TABLE_EXERCISE_CONTENT_COLUMN]);
    if(progressions != null) {
      Map<ExerciseTheme, List<Exercise>> exercises = {};
      themes.values.forEach((ExerciseTheme theme) => exercises[theme] = []);

      for(Map<String, dynamic> row in progressions) {
        Map json = jsonDecode(row[TABLE_EXERCISE_CONTENT_COLUMN]);
        Exercise exercise = Exercise.fromJson(json);
        try {
          exercises[themes[exercise.theme.name]].add(exercise);
        } catch(e) {
          print("Unable to add exercise to ${exercise.theme.name}.");
        }
      }
      return exercises;
    }else {
      return null;
    }
  }

  static Future wipe() async {
    if(db == null)
      await open();

    await db.delete(TABLE_EXERCISE);
  }
}

