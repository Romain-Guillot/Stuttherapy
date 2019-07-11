/// This file include class to handle SQLite tables to handle
/// [Exercise] progressions and words saved by user
/// SQLite database is used with sqflite flutter plugin
/// Find more detail about it in :
/// * official documentation : https://pub.dev/packages/sqflite 
/// * get started flutter guide : https://flutter.dev/docs/cookbook/persistence/sqlite
/// 
/// NOTE : Database is useful for larger data, is you just want
/// to store single element, settings, or other small data consider
/// user [SharedPreference] see the file "shared_pref_provider.dart" to
/// use it.
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:logger/logger.dart';
import 'package:stuttherapy/log_printer.dart';

/// Name of the database used to store data for this application
const String DATABASE = "stuttherapy.db";

/// Current version of the tables structure
const int VERSION = 1;

/// Handle to create, open or update the database
final DatabaseHandler dbHandler = DatabaseHandlerImplem();



/// This class provide the open method to make the connection
/// to the database. This method return a [Database].
abstract class DatabaseHandler {
  Future<Database> open();
}



/// This class defined basic operation supported on tables.
/// Basically insert, delete, wipe (delete all), etc.
/// It's an abstract class that do nothing exept opened a new
/// connection to the database if it's not already opened
/// So each method implemented have to call the super constructor
/// that handle the connection.
/// 
/// Note : it can be better to user generic type for this class
/// to have static type field instead of dynamic type.
abstract class TableHelper {

  static Database _db;
  DatabaseHandler handler;
  final String tableName;
  
  TableHelper({@required this.tableName, @required this.handler});

  _open() async {
    try {
      _db = await handler.open();
      DatabaseLogger.open(success: true, tableName: tableName);
    } catch(err, stack) {
      DatabaseLogger.open(success: false, tableName: tableName, error: err, stacktrace: stack);
    }
    
  }

  /// insert on record into the table [tableName]
  @mustCallSuper
  Future insert(dynamic object) async {
    if(_db == null)
      await _open();
  }

  /// insert the collection [list] of records into [tableName]
  @mustCallSuper
  Future insertAll(Set<dynamic> list) async {
    if(_db == null)
      await _open();
  }

  /// select all records into [tableName]
  @mustCallSuper
  Future all() async {
    if(_db == null)
      await _open();
  }

  /// delete one record (with the primary key [key]) into [tableName]
  @mustCallSuper
  Future delete(dynamic key) async {
    if(_db == null)
      await _open();
  }
  
  /// delete all records into [tableName]
  Future wipe() async {
    try {
      if(_db == null)
      await _open();
      int status = await _db.delete(tableName);
      DatabaseLogger.wipe(success: true, tableName: tableName, nbOfRowDeleted: status);
    } catch(err, stack) {
      DatabaseLogger.wipe(success: false, tableName: tableName, error: err, stacktrace: stack);
    }
  }

  /// Return the [Database] to perform sql operation on it
  Database get db => _db;
}


/// Implementation of [DatabaseHandler] to create / open /
/// upgrade or other operation that modify the structure of the
/// tables.
/// For the application we create 2 table, one to store [Exercise]
/// progression on the other to store the words savec by the user.
/// The table schema chose is pretty simple, we store directly the 
/// serialized object into a TEXT field (for the exercise progression
/// we add an autoincremented primary key). For the savec word, the word
/// is directly the primary key as it make no sense to have the same 
/// words  saved sevaral times.
class DatabaseHandlerImplem implements DatabaseHandler {

