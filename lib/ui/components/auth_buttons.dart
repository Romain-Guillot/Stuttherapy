import 'package:flutter/material.dart';
import 'package:stuttherapy/ui/account/account_log_in.dart';

class AuthButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RaisedButton(
          child:Text("Sign-in"), 
          onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) => AccountLogIn(initialFormMode: FormMode.SIGNIN,)))
        ),
        FlatButton(
          child:Text("Sign-up"),
          textColor: Theme.of(context).primaryColor, 
          onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) => AccountLogIn(initialFormMode: FormMode.SIGNUP,)))
        ),
      ],
      
    );
  }
}