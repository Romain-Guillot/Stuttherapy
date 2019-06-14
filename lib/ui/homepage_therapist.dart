import 'package:flutter/material.dart';
import 'package:stutterapy/manager.dart';

class HomePageTherapist extends StatelessWidget {

  final Manager manager;

  HomePageTherapist({Key key, @required this.manager}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Text("Therapist");
  }
}