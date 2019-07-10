import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/providers/account_provider.dart';
import 'package:stutterapy/providers/exercise_local_storage.dart';

class SavedWordsProvider {
  static addSavedWord(Exercise exercise, Iterable<String> words) {
    words = words.map((String w) => w.toLowerCase());
    exercise.addSavedWords(words);
    Set<String> userSavedWords = AccountProvider.user.addSavedWords(words);
    SavedWordsLocalStorageProvider().insertAll(userSavedWords);
  }
}