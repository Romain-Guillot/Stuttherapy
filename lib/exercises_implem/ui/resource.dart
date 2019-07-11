import 'package:flutter/material.dart';
import 'package:stuttherapy/exercise_library/exercise_ressources.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/exercises_implem/ui/exercice_widget.dart';

class ResourceWidget extends StatefulWidget implements ExerciseWidget {

  final Exercise exercise;

  ResourceWidget({
    Key key,
    @required this.exercise
  }) :  assert(exercise.theme.settings[ExerciseTheme.SETTINGS_PERCEPTION] != null),
        assert(exercise.theme.settings[ExerciseTheme.SETTINGS_RESOURCE] != null),
        super(key: key);

  @override
  _ResourceWidgetState createState() => _ResourceWidgetState(isCover: coverEnable);

  bool get coverEnable => exercise.theme.settings[ExerciseTheme.SETTINGS_PERCEPTION] == ResourcePerception.TEXT_COVER;


}

class _ResourceWidgetState extends State<ResourceWidget> {
  bool isCover;

  _ResourceWidgetState({@required this.isCover});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: !widget.coverEnable ? null : () {
        setState(() => isCover = true);
      },
      onTapCancel: !widget.coverEnable ? null : () {
        setState(() => isCover = true);
      },
      onTapDown: !widget.coverEnable ? null : (_) {
        setState(() => isCover = false);
      },
      enableFeedback: false,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      
      child: Container(
        padding: EdgeInsets.all(20),
        color: Colors.grey[300],
        child: StreamBuilder<ExerciseResource>(
          stream: widget.exercise.currentResource.stream,
          builder: (BuildContext context, AsyncSnapshot<ExerciseResource> snapshot) {
            if(snapshot.hasError) {
              return Text("Error while loading the resource.");
            }
            if(!snapshot.hasData) {
              return Text("Loading resource ...");
            }
            return Text(snapshot.data.resource, style: TextStyle(color: isCover ? Colors.transparent : Colors.black),);
          }
        ),
      ),
    );
  }

  Widget getResourceWidget(ExerciseResource res) {
    switch (res.resourceType) {
      case ExerciseResourceEnum.SENTENCES:
        return Text("Sentences resources");
      case ExerciseResourceEnum.WORDS:
        return Text("Words resource");
      case ExerciseResourceEnum.TEXT:
        return Text("Text resource");
      default:
        return Text("Unsupported resource ...");
    }
  }
}

