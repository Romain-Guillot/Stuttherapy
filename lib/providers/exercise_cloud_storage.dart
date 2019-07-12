
import 'dart:convert';

import 'package:rxdart/subjects.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';
import 'package:logger/logger.dart';
import 'package:stuttherapy/log_printer.dart';

abstract class BaseExerciseCloudStorage {

  uploadExercise(Exercise exercise, LoggedUser user);
  deleteExercise(Exercise exercise, LoggedUser user);
}


class FirebaseCloudStorageProvider implements BaseExerciseCloudStorage { 

  final logger = Logger(printer: MyPrinter("exercise_cloud_storage.dart"));

  static String usersCollection = "users";
  static String exercisesCollection = "exercises";
  static const int CURRENT_EXERCISE_SERIALIZATION_VERSION = 1;

  uploadExercise(Exercise exercise, LoggedUser user) async {
    if(isLogged(user)) {
      try {
        String userUid = user.uid;
        await Firestore.instance
          .collection(usersCollection)
          .document(userUid)
          .collection(exercisesCollection)
          .document(exercise.key.toString())
          .setData(toDocument_1(exercise));
        logger.i("Document added : ${exercise.key}");
      } catch(err, stack) {
        logger.e("Unable to add document into Firestore database.", err, stack);
      }
    } else {
      logger.e("Invalid user to add the document");
      throw ExerciseCloudStorageException("Invalid user to add the exercise");
    }
  }

  deleteExercise(Exercise exercise, LoggedUser user) async {
    if(isLogged(user)) {
       String userUID = user.uid;
       await Firestore.instance
        .collection(usersCollection)
        .document(userUID)
        .collection(exercisesCollection)
        .document(exercise.key.toString())
        .delete();
    } else {
      throw ExerciseCloudStorageException("Invalid user to delete the exercise");
    }
  }

  BehaviorSubject<bool> isSync(Exercise exercise, LoggedUser user) {
    BehaviorSubject<bool> isSyncStream = new BehaviorSubject<bool>();
    if(isLogged(user)) {
      Firestore.instance
      .collection(usersCollection)
      .document(user.user.uid)
      .collection(exercisesCollection)
      .document(exercise.key.toString())
      .snapshots().listen((DocumentSnapshot doc) => isSyncStream.add(doc.exists));
    } else {
      isSyncStream.addError(null);
    }
    return isSyncStream;
  }

  Map<String, dynamic> toDocument_1(Exercise exercise) {
    return {
      "version": CURRENT_EXERCISE_SERIALIZATION_VERSION,
      "date": exercise.date.date.microsecondsSinceEpoch,
      "theme_name": exercise.theme.name,
      "serialized": jsonEncode(exercise.toJson()),
    };
  }

  Exercise fromDocument_1(DocumentSnapshot document ) {
    return Exercise.fromJson(document["serialized"]);
  }

  bool isLogged(LoggedUser user) => user != null && user.uid != null;
}





class ExerciseCloudStorageException implements Exception {
  final String message;
  ExerciseCloudStorageException(this.message);
  @override String toString() => message;
}