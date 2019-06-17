import 'package:flutter/material.dart';
import 'package:stutterapy/exercise_library/settings.dart';

class IntegerSliderWidget extends StatefulWidget {

  final IntegerSliderField field;

  IntegerSliderWidget({Key key, @required this.field}) : super(key: key);

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
              min: widget.field.min.toDouble(),
              max: widget.field.max.toDouble(),      
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
              controller: _controller,
              keyboardType: TextInputType.number,
              onSubmitted: (String value) {
                int _value = widget.field.value;
                try {
                  _value = int.parse(value);
                  if(_value < widget.field.min)
                    _value = widget.field.min;
                  if(_value > widget.field.max)
                    _value = widget.field.max;
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