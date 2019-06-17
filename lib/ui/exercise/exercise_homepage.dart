import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/exercise_library/settings.dart';
import 'package:stutterapy/manager.dart';
import 'package:stutterapy/strings.dart';
import 'package:stutterapy/ui/dimen.dart';
import 'package:stutterapy/ui/settings/settings_widget_provider.dart';

class ExerciseHomepageWidget extends StatelessWidget {
  final Manager manager;
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
      appBar: AppBar(
        title: Text(theme.name),
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
          RaisedButton(
            child: Text(Strings.EXERCISE_LAUNCH),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}


class ExerciseSettingsWidget extends StatelessWidget {
  final ExerciseSettings settings;

  ExerciseSettingsWidget({Key key, @required this.settings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: settings.items.values.map((ExerciseSettingsItem _item) {
        return SettingsWidgetProvider.getSettingsWidget(_item) ?? Text("Error...");
      }).toList(),
    );
  }
}