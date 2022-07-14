import 'package:flutter/material.dart';

class DoctorScreen extends StatefulWidget {
  static const id = 'doctor_screen';

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: SafeArea(child: Text("صفحة الطبيب")),
    );
  }
}
