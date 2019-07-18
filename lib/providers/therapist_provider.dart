import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';

class FirebaseCloudTherapistProvider {
  static final String usersCollection = "users";
  static final String patientsCollection = "patients";

  BehaviorSubject<List<LoggedUserMeta>> allPatients(LoggedUser user) {
    BehaviorSubject<List<LoggedUserMeta>> patients = BehaviorSubject<List<LoggedUserMeta>>();
    if(isLogged(user)) {

    }
    return patients;
  }

  Future<void> addTherapist(LoggedUser user, String uidTherapist) async {
    if(isLogged(user)) {
      return await Firestore.instance
        .collection(usersCollection)
        .document(user.uid)
        .updateData({"therapist": uidTherapist});
    }
  }

  docToLoggedUserMeta(DocumentSnapshot doc) {
    return LoggedUserMeta(
      email: doc.data["email"],
      name: doc.data["name"],
      uid: doc.data["uid"]
    );
  }

  loggedUserMetaToDoc(LoggedUser user) {
    return {
      "email": user?.email,
      "name": user?.name,
      "uid": user?.uid,
    };
  }

  bool isLogged(LoggedUser user) => user != null && user.uid != null;

}