import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saveme/api_models/book_model.dart';

class MyAppointments extends StatefulWidget {
  static const id = 'my_appointments';

  @override
  State<MyAppointments> createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
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

  Stream<List<BookModel>> getAppointments() => FirebaseFirestore.instance
      .collection('appointments')
      //    .doc(userID)
      .snapshots()
      .map((list) => list.docs.map((doc) => BookModel.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مواعيدي'),
        leading: IconButton(
            onPressed: () {
              // open drawer
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu)),
        backgroundColor: Colors.deepOrange,
      ),
      body: StreamBuilder<List<BookModel>>(
          stream: getAppointments(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('يوجد خطأ ما .. ');
            } else if (snapshot.hasData) {
              final appointments = snapshot.data!;
              return ListView(
                children: appointments.map(buildAppointments).toList(),
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
    );
  }

  Widget buildAppointments(BookModel bookModel) => Card(
        child: ListTile(
          leading: CircleAvatar(child: Text(bookModel.doctorName)),
          title: Text(
            bookModel.doctorName,
            style: TextStyle(
                fontFamily: "OoohBaby",
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.red),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.phone),
                  Text(bookModel.doctorPhone),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.category_sharp),
                  Text(bookModel.doctorType),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time_rounded),
                  Text(bookModel.openingTime),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_on),
                  Text(bookModel.doctorLocation),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.email),
                  Text(bookModel.doctorEmail),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.email),
                  Text(bookModel.doctorEmail),
                ],
              )
            ],
          ),
        ),
      );
} // end class
//TODO: get based on the id of the user
