import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/exercise_library/settings.dart';
import 'package:stutterapy/manager.dart';
import 'package:stutterapy/strings.dart';
import 'package:stutterapy/ui/components/secondary_appbar.dart';
import 'package:stutterapy/ui/dimen.dart';
import 'package:stutterapy/ui/exercise/exercise_instance.dart';
import 'package:stutterapy/ui/exercise_settings/settings_widget_provider.dart';


/// Widget to display the [theme] informations in order to
/// launch an exercise. 
/// This widget dislay the [theme.name] as content of the appbar.
/// For the body content, it display the [theme.longDescription] and
/// the [theme.settings] (Settings dislaying is handled by [ExerciseSettingsWidget])
class ExerciseHomepageWidget extends StatelessWidget {
  final Manager manager;

  /// the primary theme of the widget to display its informations
  /// and launch an exercise.
  final ExerciseTheme theme;


  ExerciseHomepageWidget({
    Key key, 
    @required this.manager, 
    @required this.theme
  }) : assert(manager != null, "manager cannot be null"),
       assert(theme != null, "theme cannot be null"),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        title: theme.name,
        context: context,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(Dimen.PADDING),
              children: <Widget>[
                Text(theme.longDescription),
                SizedBox(height: Dimen.PADDING,),
                Text(Strings.EXERCISE_SETTINGS, style: Theme.of(context).textTheme.headline,),
                ExerciseSettingsWidget(settings: theme.settings)
              ],
            ),
          ),
          Builder(
            builder: (BuildContext context) => RaisedButton(
              child: Text(Strings.EXERCISE_LAUNCH),
              onPressed: () {
                if(theme.settings.isValid()) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext ctx) => ExerciseInstanceWidget(exercise: Exercise(theme: theme),)
                  ));
                }else {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(Strings.ERROR_UNKNOWN),
                      duration: Duration(milliseconds: 3000),
                      behavior: SnackBarBehavior.floating,
                    )
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

/// Widget to give a graphical representation of
/// an [ExerciseSettings] instance ([settings]).
/// It basically display the [Widget] related to each
/// [ExerciseSettingsItem]. Widgets are chose thanks to
/// the [SettingsWidgetProvider.getWidget(ExerciseSettingsItem)].
class ExerciseSettingsWidget extends StatelessWidget {

  /// Primary [ExerciseSettings] to display its grahical representation
  final ExerciseSettings settings;

  ExerciseSettingsWidget({
    Key key, 
    @required this.settings
  }) : assert(settings != null, "settings property cannot be null"),
       super(key: key) ;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: settings.items.values.map((ExerciseSettingsItem _item) {
        return SettingsWidgetProvider.getWidget(_item) ?? Text(Strings.ERROR_UNKNOWN);
      }).toList(),
    );
  }
}