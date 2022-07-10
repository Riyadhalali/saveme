import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home_Screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Home Page"),
    );
  }
}
