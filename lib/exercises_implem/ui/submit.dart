import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SubmitWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 15,
        children: [
          IconButton(icon: Icon(Icons.thumb_up, color: Colors.green), onPressed: () {}, iconSize: 40,),
          IconButton(icon: Icon(Icons.thumb_down, color: Colors.red), onPressed: () {}, iconSize: 40,)
        ]
      ),
    );
  }
}