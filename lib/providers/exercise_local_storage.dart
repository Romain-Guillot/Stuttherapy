
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stutterapy/exercise_library/exercises.dart';


const String DATABASE = "stuttherapy.db";
const int VERSION = 1;
final DatabaseHandler dbHandler = DatabaseHandlerImplem();


class ExerciseLocalStorageProvider {
  static const String DATABASE_NAME = "stuttherapy.db";
  static const int DATABASE_VERSION = VERSION;

  static const String TABLE_EXERCISE = "exercise";
  static const String TABLE_EXERCISE_ID_COLUMN = "id";
  static const String TABLE_EXERCISE_CONTENT_COLUMN = "content";

  static const String TABLE_SAVED_WORD = "savedword";
  static const String TABLE_SAVED_WORD_CONTENT_COLUMN = "content";

  static Database db;
  

  static Future open() async {
    if(db == null)
      db = await dbHandler.open();
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

abstract class DatabaseHandler {
  Future<Database> open();
}


abstract class TableHelper<T> {

  DatabaseHandler handler;
  Database db;
  final String tableName;

  TableHelper({@required this.tableName, @required this.handler});

  open() async {
    db = await handler.open();
  }

  Future insert<T>(T object) async {
    if(db == null)
      await open();
  }

  Future insertAll<T>(Set<T> list) async {
    if(db == null)
      await open();
  }

  Future<T> all() async {
    if(db == null)
      await open();
    return null;
  }

  Future wipe() async {
    if(db == null)
      await open();
    await db.delete(tableName);
  }
}


class DatabaseHandlerImplem implements DatabaseHandler {

  Future<Database> open() async {
    return await openDatabase(
      join((await getDatabasesPath()), DATABASE),
      onCreate: (db, version) async {
        print("Tables creation ... !");
        await db.execute('''
          CREATE TABLE ${ExerciseLocalStorageProvider.TABLE_EXERCISE} (
            ${ExerciseLocalStorageProvider.TABLE_EXERCISE_ID_COLUMN} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${ExerciseLocalStorageProvider.TABLE_EXERCISE_CONTENT_COLUMN} TEXT NOT NULL
          )
          ''');
        await db.execute('''
          CREATE TABLE ${SavedWordsLocalStorageProvider.TABLE_NAME} (
            ${SavedWordsLocalStorageProvider.COLUMN_CONTENT} TEXT PRIMARY KEY
          )''');
      },
      version: VERSION
    );
  }
}


class SavedWordsLocalStorageProvider<String> extends TableHelper {

  static const TABLE_NAME = "savedword";
  static const COLUMN_CONTENT = "content";

  SavedWordsLocalStorageProvider() : super(tableName: TABLE_NAME, handler: dbHandler);
  
  @override
  Future insert<String>(String object) async {
    await super.insert(null); 
    await db.insert(tableName, {COLUMN_CONTENT: object});
  }

  @override
  Future insertAll<String>(Set<String> list) async {
    await super.insertAll(null);
    Batch batch = db.batch();
    list.forEach( (s) =>
      batch.rawQuery("INSERT OR REPLACE INTO $tableName VALUES('$s')")
    );
    await batch.commit(noResult: true);
  }

  @override
  Future<Set> all() async {
    await super.all();
    var queries = await db.query(tableName);
    Set results = queries.map((var row) => row[COLUMN_CONTENT]).toSet();
    return results;
  }



  
}

