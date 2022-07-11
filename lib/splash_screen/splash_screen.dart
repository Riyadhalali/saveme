import 'dart:async';

import 'package:flutter/material.dart';

import '../../widgets/image_background.dart';
import '../screens/maps/maps_search_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<Timer> LoadTimer() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

  Future onDoneLoading() async {
    Navigator.pushNamed(context, MapsSearchScreen.id);
  }

  @override
  void initState() {
    super.initState();
    LoadTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: logoScreen(),
    );
  }

  //------------------------------logo Screen--------------------------------------
  Widget logoScreen() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.1,
        ),
        ImageBackground(imageAsset: 'assets/icon/icon.png'),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Text(
          "Save Me App",
          style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
              //   color: Colors.blue,
              fontFamily: 'OoohBaby'),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: LinearProgressIndicator(),
        ),
      ],
    );
  }
  //------------------------------------------------------------------
} // end class
