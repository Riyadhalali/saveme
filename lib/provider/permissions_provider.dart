import 'package:flutter/material.dart';

class PermissionsProvider extends ChangeNotifier {
  bool showAddDoctor = false;

  //-> this page to show if the user is doctor then show the page that doctor can add

  void showInDrawerDoctorAddPost(bool state) {
    showAddDoctor = state;
    notifyListeners();
  }
}
