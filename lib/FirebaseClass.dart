import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class FirebaseClass {
  static final _firestore = Firestore.instance;
  static final _fireAuth = FirebaseAuth.instance;

  Future<FirebaseUser> login({
    String email,
    String password,
  }) async {
    try {
      var user = await _fireAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return user.user;
    } on Exception catch (e) {
      print(e.toString());
      print("Authentication error");
    }
  }

  Future<FirebaseUser> signup({
    String email,
    String password,
    String phoneNumber,
    String phone,
    String city,
    String country,
    bool isHelper,
  }) async {
    try {
      var user = await _fireAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (isHelper) {
        _firestore.collection("helpers").add({
          "userid": user.user.uid,
          "phoneNumber": phone,
          "city": city,
          "country": country
        });
      } else {
        _firestore.collection("users").document(user.user.uid).setData({
          "userid": user.user.uid,
          "phoneNumber": phone,
          "city": city,
          "country": country
        });
      }

      return user.user;
    } on Exception catch (e) {
      print(e.toString());
      print("Authentication error");
    }
  }

  void signout() {
    _fireAuth.signOut();
  }

  Future<FirebaseUser> getCurrentUser() {
    return FirebaseAuth.instance.currentUser();
  }

  static void addEmergency(
      {String city,
      String country,
      String type,
      String whoIsInjured,
      GeoPoint location,
      String userid}) {
    _firestore.collection("emergencies").add({
      "city": city,
      "country": country,
      "type": type,
      "location": location,
      "sentBy": userid,
      "whoIsInjured": whoIsInjured
    }).then((value) {
      print('done');
    }).catchError((error) {
      print(error);
    });
  }

  // Map getDocumentFromFirebase({String documentID}) async {
  //   await for (var snapshot in _firestore.document(documentID).snapshots()) {}
  // }
  //
  // Map getCollectionFromFirestore(String collectionID) async {
  //   await for (var snapshot in _firestore.collection("messages").snapshots()) {
  //     for (var document in snapshot.documents) {
  //       print(document.data);
  //     }
  //   }
  // }
}
