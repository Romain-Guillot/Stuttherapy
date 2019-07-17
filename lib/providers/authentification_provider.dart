import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';


class AuthentificationError implements Exception {
  final String message;
  AuthentificationError(this.message);
  @override
  String toString() => message;
}


class AuthentificationProvider {
  static FirebaseAuth auth = FirebaseAuth.instance;


  static Future<LoggedUser> classicSignIn(String email, String password) async {
    try {
        FirebaseUser user = await auth.signInWithEmailAndPassword(email: email, password: password);
        return LoggedUser(user);
    } on PlatformException catch(err) {
      throw AuthentificationError(err.message);
    } catch(e) {
      throw AuthentificationError("Something went wrong ...");
    }
  }


  static Future<LoggedUser> classicSignUp(String email, String password) async {
    try {
      FirebaseUser fbUser = await auth.createUserWithEmailAndPassword(email: email, password: password);
      LoggedUser user = LoggedUser(fbUser);
      return user;
    } on PlatformException catch(err) {
      throw AuthentificationError(err.message);
    } catch(e) {
      throw AuthentificationError("Something went wrong ...");
    }
  }

  static logout() async {
    auth.signOut();
  }

  static Future<LoggedUser> currentUser() async {
    FirebaseUser user = await auth.currentUser();
    return user == null ? null : LoggedUser(user);
  }

  static googleSignIn() {
    // TODO
  }

  static googleSignUp() {
    // TODO
  }
  
}

class LoggedUser {
  final FirebaseUser user;

  LoggedUser(this.user) ;

  String get email => user?.email;
  String get name => user?.displayName;
  String get uid => user?.uid;
}

class LoggedUserMeta {
  final String name;
  final String uid;
  final String email;

  LoggedUserMeta({@required this.name, @required this.uid, @required this.email});
}