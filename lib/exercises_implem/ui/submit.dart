import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stutterapy/exercise_library/exercise_ressources.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/exercises_implem/ui/exercice_widget.dart';
import 'package:stutterapy/providers/saved_word_provider.dart';

class SubmitWidget extends StatefulWidget implements ExerciseWidget {

  final Exercise exercise;
  final ExerciseResourceEnum resourceTye;
  final bool manuallyCheck;


  SubmitWidget({
    Key key, 
    @required this.exercise
  }) :  manuallyCheck = exercise.theme.settings[ExerciseTheme.SETTINGS_MANUALLY_CHECK],
        resourceTye = exercise.theme.settings[ExerciseTheme.SETTINGS_RESOURCE],
        super(key: key);

  @override
  _SubmitWidgetState createState() => _SubmitWidgetState();
}

class _SubmitWidgetState extends State<SubmitWidget> {
  bool isChecking = false;
  final double _iconSize = 40.0;
  Map<String, bool> checkedWords = {};

  @override
  void initState() {
    super.initState();
    widget.exercise.currentResource.stream.listen((ExerciseResource res) {
      checkedWords = {};
      for(String word in res.getWords()) {
        checkedWords[word] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: 
        (!widget.manuallyCheck)
        ? nextWithoutChecking
        : ratingWidget
    );
  }

  Widget get ratingWidget {
    if(!isChecking) {
      return binaryRate;
    } else {
      return resourceCheckingWidget;
    }
  }

  Widget get resourceCheckingWidget {
    return Column(
      children: <Widget>[
        StreamBuilder<ExerciseResource>(
          stream: widget.exercise.currentResource.stream,
          builder: (BuildContext context, AsyncSnapshot<ExerciseResource> snapshotResource) {
            if(!snapshotResource.hasData)
              return Text("loading...");
            return Wrap(
              children: snapshotResource.data.getWords().map((String word) =>
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                    child: Text(
                      word + " ", 
                      style: TextStyle(
                        fontSize: 18, 
                        color: checkedWords[word] != null && checkedWords[word] ? Colors.red : Colors.grey,
                        fontWeight: checkedWords[word] != null && checkedWords[word] ? FontWeight.bold : FontWeight.normal
                      ),
                    ),      
                  ),
                  onTap: () {
                    setState(
                      () => checkedWords[word] = !checkedWords[word]
                    );
                  },
                )
              ).toList(),
            );
          }
        ),
        FlatButton.icon(
          icon: Icon(Icons.done_all, size: _iconSize,),
          label: Text("Done !"),
          onPressed: () {
            setState(() {
              isChecking = false;
              addCheckedWordsToExercise();
              widget.exercise.moveNextResource();
            });
          } 
        )
      ],
    );
  }

  Widget get nextWithoutChecking {
    return IconButton(
      icon: Icon(Icons.navigate_next, color: Colors.blue,),
      iconSize: _iconSize,
      onPressed: () {
        widget.exercise.moveNextResource();
      },
    );
  }

  Widget get binaryRate {
    return Wrap(
        spacing: 15,
        children: [
          IconButton(
            icon: Icon(Icons.thumb_up, color: Colors.green), 
            iconSize: _iconSize,
            onPressed: () {
              widget.exercise.moveNextResource();
            },),
          IconButton(
            icon: Icon(Icons.thumb_down, color: Colors.red),
            iconSize: _iconSize,
            onPressed: () {
              if(widget.resourceTye != ExerciseResourceEnum.WORDS) {
                setState(() => isChecking = true);
              }else {
                checkedWords.updateAll((String _, bool checked) => checked = true); // We checked to true the only words of checkedWords
                addCheckedWordsToExercise();
                widget.exercise.moveNextResource();
              }
            }, 
          )
        ]
      );
  }

  addCheckedWordsToExercise() {
    checkedWords.removeWhere((String _, bool checked) => !checked);
    SavedWordsProvider.addSavedWord(widget.exercise, checkedWords.keys);
  }
}