import 'package:flutter/material.dart';
import 'package:stuttherapy/exercise_library/settings.dart';
import 'package:stuttherapy/ui/exercise_settings/settings_item_widget.dart';


class ComboBoxWidget extends SettingsItemWidget {

  ComboBoxWidget({Key key, ComboBoxField field}) : super(key: key, field: field);

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
        disabledHint: Text((widget.field as ComboBoxField).toStringItem == null ? widget.field.value.toString() : (widget.field as ComboBoxField).toStringItem.getString(widget.field.value)),
        items: widget.field.disable ? null : (widget.field as ComboBoxField).items.map((Object item) => DropdownMenuItem(
          child: Text((widget.field as ComboBoxField).toStringItem == null ? item.toString() : (widget.field as ComboBoxField).toStringItem.getString(item)),
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