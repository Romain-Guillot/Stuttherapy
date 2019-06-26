import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:stutterapy/account/accounts.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/providers/account_provider.dart';
import 'package:stutterapy/providers/exercises_loader.dart';
import 'package:stutterapy/ui/exercise/exercise_progression.dart';
import 'package:stutterapy/ui/exercise/exercise_homepage.dart';


///
///
///
class ExercisesListView extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UnmodifiableListView<ExerciseTheme>>(
      stream: ExercisesLoader.themes,
      builder: (BuildContext ctx, AsyncSnapshot<UnmodifiableListView<ExerciseTheme>> snapshotThemes) {
        if(snapshotThemes.data == null) {
          return Text("Loading data...");
        }else {
          return Column(
            children: snapshotThemes.data.map(
              (ExerciseTheme _theme)  => ExerciseListItem(theme: _theme)
            ).toList(),
          );
        }
      },
    );
  }
}

///
///
///
class ExerciseListItem extends StatelessWidget {

  final ExerciseTheme theme;
  final User user;

  ExerciseListItem({Key key, @required this.theme}) : user = AccountProvider.user, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(theme.name),
            subtitle: Text(theme.shortDescription, maxLines: 1, overflow: TextOverflow.ellipsis,),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text("Progression".toUpperCase()),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext ctx) => ExerciseProgressionWidget()
                    ));
                  },
                ),
                RaisedButton(
                  child: Text("Train".toUpperCase()),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext ctx) => ExerciseHomepageWidget(theme: theme)
                    ));
                  },
                ),
              ],
            )
          )
        ],
      ),
    );
  }
}