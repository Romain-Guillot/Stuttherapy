
import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/exercises_implem/exercise_structure_provider.dart';
import 'package:stutterapy/providers/account_provider.dart';
import 'package:stutterapy/ui/components/secondary_appbar.dart';
import 'package:stutterapy/ui/exercise/exercise_progression_item.dart';

class ExerciseInstanceWidget extends StatefulWidget {
  
  final Exercise exercise;

  ExerciseInstanceWidget({Key key, @required this.exercise}) : super(key: key);

  @override
  _ExerciseInstanceWidgetState createState() => _ExerciseInstanceWidgetState();
}


/// Stateful to listen stream and push page ... Need the context to push page and
/// dirty to put this in the Stateless build methhod
class _ExerciseInstanceWidgetState extends State<ExerciseInstanceWidget> {

  @override
  void initState() {
    super.initState();
    widget.exercise.flagEndOfExercise.stream.listen((bool data) {
      if(data) {
        AccountProvider.user.addProgression(widget.exercise);
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (ctx) => ExerciseProgressionItemWidget(exercise: widget.exercise)
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: SecondaryAppBar(
        title: widget.exercise.theme.name, 
        subtitle: "Exercise", 
        context: context,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.check, color: Colors.green), 
            label: Text("Finish".toUpperCase(), 
            style: TextStyle(color: Colors.green),), 
            onPressed: () => widget.exercise.stop(),
          )
        ],
      ),
      body: 
        (widget.exercise.theme.exerciseStructure.keys.length > 0)
        ? ListView.builder(
            itemCount: widget.exercise.theme.exerciseStructure.length,
            itemBuilder : (ctx, position) {
              int widgetID = widget.exercise.theme.exerciseStructure.keys.elementAt(position);
              return Padding(
                      padding: const EdgeInsets.all(20),
                      child: ExerciseStructureProvider.getWidget(widgetID, widget.exercise),
                    ); 
            }
          )
        : Text("Nothing to display ..."),
    );
  }
}