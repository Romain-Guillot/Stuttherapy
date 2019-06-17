import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/exercise_ressources.dart';
import 'package:stutterapy/exercise_library/settings.dart';

class ComboBoxWidget extends StatefulWidget {

  final ComboBoxField field;

  ComboBoxWidget({Key key, @required this.field}) : super(key: key);

  @override
  _ComboBoxWidgetState createState() => _ComboBoxWidgetState();
}

class _ComboBoxWidgetState extends State<ComboBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: !widget.field.disable,
      title: Text(widget.field.label),
      trailing: DropdownButton(
        isExpanded: false,
        value: widget.field.value ,
        disabledHint: Text(widget.field.toStringItem == null ? widget.field.value.toString() : widget.field.toStringItem(widget.field.value)),
        items: widget.field.disable ? null : widget.field.items.map((Object item) => DropdownMenuItem(
          child: Text(widget.field.toStringItem == null ? item.toString() : widget.field.toStringItem(item)),
          value: item,
        )).toList(),
        onChanged: widget.field.disable ? null : (selectedValue) {
          setState(() {
            widget.field.value = selectedValue;
          });
        },
      ),
    );
  }
}