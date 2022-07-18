import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saveme/api_models/book_model.dart';
import 'package:saveme/api_models/doctor_post_model.dart';
import 'package:saveme/services/sharedpreferences.dart';

class DoctorServices extends StatefulWidget {
  static const id = 'doctor_services';

  @override
  State<DoctorServices> createState() => _DoctorServicesState();
}

class _DoctorServicesState extends State<DoctorServices> {
  SharedPref sharedPref = new SharedPref();
  String email_data = '';
  String password_data = '';
  String uid_data = '';
  String? userID;
  String? userEmail;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Stream<List<DoctorPosts>> readPosts() => FirebaseFirestore.instance
      .collection('posts')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => DoctorPosts.fromJson(doc.data())).toList());

  Future loadUserDataLogin() async {
    email_data = await sharedPref.LoadData("email");
    password_data = await sharedPref.LoadData('password');
    uid_data = await sharedPref.LoadData("uid");
  }

  // get user data from firebase
  void getUserFromFirebase() {
    final User user = firebaseAuth.currentUser!;
    setState(() {
      userID = user.uid;
      userEmail = user.email;
      //  print("name of user is: $userEmail");
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserDataLogin();
    getUserFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              // open drawer
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu)),
        title: Text("قائمة الأطباء"),
        backgroundColor: Colors.deepOrange,
      ),
      body: StreamBuilder<List<DoctorPosts>>(
        stream: readPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("حصل خطأ ما ...!"));
          } else if (snapshot.hasData) {
            final posts = snapshot.data!;
            return ListView(
              children: posts.map(buildPosts).toList(),
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }

  Widget buildPosts(DoctorPosts doctorPosts) => Card(
        child: ListTile(
          leading: CircleAvatar(child: Text(doctorPosts.doctorName)),
          title: Text(
            doctorPosts.doctorName,
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
                  Text(doctorPosts.doctorPhone),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.category_sharp),
                  Text(doctorPosts.doctorType),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time_rounded),
                  Text(doctorPosts.openingTime),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_on),
                  Text(doctorPosts.doctorLocation),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.email),
                  Text(doctorPosts.doctorEmail),
                ],
              )
            ],
          ),
          trailing: IconButton(
            onPressed: () async {
              // note: make book using user id
              final appointments =
                  FirebaseFirestore.instance.collection('appointments').doc(userID);
              final book = BookModel(
                  doctorId: doctorPosts.doctorId,
                  doctorName: doctorPosts.doctorName,
                  doctorType: doctorPosts.doctorType,
                  openingTime: doctorPosts.openingTime,
                  doctorLocation: doctorPosts.doctorLocation,
                  doctorPhone: doctorPosts.doctorPhone,
                  doctorEmail: doctorPosts.doctorEmail,
                  patientId: userID.toString(),
                  patientEmail: userEmail.toString(),
                  reviewDate: 'بانتظار التحديد',
                  reviewState: 'بانتظار الموافقة');

              final json = book.toJson();
              await appointments.set(json);

              Fluttertoast.showToast(
                  msg: "تم الإضافة بنجاح",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 16.0);
            },
            icon: Icon(
              Icons.add,
              color: Colors.red,
            ),
          ),
        ),
      );
}
