import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:saveme/api_models/book_model.dart';
import 'package:saveme/api_models/doctor_post_model.dart';
import 'package:saveme/provider/permissions_provider.dart';
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
  String? userName;
  String? userPhone;
  String? userType;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  var collection = FirebaseFirestore.instance.collection("users");

  Stream<List<DoctorPosts>> readPosts() => FirebaseFirestore.instance
      .collection('posts')
      .orderBy("doctorType")
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

  fetchDoc() async {
    var docSnapshot = await collection.doc(userID).get();
    //   print("the docSnapshot${docSnapshot.data()}");
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      // print(data!['name']);
      setState(() {
        userName = data!['name'];
        userPhone = data['phone_number'];
      });
    }
  }

  fetchUserInfo() async {
    var docSnapshot = await collection.doc(userID).get();
    //   print("the docSnapshot${docSnapshot.data()}");
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      // print(data!['name']);
      setState(() {
        userType = data!['userType'];
        print("the user type is: $userType");
      });
    }
  }

  Stream<List<BookModel>> searchResults() => FirebaseFirestore.instance
      .collection('appointments')
      .where('doctorName', isEqualTo: "الجندي")
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => BookModel.fromJson(doc.data())).toList());

  @override
  void initState() {
    super.initState();
    loadUserDataLogin();
    getUserFromFirebase();
    fetchDoc();
    fetchUserInfo();
    searchResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
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
            if (posts.isEmpty) {
              return Center(
                  child: Text(
                "لا يوجد نتائج",
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20.0),
              ));
            } else {
              return ListView(
                children: posts.map(buildPosts).toList(),
              );
            }
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }

  Widget buildPosts(DoctorPosts doctorPosts) {
    PermissionsProvider permissionsProvider =
        Provider.of<PermissionsProvider>(context, listen: false);
    return Card(
        child: ListTile(
      leading: CircleAvatar(child: Text(doctorPosts.doctorName)),
      title: Text(
        doctorPosts.doctorName,
        style: TextStyle(
            fontFamily: "OoohBaby", fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.red),
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
              Expanded(child: Text(doctorPosts.openingTime)),
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
      trailing: Visibility(
        visible: userType != "طبيب",
        child: IconButton(
          onPressed: () async {
            // note: make book using user id

            final appointments = FirebaseFirestore.instance.collection('appointments').doc(userID);
            final book = BookModel(
                patientName: userName.toString(),
                doctorId: doctorPosts.doctorId,
                doctorName: doctorPosts.doctorName,
                doctorType: doctorPosts.doctorType,
                openingTime: doctorPosts.openingTime,
                doctorLocation: doctorPosts.doctorLocation,
                doctorPhone: doctorPosts.doctorPhone,
                doctorEmail: doctorPosts.doctorEmail,
                patientId: userID.toString(),
                patientEmail: userEmail.toString(),
                patientPhone: userPhone.toString(),
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
    ));
  }
} // end  class
