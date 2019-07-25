import 'package:flutter/material.dart';
import 'package:stuttherapy/account/accounts.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/providers/exercises_loader.dart';
import 'package:stuttherapy/strings.dart';
import 'package:stuttherapy/ui/dimen.dart';
import 'package:stuttherapy/ui/exercise/exercise_progression.dart';
import 'package:stuttherapy/ui/exercise/exercise_homepage.dart';


///
///
///
class ExercisesListView extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimen.PADDING),
      child: StreamBuilder<List<ExerciseTheme>>(
        stream: ExercisesLoader.themes,
        builder: (BuildContext ctx, AsyncSnapshot<List<ExerciseTheme>> snapshotThemes) {
          if(snapshotThemes.data == null) {
            return Text(Strings.LOADING);
          }else {
            return Column(
              children: snapshotThemes.data.map(
                (ExerciseTheme _theme)  => ExerciseListItem(theme: _theme)
              ).toList(),
            );
          }
        },
      ),
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
                  child: Text(Strings.PROGRESS_TITLE.toUpperCase()),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext ctx) => ExerciseProgressionWidget(theme: theme,)
                    ));
                  },
                ),
                RaisedButton(
                  child: Text(Strings.EXERCISE_TRAIN.toUpperCase()),
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