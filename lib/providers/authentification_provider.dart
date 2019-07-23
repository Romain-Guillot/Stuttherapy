import 'package:cloud_firestore/cloud_firestore.dart';
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


  static Future<LoggedUser> classicSignUp(String email, String password, String name) async {
    try {
      FirebaseUser fbUser = await auth.createUserWithEmailAndPassword(email: email, password: password);
      LoggedUser user = LoggedUser(fbUser);
      Firestore.instance
        .collection("users")
        .document(user.uid)
        .setData({"name": name});
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

  // static googleSignIn() {
  // }

  // static googleSignUp() {
  // }
  
}

class LoggedUser {
  final FirebaseUser user;

  LoggedUser(this.user) ;

  String get email => user?.email;
  String get name => user?.displayName;
  String get uid => user?.uid;
}

class LoggedUserMeta {
  String name;
  String uid;
  String email;

  LoggedUserMeta({this.name, @required this.uid, this.email});
}