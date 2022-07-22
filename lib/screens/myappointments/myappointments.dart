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
  var collection = FirebaseFirestore.instance.collection("appointments");

  String? userID;
  String? userEmail;
  // get user data from firebase
  void getUserFromFirebase() {
    final User user = firebaseAuth.currentUser!;
    setState(() {
      userID = user.uid;
      userEmail = user.email;
      print("name of user is: $userID");
    });
  }

//for using model class
  Stream<List<BookModel>> getAppointments() => FirebaseFirestore.instance
      .collection('appointments')
      //.doc(userID)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => BookModel.fromJson(doc.data())).toList());

  fetchDoc() async {
    var docSnapshot = await collection.doc(userID).get();
    print("the docSnapshot${docSnapshot.data()}");
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      print(data);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserFromFirebase();
    fetchDoc();
  }

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
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('appointments')
              .doc(userID) //ID OF DOCUMENT
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text('يوجد خطأ ما .. ');
            } else if (snapshot.hasData) {
              Map<String, dynamic>? output = snapshot.data!.data();
              var value = output!['doctorName']; // <-- Your value
              // using model class
              var book = BookModel.fromJson(output!);
              print(book.doctorId);

              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text(output['doctorName'])),
                  title: Text(
                    // output['doctorName'],
                    book.doctorName, // using book model
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
                          Text(output['doctorPhone']),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.category_sharp),
                          Text(output['doctorType']),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded),
                          Text(output['reviewDate']),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on),
                          Text(output['doctorLocation']),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.email),
                          Text(output['doctorEmail']),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.real_estate_agent_rounded),
                          Text(output['reviewState']),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
    );
  }

// we can use this widget when we use to get all data
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
