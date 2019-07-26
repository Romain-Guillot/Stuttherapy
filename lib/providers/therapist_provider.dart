import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stuttherapy/log_printer.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';

class FirebaseCloudTherapistProvider {
  final logger = Logger(printer: MyPrinter("therapist_provider.dart"));
  
  static final String usersCollection = "users";
  static final String patientsCollection = "patients";

  BehaviorSubject<List<LoggedUserMeta>> allPatients(LoggedUser user) {
    logger.d("DEBUG");
    BehaviorSubject<List<LoggedUserMeta>> patients = BehaviorSubject<List<LoggedUserMeta>>();
    if(isLogged(user)) {
      Firestore.instance
        .collection(usersCollection)
        .snapshots()
        .listen((QuerySnapshot snap) {
          logger.d("OKK");
          List<LoggedUserMeta> _tmp = [];
          snap.documents.forEach((DocumentSnapshot doc){
            if(doc.data["therapist"] == user.uid)
              _tmp.add(LoggedUserMeta(uid: doc.documentID, email: "", name: doc.data["name"]));
          });
          patients.add(_tmp);
        });
        
    }
    return patients;
  }

  BehaviorSubject<LoggedUserMeta> getTherapist(LoggedUser user) {
    BehaviorSubject<LoggedUserMeta> therapist = BehaviorSubject<LoggedUserMeta>();
    Firestore.instance
      .collection(usersCollection)
      .document(user.uid)
      .snapshots().listen((DocumentSnapshot doc) {
        if(doc.data.containsKey(("therapist"))) {
          therapist.add(LoggedUserMeta(uid: doc.data["therapist"]));
        } else {
          therapist.add(null);
        }
      });
    return therapist;
  }

  Future<void> addTherapist(LoggedUser user, String uidTherapist) async {
    if(isLogged(user)) {
      return await Firestore.instance
        .collection(usersCollection)
        .document(user.uid)
        .setData({"therapist": uidTherapist}, merge: true);
    }
  }

  Future<void> deleteTherapist(LoggedUser user, String patientUID) async {
    if(isLogged(user)) {
      return await Firestore.instance
        .collection(usersCollection)
        .document(patientUID)
        .updateData({"therapist": FieldValue.delete()});
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