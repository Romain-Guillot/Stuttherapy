
import 'package:flutter/material.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/strings.dart';
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
        subtitle: Strings.PROGRESS_TITLE,
        context: context,
      ),
      body: StreamBuilder(
        stream: AccountProvider.user.progression,
        builder: (BuildContext context, AsyncSnapshot<Map<ExerciseTheme, Map<int, Exercise>>> progressionsSnap) {
          if(!progressionsSnap.hasData || progressionsSnap.data[theme] == null || progressionsSnap.data[theme].length == 0) {
            return ListTile(
              title: Text(Strings.PROGRESS_NO_PROGRESS, style: TextStyle(fontStyle: FontStyle.italic),),
            );
          }else {
            final List<Exercise> progressions = progressionsSnap.data[theme].values.toList();
            progressions.sort();
            return ListView.builder(
              itemCount: progressions.length,
              itemBuilder: (BuildContext ctx, int position) 
                => ExerciseProgressionListItem(exercise: progressions.elementAt(position)),
            );
          }
        },
      )
    );
  }
}

class ExerciseProgressionListItem extends StatelessWidget {
  final Exercise exercise;

  ExerciseProgressionListItem({Key key, @required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(exercise.theme.name),
      subtitle: Text(exercise.date.toString()),
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (context) => ExerciseProgressionItemWidget(exercise: exercise,)
      )),
    );
  }
}