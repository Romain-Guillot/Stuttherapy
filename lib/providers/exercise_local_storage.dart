
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stutterapy/exercise_library/exercises.dart';


const String DATABASE = "stuttherapy.db";
const int VERSION = 1;
final DatabaseHandler dbHandler = DatabaseHandlerImplem();



abstract class DatabaseHandler {
  Future<Database> open();
}



abstract class TableHelper {

  static Database _db;
  DatabaseHandler handler;
  final String tableName;
  
  TableHelper({@required this.tableName, @required this.handler});

  _open() async {
    _db = await handler.open();
  }

  @mustCallSuper
  Future insert(dynamic object) async {
    if(_db == null)
      await _open();
  }

  @mustCallSuper
  Future insertAll(Set<dynamic> list) async {
    if(_db == null)
      await _open();
  }

  @mustCallSuper
  Future all() async {
    if(_db == null)
      await _open();
  }
  
  Future wipe() async {
    if(_db == null)
      await _open();
    await _db.delete(tableName);
  }

  Database get db => _db;
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



class SavedWordsLocalStorageProvider extends TableHelper {

  static const TABLE_NAME = "savedword";
  static const COLUMN_CONTENT = "content";

  SavedWordsLocalStorageProvider() : super(tableName: TABLE_NAME, handler: dbHandler);
  
  @override
  Future insert(dynamic object) async {
    await super.insert(null); 
    await db.insert(tableName, {COLUMN_CONTENT: object});
  }

  @override
  Future insertAll(Set<dynamic> list) async {
    await super.insertAll(null);
    Batch batch = db.batch();
    list.forEach( (s) =>
      batch.rawQuery("INSERT OR REPLACE INTO $tableName VALUES('$s')")
    );
    await batch.commit(noResult: true);
  }

  @override
  Future<Set<String>> all() async {
    await super.all();
    List<Map<String, dynamic>> queries = await db.query(tableName);
    Set<String> results = queries.map((Map<String, dynamic> row) => row[COLUMN_CONTENT] as String).toSet();
    return results;
  }
}



class ExerciseLocalStorageProvider extends TableHelper {

  static const TABLE_EXERCISE = "exercise";
  static const TABLE_EXERCISE_ID_COLUMN = "id";
  static const TABLE_EXERCISE_CONTENT_COLUMN = "content";
  
  ExerciseLocalStorageProvider() : super(handler: dbHandler, tableName: TABLE_EXERCISE);

  @override
  Future<int> insert(dynamic exercise) async {
    await super.insert(null);

    String exerciseJson = jsonEncode(exercise.toJson());
    int id = await db.insert(TABLE_EXERCISE, {TABLE_EXERCISE_CONTENT_COLUMN: exerciseJson});
    return id;
  }

  @override
  Future insertAll(Set<dynamic> list) async {
    await super.insertAll(null);
  }

  Future<Map<ExerciseTheme, List<Exercise>>> all({@required Map<String, ExerciseTheme> themes}) async {
    await super.all();
    
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
}