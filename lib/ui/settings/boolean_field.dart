import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/settings.dart';

class BooleanFieldWidget extends StatefulWidget {

  final BooleanField field;

  BooleanFieldWidget({Key key, @required this.field}) : super(key: key);

  @override
  _BooleanFieldWidgetState createState() => _BooleanFieldWidgetState();
}

class _BooleanFieldWidgetState extends State<BooleanFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.field.label),
      value: widget.field.value,
      onChanged: widget.field.disable ? null : (bool value) {
        setState(() {
          widget.field.value = value;
        });
      },
    );
    // return Checkbox(
    //   value: widget.field.value,
    //   onChanged: widget.field.disable ? null : (bool _newValue) {
    //     
    //   },
    // );
  }
}