import 'package:flutter/material.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/ui/components/secondary_appbar.dart';
import 'package:stuttherapy/ui/exercise/exercise_progression_item.dart';

class ExerciseProgressionWidget extends StatelessWidget {

  final ExerciseTheme theme;

  ExerciseProgressionWidget({Key key, @required this.theme}) : assert(theme != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        title: theme.name,
        subtitle: "Progressions",
        context: context,
      ),
      body: StreamBuilder(
        stream: AccountProvider.user.progression,
        builder: (BuildContext context, AsyncSnapshot<Map<ExerciseTheme, List<Exercise>>> progressionsSnap) {
          if(!progressionsSnap.hasData || progressionsSnap.data[theme] == null || progressionsSnap.data[theme].length == 0) {
            return ListTile(
              title: Text("No progression available ...", style: TextStyle(fontStyle: FontStyle.italic),),
            );
          }else {
            final List<Exercise> progressions = progressionsSnap.data[theme];
            progressions.sort();
            return ListView.builder(
              itemCount: progressions.length,
              itemBuilder: (BuildContext ctx, int position) 
                => _ExerciseProgressionListItem(exercise: progressions.elementAt(position),),
            );
          }
        },
      )
    );
  }
}

class _ExerciseProgressionListItem extends StatelessWidget {
  final Exercise exercise;

  _ExerciseProgressionListItem({Key key, @required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(exercise.theme.name),
      subtitle: Text(exercise.date.toString()),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext ctx) => ExerciseProgressionItemWidget(exercise: exercise,)
        ));
      },
    );
  }
}