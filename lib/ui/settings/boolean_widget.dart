import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/settings.dart';
import 'package:stutterapy/ui/settings/settings_item_widget.dart';

class BooleanFieldWidget extends SettingsItemWidget {


  BooleanFieldWidget({Key key, BooleanField field}) : super(key: key, field: field);

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
  }
}