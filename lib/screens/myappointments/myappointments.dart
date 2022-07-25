import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saveme/api_models/book_model.dart';
import 'package:saveme/provider/permissions_provider.dart';
import 'package:saveme/widgets/mywidgets.dart';

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
  DateTime dateTime = DateTime.now();
  var inputFormat = DateFormat('dd/MM/yyyy HH:mm');

  void formatDate() {
    var inputDate = inputFormat.parse(dateTime.toString()); // <-- dd/MM 24H format
    var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    print(outputDate); // 12/31/2000 11:59 PM <-- MM/dd 12H format
  }

  MyWidgets myWidgets = new MyWidgets();
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
    super.initState();
    getUserFromFirebase();
    fetchDoc();
    //formatDate();
  }

  @override
  Widget build(BuildContext context) {
    PermissionsProvider permissionsProvider =
        Provider.of<PermissionsProvider>(context, listen: false);
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
              .collection('appointments') //NAME OF Collections
              .doc(userID) //ID OF DOCUMENT
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text('يوجد خطأ ما .. ');
            } else if (snapshot.data!.data() != null) {
              Map<String, dynamic>? output = snapshot.data!.data();

              var value = output!['doctorName']; // <-- Your value
              // using model class

              var book = BookModel.fromJson(output);
              //   print(book.doctorId);

              return Card(
                child: ListTile(
                  isThreeLine: false,
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
                      Visibility(
                        visible: permissionsProvider.showAddDoctor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15)),
                                        child: Container(
                                          height: MediaQuery.of(context).size.height,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode.dateAndTime,
                                                  initialDateTime: DateTime.now(),
                                                  onDateTimeChanged: (DateTime value) {
                                                    setState(() {
                                                      dateTime = value;
                                                      print(dateTime);
                                                    });
                                                  },
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    // update data in firebase
                                                    collection
                                                        .doc(
                                                            userID) // <-- Doc ID where data should be updated.
                                                        .update({
                                                          'reviewDate': dateTime.toString(),
                                                          'reviewState':
                                                              'تم قبول المراجعة وتم تحديد الموعد'
                                                        }) // <-- Updated data
                                                        .then((_) => myWidgets
                                                            .showToast("تم التحديث الموعد بنجاح"))
                                                        .catchError((error) =>
                                                            print('Update failed: $error'));
                                                    Navigator.of(context).pop();
                                                  },
                                                  icon: Icon(Icons.save))
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                //TODO:
                                collection
                                    .doc(userID) // <-- Doc ID where data should be updated.
                                    .delete() // <-- Updated data
                                    .then((_) => myWidgets.showToast("تم حذف الموعد بنجاح"))
                                    .catchError((error) => print('Update failed: $error'));
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.done),
                              onPressed: () {
                                collection
                                    .doc(userID) // <-- Doc ID where data should be updated.
                                    .delete() // <-- Updated data
                                    .then((_) => myWidgets.showToast("تم الانتهاء من الموعد بنجاح"))
                                    .catchError((error) => print('Update failed: $error'));
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // must return circuleprogressindicator
              return Center(child: Text("No result found"));
            }
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
// TODO: when getting data it shows error
