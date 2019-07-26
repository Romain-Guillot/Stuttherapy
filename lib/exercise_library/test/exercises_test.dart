import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/exercise_library/settings.dart';
import 'package:test/test.dart';

void main() {
  group("tests for [ExerciseTheme] class", () {
    test("exercice theme initialization", () {
      var theme = ExerciseTheme(name: "test", shortDescription: "short", longDescription: "long");
      expect(theme.name, equals("test"));
      expect(theme.shortDescription, equals("short"));
      expect(theme.longDescription, "long");
      expect(theme.settings, isNotNull);
      expect(theme.settings.get(ExerciseTheme.SETTINGS_MANUALLY_CHECK), isNotNull);
      expect(theme.settings.get(ExerciseTheme.SETTINGS_PERCEPTION), isNotNull);
      expect(theme.settings.get(ExerciseTheme.SETTINGS_RECORD), isNotNull);
      expect(theme.settings.get(ExerciseTheme.SETTINGS_RESOURCE), isNotNull);
      
      var themeBis = ExerciseTheme(name: "test", shortDescription: "short", longDescription: "long", exercisesSettings: {"test_set": BooleanField(label: "ok")});
      expect(themeBis.settings, isNotNull);
      expect(themeBis.settings.get("test_set"), isNotNull);
      expect(themeBis.settings.get("test_set"), TypeMatcher<BooleanField>());

    });
  });

  group("tests for [Exercise] class", () {
    test("exercise initialization", () {

    });

    test("exercise resource", () {
      
    });
  });
  
}