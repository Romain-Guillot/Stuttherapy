import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:stutterapy/account/accounts.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/manager.dart';
import 'package:stutterapy/strings.dart';
import 'package:stutterapy/ui/components/drawer_menu.dart';
import 'package:stutterapy/ui/components/main_appbar.dart';


///
///
///
class HomePageStutter extends StatelessWidget {

  final Manager manager;

  HomePageStutter({Key key, @required this.manager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: Text(Strings.appName),
        user: manager.user,
      ),
      drawer: DrawerMenu(

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Exercises", style: Theme.of(context).textTheme.title,),
          ExercisesListView(manager: manager,)
        ],
      )
      
    );
  }
}


///
///
///
class ExercisesListView extends StatelessWidget {

  final Manager manager;

  ExercisesListView({Key key, @required this.manager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UnmodifiableListView<ExerciseTheme>>(
      stream: manager.themes,
      builder: (BuildContext ctx, AsyncSnapshot<UnmodifiableListView<ExerciseTheme>> snapshotThemes) {
        if(snapshotThemes.data == null) {
          return Text("Loading data...");
        }else {
          print(snapshotThemes.data.length);
          return Expanded(
              child: ListView(
              children: snapshotThemes.data.map(
                (ExerciseTheme _theme)  => ExerciseListItem(theme: _theme, user: manager.user,)
              ).toList(),
            ),
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

  ExerciseListItem({Key key, @required this.theme, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(theme.name),
            subtitle: Text(theme.shortDescription),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text("Train".toUpperCase()),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext ctx) => Text("TODO TRAIN CARD ITEMM")
                    ));
                  },
                ),
                FlatButton(
                  child: Text("Progression".toUpperCase()),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext ctx) => Text("TODO PROGRESSION CARD ITEMM")
                    ));
                  },
                )
              ],
            )
          )
        ],
      ),
    );
  }
}