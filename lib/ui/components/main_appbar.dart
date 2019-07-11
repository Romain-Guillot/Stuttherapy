import 'package:flutter/material.dart';
import 'package:stuttherapy/account/accounts.dart';


class MainAppBar extends AppBar {
  MainAppBar({
    Widget title,
    @required User user,
  }) :  assert(user != null),
        super(
          title: title??Image.asset("assets/logo.png", width: 140,),
          // actions: !user.isLogged ? [LogIn()] : [AccountInfo(user: user)],
          centerTitle: true,
        );
}

// class LogIn extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       // child: Text("Log in".toUpperCase(), style: TextStyle(color: Theme.of(context).primaryColor),),
//       icon: Icon(Icons.account_circle, color: Colors.black,),
//       onPressed: () {
//         Navigator.push(context, MaterialPageRoute(
//           builder: (BuildContext ctx) => AccountLogIn()
//         ));
//       },
//     );
//   }
// }

// class AccountInfo extends StatelessWidget {

//   final User user;

//   AccountInfo({Key key, @required this.user}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       user.pseudo
//     );
//   }
// }