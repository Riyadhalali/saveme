import 'package:flutter/material.dart';
import 'package:saveme/screens/drawer.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home_Screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawePage(),
      body: Text("Home Page"),
    );
  }
}
