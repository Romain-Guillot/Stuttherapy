
import 'package:rxdart/subjects.dart';
import 'package:stuttherapy/account/feed.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';
import 'package:stuttherapy/providers/exercise_cloud_storage.dart';
import 'package:stuttherapy/providers/exercises_loader.dart';

class FeedProvider {


  static BehaviorSubject<Feed> getUserFeed(LoggedUser user, String userUid) {
    BehaviorSubject<Feed> feed = BehaviorSubject<Feed>();
    
    //StreamSubscription subscr;
    /*subscr = */ExercisesLoader.themes.listen((List<ExerciseTheme> themes) async {
      Map<String, ExerciseTheme> themesMap = {};
      themes.forEach((ExerciseTheme t) => themesMap[t.name] = t);
      FirebaseCloudStorageProvider().all(user, themesMap, exercisesUserUID: userUid).listen((List<Exercise> exercices) {
        final Feed f = Feed();
        f.addItems(exercices);
        feed.add(f);
      });
    });   
    return feed; 
  }
}