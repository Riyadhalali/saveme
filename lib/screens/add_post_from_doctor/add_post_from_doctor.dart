// this class for doctors so they can add posts about services they give
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saveme/api_models/doctor_post_model.dart';
import 'package:saveme/widgets/mywidgets.dart';
import 'package:saveme/widgets/textinputfield.dart';

class AddPostsFromDoctor extends StatefulWidget {
  static const id = 'add_posts_from_doctor_screen';

  @override
  State<AddPostsFromDoctor> createState() => _AddPostsFromDoctorState();
}

class _AddPostsFromDoctorState extends State<AddPostsFromDoctor> {
  final _doctorNameController = TextEditingController();
  final _doctorTypeController = TextEditingController();
  final _openingTimeController = TextEditingController();
  final _doctorPhoneController = TextEditingController();
  final _doctorEmailController = TextEditingController();
  final _doctorLocationController = TextEditingController();

  bool _validateDoctorName = false;
  bool _validateDoctorType = false;
  bool _validateOpeningTime = false;
  bool _validateDoctorPhone = false;
  bool _validateDoctorEmail = false;
  bool _validateDoctorLocation = false;

  MyWidgets myWidgets = new MyWidgets();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: columnElements(),
    );
  }

  Widget columnElements() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            imageBackground(),
            addPostContainer(),
          ],
        ),
      ),
    );
  }

//---------------------------Column Elements------------------------------------
  Widget imageBackground() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/screens/add_post/add_post.png'), fit: BoxFit.cover),
        ),
      ),
    );
  }

//--------------------------------Widgets---------------------------------------
  //-> Register User Button
  Widget AddPostBtn() {
    return Container(
      padding: EdgeInsets.only(right: 55.0, left: 55.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        color: Colors.blue,
        child: Text(
          "إضافة عيادة ",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: Colors.blueAccent,
          ),
        ),
        onPressed: () {
          createPost(
              _doctorNameController.text,
              _doctorTypeController.text,
              _openingTimeController.text,
              _doctorLocationController.text,
              _doctorPhoneController.text,
              _doctorEmailController.text);
        },
      ),
    );
  }

  //-> Container for having elements
  Widget addPostContainer() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Color(0xFFf2f2f2),
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: 1.0,
            ),
            Text(
              "إضافة عيادة طبيب",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black38),
            ),
            TextInputField(
              hint_text: "اسم الطبيب",
              controller_text: _doctorNameController,
              show_password: false,
              error_msg: _validateDoctorName ? "يرجى إضافة اسم الطبيب" : " ",
            ),
            SizedBox(
              height: 1.0,
            ),
            TextInputField(
              hint_text: "اختصاص الطبيب",
              controller_text: _doctorTypeController,
              show_password: false,
              error_msg: _validateDoctorType ? "يرجى إضافة الاختصاص" : " ",
            ),
            SizedBox(
              height: 1.0,
            ),
            TextInputField(
              hint_text: "وقت الدوام",
              controller_text: _openingTimeController,
              show_password: false, // hide password for the user
              error_msg: _validateOpeningTime ? "يرجى إضافة أوقات الدوام" : " ",
            ),
            SizedBox(
              height: 1.0,
            ),
            TextInputField(
              hint_text: "موقع عيادة الطبيب",
              controller_text: _doctorLocationController,
              show_password: false, // hide password for the user
              error_msg: _validateDoctorLocation ? "يرجى إضافة موقع العيادة" : " ",
            ),
            SizedBox(
              height: 1.0,
            ),
            TextInputField(
              hint_text: "عنوان البريد الإلكتروني",
              controller_text: _doctorEmailController,
              show_password: false, // hide password for the user
              error_msg: _validateDoctorEmail ? "يرجى إضافة عنوان البريد الإلكتروني" : " ",
            ),
            SizedBox(
              height: 1.0,
            ),
            TextInputField(
              hint_text: "رقم الهاتف",
              controller_text: _doctorPhoneController,
              show_password: false,
              error_msg: _validateDoctorPhone ? "يرجى إضافة رقم الهاتف" : "  ",
            ),
            SizedBox(
              height: 1.0,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20.0,
                ),
              ],
            ),
            SizedBox(
              height: 2.0,
            ),
            AddPostBtn(),
          ],
        ),
      ],
    );
  }

  Future createPost(String doctorName, String doctorType, String openingTime, String doctorLocation,
      String doctorPhone, String doctorEmail) async {
    final posts = FirebaseFirestore.instance.collection('posts').doc();

    setState(() {
      _doctorNameController.text.isEmpty
          ? _validateDoctorEmail = true
          : _validateDoctorName = false;
      _doctorTypeController.text.isEmpty ? _validateDoctorType = true : _validateDoctorType = false;
      _openingTimeController.text.isEmpty
          ? _validateOpeningTime = true
          : _validateOpeningTime = false;
      _doctorLocationController.text.isEmpty
          ? _validateDoctorLocation = true
          : _validateDoctorLocation = false;
      _doctorPhoneController.text.isEmpty
          ? _validateDoctorPhone = true
          : _validateDoctorPhone = false;
      _doctorEmailController.text.isEmpty
          ? _validateDoctorEmail = true
          : _validateDoctorEmail = false;
    });

    if (_validateDoctorEmail ||
        _validateDoctorType ||
        _validateOpeningTime ||
        _validateDoctorLocation ||
        _validateDoctorPhone ||
        _validateDoctorEmail) {
      return;
    }

    // -> show progress bar if user already entered the required data
    myWidgets.showProcessingDialog("جاري الإضافة ...", context);

/*
method one:
    // final json = {
    //   'doctorName': doctorName,
    //   'doctorType': doctorType,
    //   'openingTime': openingTime,
    //   'doctorLocation': doctorLocation,
    //   'doctorPhone': doctorPhone,
    //   'doctorEmail': doctorEmail
    // };
    //await posts.set(json);
*/
    // method two
    final doctor = DoctorPosts(
        doctorName: doctorName,
        doctorType: doctorType,
        openingTime: openingTime,
        doctorLocation: doctorLocation,
        doctorPhone: doctorPhone,
        doctorEmail: doctorEmail);
    final json = doctor.toJson();
    // create doc and write data to firebase
    await posts.set(json);

    Navigator.pop(context);
    Fluttertoast.showToast(
        msg: "تم الإضافة بنجاح",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }
} // end class
