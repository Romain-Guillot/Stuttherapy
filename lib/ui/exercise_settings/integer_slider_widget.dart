import 'package:flutter/material.dart';
import 'package:stuttherapy/exercise_library/settings.dart';
import 'package:stuttherapy/ui/exercise_settings/settings_item_widget.dart';


class IntegerSliderWidget extends SettingsItemWidget {

  IntegerSliderWidget({Key key, IntegerSliderField field}) : super(key: key, field: field);

  @override
  _IntegerSliderWidgetState createState() => _IntegerSliderWidgetState();
}


class _IntegerSliderWidgetState extends State<IntegerSliderWidget> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.field.value.toString());
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.field.label + " :", style: TextStyle(fontStyle: FontStyle.italic),),
      subtitle: Row(
        children: <Widget>[
          Expanded(
            child: Slider(
              value: (widget.field.value as int).toDouble(),
              min: (widget.field as IntegerSliderField).min.toDouble(),
              max: (widget.field as IntegerSliderField).max.toDouble(),      
              onChanged: widget.field.disable ? null : (double value) {
                setState(() {
                  widget.field.value = value.toInt();
                  _controller.text = widget.field.value.toString();
                });
              },
            ),
          ),
          SizedBox(
            width: 30,
            child: TextField(
              textAlign: TextAlign.center,
              controller: _controller,
              decoration: InputDecoration(border: InputBorder.none),
              keyboardType: TextInputType.number,
              onSubmitted: (String value) {
                int _value = widget.field.value;
                try {
                  _value = int.parse(value);
                  if(_value < (widget.field as IntegerSliderField).min)
                    _value = (widget.field as IntegerSliderField).min;
                  if(_value > (widget.field as IntegerSliderField).max)
                    _value = (widget.field as IntegerSliderField).max;
                }catch(e) {
                }finally {
                  setState(() {
                    widget.field.value = int.parse(_value.toString());
                    _controller.text = widget.field.value.toString();
                  });                
                }
              },
              // widget.field.value.toString(), textAlign: TextAlign.center,
            ),
          )
          
        ],
      ),
    );
  }
}