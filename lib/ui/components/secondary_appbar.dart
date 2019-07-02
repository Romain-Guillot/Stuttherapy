import 'package:flutter/material.dart';

class SecondaryAppBar extends AppBar {
  SecondaryAppBar({
    @required String title,
    @required BuildContext context,
    String subtitle,
    List<Widget> actions,
  }) : super(
    title: RichText(
      text: TextSpan(
        text: title + (subtitle == null ? "" : "\n"), 
        style: Theme.of(context).appBarTheme.textTheme.title,
        children: subtitle != null ? [TextSpan(text: subtitle, style: Theme.of(context).appBarTheme.textTheme.subtitle)] : []
      ),
    ),
    actions: actions
  );
}