  Future<Database> open() async {
    return await openDatabase(
      join((await getDatabasesPath()), DATABASE),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${ExerciseLocalStorageProvider.TABLE_EXERCISE} (
            ${ExerciseLocalStorageProvider.TABLE_EXERCISE_ID_COLUMN} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${ExerciseLocalStorageProvider.TABLE_EXERCISE_CONTENT_COLUMN} TEXT NOT NULL
          )
          ''');
        DatabaseLogger.create(tableName: ExerciseLocalStorageProvider.TABLE_EXERCISE);

        await db.execute('''
          CREATE TABLE ${SavedWordsLocalStorageProvider.TABLE_NAME} (
            ${SavedWordsLocalStorageProvider.COLUMN_CONTENT} TEXT PRIMARY KEY
          )''');
        DatabaseLogger.create(tableName: SavedWordsLocalStorageProvider.TABLE_NAME);
      },
      version: VERSION
    );
  }
}


/// Extension of [TableHelper] to perform sql operations
/// on the table that handles usersaved words.
class SavedWordsLocalStorageProvider extends TableHelper {

  static const TABLE_NAME = "savedword";
  static const COLUMN_CONTENT = "content";

  SavedWordsLocalStorageProvider() : super(tableName: TABLE_NAME, handler: dbHandler);
  
  /// Insert a single [String] inside the table. 
  @override
  Future<int> insert(dynamic object) async {
    try {
      await super.insert(null); 
      int id = await db.insert(tableName, {COLUMN_CONTENT: object}, conflictAlgorithm: ConflictAlgorithm.ignore);
      DatabaseLogger.insert(success: true, tableName: TABLE_NAME, object: object);
      return id;
    }catch (err, stack) {
      DatabaseLogger.insert(success: false, tableName: TABLE_NAME, object: object, error: err, stacktrace: stack);
      return null;
    }
  }

  /// Insert a collection of [String] inside the table
  /// 
  /// A [Batch] is used to perform the multiple insertions and commit
  /// results at the end.
  @override
  Future<int> insertAll(Set<dynamic> list) async {
    try {
      await super.insertAll(null);
      Batch batch = db.batch();
      list.forEach( (s) =>
        batch.insert(tableName, {COLUMN_CONTENT: s}, conflictAlgorithm: ConflictAlgorithm.replace)
      );
      List result = await batch.commit(continueOnError: true);
      DatabaseLogger.insertAll(tableName: tableName, success: true, numberOfRows: result.length);
      return result.length;
    } catch(err, stack) {
      DatabaseLogger.insertAll(tableName: tableName, success: false, error: err, stacktrace: stack);
      return 0;
    }
  }

  /// Select all records from the table, it returns
  /// a [Set] of [String] (so all words inserted...)
  @override
  Future<Set<String>> all() async {
    try {
      await super.all();
      List<Map<String, dynamic>> queries = await db.query(tableName);
      Set<String> results = queries.map((Map<String, dynamic> row) => row[COLUMN_CONTENT] as String).toSet();
      DatabaseLogger.all(success: true, numberOfRecords: queries.length, tableName: tableName);
      return results;
    } catch(err, stack) {
      DatabaseLogger.all(success: false, tableName: tableName, error: err, stacktrace: stack);
      return {};
    } 
  }

  /// Delete the word [key] from the table
  @override
  Future delete(dynamic key) async {
    try {
      await super.delete(null);
      int status = await db.delete(
        tableName, 
        where: "$COLUMN_CONTENT = ?",
        whereArgs: [key]  
      );
      DatabaseLogger.delete(nbOfRowDeleted: status, object: key, tableName: tableName);
    } catch (err, stack) {
      DatabaseLogger.delete(unexpected: true, nbOfRowDeleted: 0, object: key, tableName: tableName, error: err, stacktrace: stack);
    }
  }
}


/// Extension of [TableHelper] to perform sql operations
/// on the table that handles [Exercise] progression.
class ExerciseLocalStorageProvider extends TableHelper {

  static const TABLE_EXERCISE = "exercise";
  static const TABLE_EXERCISE_ID_COLUMN = "id";
  static const TABLE_EXERCISE_CONTENT_COLUMN = "content";
  
  ExerciseLocalStorageProvider() : super(handler: dbHandler, tableName: TABLE_EXERCISE);

  /// Insert a single [Exercise] into the table
  @override
  Future<int> insert(dynamic exercise) async {
    try {
      await super.insert(null);
      String exerciseJson = jsonEncode(exercise.toJson());
      int id = await db.insert(TABLE_EXERCISE, {TABLE_EXERCISE_CONTENT_COLUMN: exerciseJson}, conflictAlgorithm: ConflictAlgorithm.replace);
      DatabaseLogger.insert(success: true, tableName: tableName, object: exercise);
      return id;
    } catch(err, stack) {
      DatabaseLogger.insert(success: true, tableName: tableName, object: exercise, error: err, stacktrace: stack);
      return null;
    }
  }

  /// Insert the collection [list] of [Exercise] into the table
  @override
  Future insertAll(Set<dynamic> list) async {
    await super.insertAll(null);
  }

  /// Return all records of the table.
  /// 
  /// As an exercise has to have an
  /// [ExerciseTheme] to be instantiated (and several exercises) CAN share
  /// the same theme, we cannot recreate a new theme for each records. So a 
  /// collection of [themes] is needed to perfom the selection. This collection
  /// is a [Map] with the [ExerciseTheme.name] as key and the theme as value.
  /// The [Map] returned by this function is a map with themes as keys and a list
  /// of exercises for each themes.
  Future<Map<ExerciseTheme, List<Exercise>>> all({@required Map<String, ExerciseTheme> themes}) async {
    try {
      await super.all();
      
      List<Map<String, dynamic>> progressions = await db.query(TABLE_EXERCISE, columns: [TABLE_EXERCISE_CONTENT_COLUMN]);
      Map<ExerciseTheme, List<Exercise>> exercises = {};
      if(progressions != null) {
        themes.values.forEach((ExerciseTheme theme) => exercises[theme] = []);

        for(Map<String, dynamic> row in progressions) {
          Map json = jsonDecode(row[TABLE_EXERCISE_CONTENT_COLUMN]);
          Exercise exercise = Exercise.fromJson(json);
          try {
            exercises[themes[exercise.theme.name]].add(exercise);
          } catch(e) {
            DatabaseLogger.log(message: "Unable to add exercise to ${exercise.theme.name}.");
          }
        }
      }
      DatabaseLogger.all(success: true, numberOfRecords: progressions.length, tableName: tableName);
      return exercises;
    } catch(err, stack) {
      DatabaseLogger.all(success: false, error: err, stacktrace: stack, tableName: tableName);
      return {};
    }
  }
}


/// Just a class to log operations perform (and so print
/// error, succes, warning, etc.) It has to be errorless, be 
/// aware of null objects if you want to modify this class.
class DatabaseLogger {
  static var logger = Logger(printer: MyPrinter("exercise_local_storage"));

  static create({@required String tableName}) {
    logger.i("Table $tableName created !");
  }

  static open({@required bool success, @required String tableName, error, stacktrace}) {
    if(success) {
      logger.i("Successful opened table : $tableName");
    } else {
      logger.e("Unable to open the table $tableName", error, stacktrace);
    }
  }

  static insert({@required bool success, error, stacktrace, @required String tableName, @required dynamic object}) {
    if(success) {
      logger.i("Succesful insertion or modification into $tableName : ${object?.toString()}");
    } else {
      logger.e("Unexpected error to insert ${object?.toString()} into $tableName", error, stacktrace);
    }
  }

  static insertAll({@required tableName, @required bool success, int numberOfRows, error, stacktrace}) {
    if(success) {
      logger.i("Succesful insertion or modification into $tableName : $numberOfRows inserted of modified");
    } else {
      logger.e("Unexpected error to insert collection into $tableName", error, stacktrace);
    }
  }

  static all({@required String tableName, @required bool success, int numberOfRecords, error, stacktrace}) {
    if(success) {
      logger.i("Successful select all into $tableName : ${numberOfRecords??"unknown"} records");
    } else {
      logger.e("Unable to select all records of $tableName table", error, stacktrace);
    }
  }

  static delete({@required String tableName, @required int nbOfRowDeleted, @required dynamic object, bool unexpected, error, stacktrace}) {
    if(unexpected == null || !unexpected) {
      if(nbOfRowDeleted == 1) {
        logger.i("Object '${object?.toString()}' has been delete from $tableName");
      } else {
        logger.w("Expected to have one row deleted. Here $nbOfRowDeleted row deleted. Maybe a bug.");
      }
    } else {
      logger.e("Error occured to delete '${object?.toString()}' into $tableName table", error, stacktrace);
    }
  }

  static wipe({@required bool success, int nbOfRowDeleted, @required String tableName, error, stacktrace}) {
    if(success) {
      logger.i("All records have been deleted from $tableName table : ${nbOfRowDeleted??"unknonwn"} deleted.");
    } else {
      logger.e("Error delete all from  $tableName table", error, stacktrace);
    }
  }

  static log({@required message}) {
    logger.i(message);
  }
}