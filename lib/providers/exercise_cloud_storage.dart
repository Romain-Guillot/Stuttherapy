
import 'dart:convert';

import 'package:rxdart/subjects.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';
import 'package:logger/logger.dart';
import 'package:stuttherapy/log_printer.dart';

abstract class BaseExerciseCloudStorage {
  uploadExercise(LoggedUser user, Exercise exercise);
  deleteExercise(LoggedUser user, Exercise exercise);
  all(LoggedUser user, Map<String, ExerciseTheme> themes);
  isSync(LoggedUser user, Exercise exercise);
}


class FirebaseCloudStorageProvider implements BaseExerciseCloudStorage { 

  final logger = Logger(printer: MyPrinter("exercise_cloud_storage.dart"));

  static String usersCollection = "users";
  static String exercisesCollection = "exercises";
  static const int CURRENT_EXERCISE_SERIALIZATION_VERSION = 1;


  uploadExercise(LoggedUser user, Exercise exercise) async {
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
        throw ExerciseCloudStorageException("Unable to sync exercise");
      }
    } else {
      logger.e("Invalid user to add the document");
      throw ExerciseCloudStorageException("Invalid user to add the exercise");
    }
  }

  deleteExercise(LoggedUser user, Exercise exercise) async {
    if(isLogged(user)) {
      try {
       String userUID = user.uid;
       await Firestore.instance
        .collection(usersCollection)
        .document(userUID)
        .collection(exercisesCollection)
        .document(exercise.key.toString())
        .delete();
      } catch(err, stack) {
        logger.e("Unable to delete exercise ${exercise?.key}", err, stack);
        throw ExerciseCloudStorageException("Unable to delete exercise");
      }
    } else {
      throw ExerciseCloudStorageException("Invalid user to delete the exercise");
    }
  }

  BehaviorSubject<List<Exercise>> all(LoggedUser user, Map<String, ExerciseTheme> themes, {String exercisesUserUID}) {
    BehaviorSubject<List<Exercise>> exercises = BehaviorSubject<List<Exercise>>();
    if(isLogged(user)) {
      String userUID = exercisesUserUID??user.uid;
      Stream<QuerySnapshot> exerciseDocumentStream = Firestore.instance
        .collection(usersCollection)
        .document(userUID)
        .collection(exercisesCollection).snapshots();
      
      exerciseDocumentStream.listen((QuerySnapshot snap) {
        exercises.add(
          snap.documents.map((DocumentSnapshot doc) => fromDocument_1(doc, themes)).toList()
        );
      });
    } else{
      logger.e("Invalid user to get all exercise");
      exercises.addError(null);
    }
    return exercises;
  }

  BehaviorSubject<bool> isSync(LoggedUser user, Exercise exercise) {
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

  Exercise fromDocument_1(DocumentSnapshot document, Map<String, ExerciseTheme> themes) {
    try {
      Exercise ex = Exercise.fromJson(jsonDecode(document.data["serialized"]));
      ex.theme = themes[ex.theme.name];
      return ex;
    } catch(err, stack) {
      logger.e("Unable to create Exercise instance from document ${document?.data}", err, stack);
      throw ExerciseCloudStorageException("Unbale to dezerialize exercise");
    }
  }

  bool isLogged(LoggedUser user) => user != null && user.uid != null;
}





class ExerciseCloudStorageException implements Exception {
  final String message;
  ExerciseCloudStorageException(this.message);
  @override String toString() => message;
}