import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saveme/drawer.dart';
import 'package:saveme/screens/myappointments/myappointments.dart';

import 'provider/permissions_provider.dart';
import 'screens/doctor_services/doctor_services.dart';

class Navigations extends StatefulWidget {
  static const String id = 'navigations';
  @override
  State<Navigations> createState() => _NavigationsState();
}

class _NavigationsState extends State<Navigations> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int selectedPage = 0;
  late PageController pageController;
  var collection = FirebaseFirestore.instance.collection("users"); // to get the state of users
  FirebaseAuth firebaseAuth = FirebaseAuth.instance; // add firebase auth

  String? userID;
  String? userEmail;
  // get user data from firebase
  void getUserFromFirebase() {
    final User user = firebaseAuth.currentUser!;
    setState(() {
      userID = user.uid;
      userEmail = user.email;
      //  print("name of user is: $userEmail");
    });
  }

  fetchDoc() async {
    PermissionsProvider permissionsProvider =
        Provider.of<PermissionsProvider>(context, listen: false);

    var docSnapshot = await collection.doc(userID).get();
    print("the docSnapshot${docSnapshot.data()}");
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      if (data!['userType'] == "طبيب") {
        permissionsProvider.showInDrawerDoctorAddPost(true);
        print("the provider value is ${permissionsProvider.showAddDoctor}");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    getUserFromFirebase();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchDoc(); // fetch provider
  }

  //---------------------------List of Pages------------------------------------
  final List<Widget> _pages = [
    DoctorServices(),
    MyAppointments(),
  ];
  //--------------------------On Tapped item-----------------------------------
  _onTapped(int index) {
    setState(() {
      selectedPage = index;

      pageController.jumpToPage(index);
    });
  }
  //------------------------On Page Changed-------------------------------------

  void onPageChanged(int page) {
    setState(() {
      this.selectedPage = page;
    });
  }
  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawePage(),
      body: PageView(
        children: _pages,
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      key: _drawerKey,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // to make it unsizable
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "الأطباء"),
          BottomNavigationBarItem(icon: Icon(Icons.car_rental), label: "مواعيدي"),
          //  BottomNavigationBarItem(icon: Icon(Icons.date_range), label: "الاستشارات الطبية"),
        ],
        currentIndex: selectedPage,
        showUnselectedLabels: true,
        unselectedItemColor: Color(0xFFB1B1B1),
        selectedItemColor: Colors.redAccent,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        backgroundColor: Colors.white,
        onTap: _onTapped,
      ),
    );
  }
}
