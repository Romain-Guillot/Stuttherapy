import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:stuttherapy/account/feed.dart';
import 'package:stuttherapy/exercise_library/date.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';
import 'package:stuttherapy/providers/exercise_cloud_storage.dart';
import 'package:stuttherapy/providers/exercise_local_storage.dart';
import 'package:stuttherapy/providers/exercises_loader.dart';

class FeedProvider {

  static BehaviorSubject<Feed> feed = BehaviorSubject<Feed>();

  static initFeed(LoggedUser user, String uid, ) {
    //StreamSubscription subscr;
    /*subscr = */ExercisesLoader.themes.listen((List<ExerciseTheme> themes) async {
      Map<String, ExerciseTheme> themesMap = {};
      themes.forEach((ExerciseTheme t) => themesMap[t.name] = t);
      FirebaseCloudStorageProvider().all(user, themesMap).listen((List<Exercise> exercices) {
        final Feed f = Feed();
        f.addItems(exercices);
        f.addItems([
          Comment(date: MyDateTime(DateTime.now()), message: "Hello it's a message from Romain to announce you that there is a changment.")
        ]);
        feed.add(f);
        
      });
    });    
  }
}