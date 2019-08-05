import 'package:flutter/material.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';
import 'package:stuttherapy/strings.dart';
import 'package:stuttherapy/ui/components/secondary_appbar.dart';
import 'package:stuttherapy/ui/dimen.dart';

enum FormMode { SIGNIN , SIGNUP }

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
        title: isSignIn ? Strings.ACCOUNT_SIGNIN : Strings.ACCOUNT_SIGNUP
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
                      Text(isSignIn ? Strings.ACCOUNT_FORM_ACCOUNT_NOT_EXISTS : Strings.ACCOUNT_FORM_ACCOUNT_EXISTS),
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text(isSignIn ? Strings.ACCOUNT_SIGNUP : Strings.ACCOUNT_SIGNIN),
                        onPressed: () {
                          setState(() => mode = (isSignIn ? FormMode.SIGNUP : FormMode.SIGNIN));
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

  bool isLoading = false;
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
            enabled: !isLoading,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: Strings.ACCOUNT_FORM_EMAIL_LABEL,),
            autofocus: false,
            validator: (email) => email.isEmpty ? Strings.ACCOUNT_FORM_EMAIL_ERROR : null,
          ),
          SizedBox(height: Dimen.PADDING,),
          TextFormField(
            controller: passwordController,
            enabled: !isLoading,
            decoration: InputDecoration(labelText: Strings.ACCOUNT_FORM_PASSWORD_LABEL),
            obscureText: true,
            autofocus: false,
            validator: (password) => password.isEmpty ? Strings.ACCOUNT_FORM_PASSWORD_ERROR : null,
          ),
          SizedBox(height: Dimen.PADDING,),
          RaisedButton(
            child: Text(isLoading ? Strings.LOADING : Strings.ACCOUNT_SIGNIN),
            onPressed: isLoading ? null : () async {
              if(_formKey.currentState.validate()) {
                try {
                  setState(() => isLoading = true);
                  LoggedUser user = await AuthentificationProvider.classicSignIn(emailController.text, passwordController.text);
                  AccountProvider.setLoggedUser(user);
                  Navigator.pop(context);
                } on AuthentificationError catch(err) {
                  setState(() => isLoading = false);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(err.message),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Theme.of(context).errorColor,
                      action: SnackBarAction(label: Strings.OK, onPressed: () {}, textColor: Colors.white,), // onPressed will remove the snackbar
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
  bool isLoading = false;
  String email;
  String password;
  String passwordConfirmation;

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final nameController = TextEditingController();

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
            controller: nameController,
            enabled: !isLoading,
            decoration: InputDecoration(labelText: Strings.ACCOUNT_FORM_NAME_LABEL),
            textCapitalization: TextCapitalization.sentences,
            autofocus: false,
            validator: (name) => name.isEmpty ? Strings.ACCOUNT_FORM_NAME_ERROR : null,
          ),
          SizedBox(height: Dimen.PADDING,),
          TextFormField(
            controller: emailController,
            enabled: !isLoading,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: Strings.ACCOUNT_FORM_EMAIL_LABEL,),
            autofocus: false,
            validator: (email) => email.isEmpty ? Strings.ACCOUNT_FORM_EMAIL_ERROR : null,
          ),
          SizedBox(height: Dimen.PADDING,),
          TextFormField(
            controller: passwordController,
            enabled: !isLoading,
            decoration: InputDecoration(labelText: Strings.ACCOUNT_FORM_PASSWORD_LABEL),
            obscureText: true,
            autofocus: false,
            validator: (password) => password.isEmpty ? Strings.ACCOUNT_FORM_PASSWORD_ERROR: null,
          ),
          SizedBox(height: Dimen.PADDING,),
          TextFormField(
            controller: passwordConfirmationController,
            enabled: !isLoading,
            decoration: InputDecoration(labelText: Strings.ACCOUNT_FORM_PASSWORD_CONFIRM_LABLE),
            obscureText: true,
            autofocus: false,
            validator: (password) => passwordController.text != password ? Strings.ACCOUNT_FORM_PASSWORD_CONFIRM_ERROR : null,
          ),
          SizedBox(height: Dimen.PADDING,),
          RaisedButton(
            child: Text(isLoading ? Strings.LOADING : Strings.ACCOUNT_SIGNUP),
              onPressed: isLoading ? null : () async {
                if(_formKey.currentState.validate()) {
                  try {
                    setState(() => isLoading = true);
                    LoggedUser user = await AuthentificationProvider.classicSignUp(emailController.text, passwordController.text, nameController.text);
                    AccountProvider.setLoggedUser(user);
                    Navigator.pop(context);
                    showSuccessSnackBar(context, user);
                  } on AuthentificationError catch(err) {
                    setState(() => isLoading = false);
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
        action: SnackBarAction(label: Strings.OK, onPressed: () {}, textColor: Colors.white,), // onPressed will remove the snackbar
      )
    );
  }

  showSuccessSnackBar(context, username) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("${Strings.ACCOUNT_FORM_SUCCESS_CREATED}: $username"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).primaryColor,
      )
    );
  }
}