import 'package:flutter/material.dart';
import 'package:saveme/drawer.dart';
import 'package:saveme/screens/myappointments/myappointments.dart';

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

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
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
          BottomNavigationBarItem(icon: Icon(Icons.date_range), label: "الاستشارات الطبية"),
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
