import 'package:flutter/material.dart';


class MainAppBar extends AppBar {
  MainAppBar({
    Widget title,
  }) :
        super(
          title: title??Image.asset("assets/logo.png", width: 140,),
          // actions: !user.isLogged ? [LogIn()] : [AccountInfo(user: user)],
          centerTitle: true,
        );
}
