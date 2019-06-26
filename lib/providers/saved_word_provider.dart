import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/providers/account_provider.dart';

class SavedWordsProvider {
  static addSavedWord(Exercise exercise, Iterable<String> words) {
    exercise.addSavedWord(words);
    AccountProvider.user.addSavedWords(words);
  }
}