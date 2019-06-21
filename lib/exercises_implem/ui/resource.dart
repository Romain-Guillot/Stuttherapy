import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/exercise_ressources.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/exercise_library/settings.dart';

class ResourceWidget extends StatelessWidget {

  final Exercise exercise;
  final ResourcePerception perceptionWay;
  // final ExerciseResourceEnum resourceType;
  // final StreamController<ExerciseResource> _resource = StreamController<ExerciseResource>();

  ResourceWidget({
    Key key,
    @required this.exercise
  }) :  assert(exercise.theme.settings[ExerciseTheme.SETTINGS_PERCEPTION] != null && exercise.theme.settings[ExerciseTheme.SETTINGS_PERCEPTION] != null),
        assert(exercise.theme.settings[ExerciseTheme.SETTINGS_RESOURCE] != null && exercise.theme.settings[ExerciseTheme.SETTINGS_RESOURCE] != null),
        perceptionWay = exercise.theme.settings[ExerciseTheme.SETTINGS_PERCEPTION],
        // resourceType = settings.items[ExerciseTheme.SETTINGS_RESOURCE].value,
        super(key: key);

  // Future<void> _loadResource() async {
  //   await Future.delayed(Duration(seconds: 2));
  //   ExerciseResource _res = ResourceProvider.getResource(resourceType);
  //   if(_res != null) {
  //     _resource.add(_res);
  //   }else {
  //     _resource.addError(null);
  //   }
  // }

  void sleep(Duration duration) {
    var ms = duration.inMilliseconds;
    var start = new DateTime.now().millisecondsSinceEpoch;
    while (true) {
      var current = new DateTime.now().millisecondsSinceEpoch;
      if (current - start >= ms) {
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.grey[300],
      child: StreamBuilder<ExerciseResource>(
        stream: exercise.currentResource.stream,
        builder: (BuildContext context, AsyncSnapshot<ExerciseResource> snapshot) {
          if(snapshot.hasError) {
            return Text("Error while loading the resource.");
          }
          if(!snapshot.hasData) {
            return Text("Loading resource ...");
          }
          return Text(snapshot.data.resource);
        }
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

