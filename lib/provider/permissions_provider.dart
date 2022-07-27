import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PermissionsProvider extends ChangeNotifier {
  bool showAddDoctor = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance; // add firebase auth
  String? userId;
  bool doctorBookedForDoctorState = false;

  //-> this page to show if the user is doctor then show the page that doctor can add

  void showInDrawerDoctorAddPost(bool state) {
    showAddDoctor = state;
    print("usertype : doctor $showAddDoctor");
    notifyListeners();
  }

  //-> this function will make userId global in the app
  void getUserFromFirebase() {
    final User user = firebaseAuth.currentUser!;
    userId = user.uid;
    notifyListeners();
  }

  void doctorBookedForDoctor(bool state) {
    doctorBookedForDoctorState = state;
    notifyListeners();
  }
}
