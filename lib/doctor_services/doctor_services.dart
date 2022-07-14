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

  Widget buildPosts(DoctorPosts doctorPosts) => ListTile(
        leading: CircleAvatar(
          child: Text(doctorPosts.doctorName),
        ),
        title: Text(doctorPosts.doctorPhone),
      );
}
