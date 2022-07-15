import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saveme/api_models/doctor_post_model.dart';

class DoctorServices extends StatefulWidget {
  static const id = 'doctor_services';

  @override
  State<DoctorServices> createState() => _DoctorServicesState();
}

class _DoctorServicesState extends State<DoctorServices> {
  Stream<List<DoctorPosts>> readPosts() => FirebaseFirestore.instance
      .collection('posts')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => DoctorPosts.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("قائمة الأطباء"),
        backgroundColor: Colors.deepOrange,
      ),
      body: StreamBuilder<List<DoctorPosts>>(
        stream: readPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something is Wrong");
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
            onPressed: () {
              //TODO: add book
            },
            icon: Icon(
              Icons.add,
              color: Colors.red,
            ),
          ),
        ),
      );
}
