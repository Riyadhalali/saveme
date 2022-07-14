import 'package:flutter/material.dart';
import 'package:saveme/screens/drawer.dart';

class PatientScreen extends StatefulWidget {
  static const id = 'patient_Screen';

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawePage(),
      body: Text("صفحة المريض"),
    );
  }
}
