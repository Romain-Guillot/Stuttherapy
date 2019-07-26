import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stuttherapy/exercise_library/exercise_ressources.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/exercises_implem/ui/exercice_widget.dart';
import 'package:stuttherapy/providers/account_provider.dart';


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
      res.getWords().forEach((String word) => checkedWords[word] = false);
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
              moveNext();
            });
          } 
        )
      ],
    );
  }

  Widget get nextWithoutChecking {
    return FlatButton.icon(
      icon: Icon(Icons.navigate_next, color: Colors.blue, size: _iconSize,),
      label: Text("Next resource"),
      onPressed: () {
        widget.exercise.moveNextResource();
      },
    );
  }

  Widget get binaryRate {
    return Column(
      children: <Widget>[
        Text("Check if your pronunciation was correct :", style: TextStyle(fontStyle: FontStyle.italic),),
        Wrap(
            spacing: 15,
            children: [
              FlatButton.icon(
                color: Colors.green,
                icon: Icon(Icons.thumb_up, size: 25,), 
                label: Text("Yes"),
                onPressed: () {
                  moveNext();
                },),
              FlatButton.icon(
                color: Colors.red,
                icon: Icon(Icons.thumb_down, size: 25,),
                label: Text("No"),
                onPressed: () {
                  if(widget.resourceTye != ExerciseResourceEnum.WORDS) {
                    setState(() => isChecking = true);
                  }else {
                    checkedWords.updateAll((String _, bool checked) => checked = true); // We checked to true the only words of checkedWords
                    moveNext();
                  }
                }, 
              )
            ]
          ),
      ],
    );
  }

  moveNext() {
    int total = checkedWords.keys.length;
    checkedWords.removeWhere((_, bool checked) => !checked);
    Iterable<String> words = checkedWords.keys;
    widget.exercise.addSavedWords(words, total);
    AccountProvider.addSavedWords(words);
    widget.exercise.moveNextResource();
  }
}