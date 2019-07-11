import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';
import 'package:stuttherapy/ui/components/secondary_appbar.dart';
import 'package:stuttherapy/ui/dimen.dart';

enum FormMode { SIGNIN , SINGUP }

class AccountLogIn extends StatefulWidget {

  final FormMode initialFormMode;

  AccountLogIn({Key key, @required this.initialFormMode}) : super(key: key);

  @override
  _AccountLogInState createState() => _AccountLogInState(initialFormMode);
}

class _AccountLogInState extends State<AccountLogIn> {

  FormMode mode;

  _AccountLogInState(this.mode);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        context: context,
        title: isSignIn ? "Sign in" : "Sign up"
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          padding: EdgeInsets.all(Dimen.PADDING),
          child: Center(
            child: Column(
                children: <Widget>[
                  isSignIn ? LogInForm() : SignUpFom(),                  
                  SizedBox(height: Dimen.PADDING,),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Text(isSignIn ? "You don't have an account ? " : "You already have an account ?"),
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text(isSignIn ? "Sign up" : "Sign in"),
                        onPressed: () {
                          setState(() => mode = (isSignIn ? FormMode.SINGUP : FormMode.SIGNIN));
                        },
                      ),
                    ],
                  )
                ],
              ),
          ),
        ),
      ),
    );
  }

  bool get isSignIn => mode == FormMode.SIGNIN;
}

class LogInForm extends StatefulWidget {
  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: "email",),
            autofocus: false,
            validator: (email) => email.isEmpty ? "Please enter your email" : null,
          ),
          SizedBox(height: Dimen.PADDING,),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(labelText: "password"),
            obscureText: true,
            autofocus: false,
            validator: (password) => password.isEmpty ? "Please enter your password" : null,
          ),
          SizedBox(height: Dimen.PADDING,),
          RaisedButton(
            child: Text("Log In"),
            onPressed: () async {
              if(_formKey.currentState.validate()) {
                try {
                  LoggedUser user = await AuthentificationProvider.classicSignIn(emailController.text, passwordController.text);
                  AccountProvider.setLoggedUser(user);
                  Navigator.pop(context);
                } on AuthentificationError catch(err) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(err.message),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Theme.of(context).errorColor,
                      action: SnackBarAction(label: "OK", onPressed: () {}, textColor: Colors.white,), // onPressed will remove the snackbar
                    )
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class SignUpFom extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpFom> {
  String email;
  String password;
  String passwordConfirmation;

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: "email",),
            autofocus: false,
            validator: (email) => email.isEmpty ? "Please enter your email" : null,
          ),
          SizedBox(height: Dimen.PADDING,),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(labelText: "password"),
            obscureText: true,
            autofocus: false,
            validator: (password) => password.isEmpty ? "Please enter your password" : null,
          ),
          SizedBox(height: Dimen.PADDING,),
          TextFormField(
            controller: passwordConfirmationController,
            decoration: InputDecoration(labelText: "confirm password"),
            obscureText: true,
            autofocus: false,
            validator: (password) => passwordController.text != password ? "Passwords doesn't match" : null,
          ),
          SizedBox(height: Dimen.PADDING,),
          RaisedButton(
            child: Text("Sign Up"),
              onPressed: () async {
                if(_formKey.currentState.validate()) {
                  try {
                    print(passwordController.text);
                    print("DEBUG");
                    LoggedUser user = await AuthentificationProvider.classicSignUp(emailController.text, passwordController.text);
                    AccountProvider.setLoggedUser(user);
                    Navigator.pop(context);
                    showSuccessSnackBar(context, user);
                  } on AuthentificationError catch(err) {
                    showErrorSnackBar(context, err.message);
                  }
                }
              },
          )
        ],
        
      ),
    );
  }

  showErrorSnackBar(context, error) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).errorColor,
        action: SnackBarAction(label: "OK", onPressed: () {}, textColor: Colors.white,), // onPressed will remove the snackbar
      )
    );
  }

  showSuccessSnackBar(context, username) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("User successfully added : $username"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).primaryColor,
      )
    );
  }
}