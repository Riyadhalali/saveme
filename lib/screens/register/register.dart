import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saveme/widgets/mywidgets.dart';
import 'package:saveme/widgets/textinputfield.dart';

import '../sign_in/sign_in.dart';

class RegisterPage extends StatefulWidget {
  static const id = 'register_page';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  //-> add firebase auth
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool _saving = false;

  bool _validateUsername = false;
  bool _validatePassword = false;
  bool _validatePhone = false;
  MyWidgets myWidgets = new MyWidgets();

  Future<void> login() async {
    //- To check the user already entered username and password
    setState(() {
      _usernameController.text.isEmpty ? _validateUsername = true : _validateUsername = false;

      _passwordController.text.isEmpty ? _validatePassword = true : _validatePassword = false;

      _phoneController.text.isEmpty ? _validatePhone = true : _validatePhone = false;
    });

    //  if user didn't enter username or password or phone keep inside
    if (_validateUsername || _validatePassword || _validatePhone) {
      return;
    }
    // -> show progress bar if user already entered the required data
    myWidgets.showProcessingDialog("جاري التسجيل ...", context);

    //-> create user in firebase
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: _usernameController.text.toLowerCase().trim(),
          password: _passwordController.text.toLowerCase().trim());
      //-> Display snackbar message
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم التسجيل بنجاح"),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pushNamed(context, SignIn.id);
    } on FirebaseAuthException catch (e) {
      //-> Display snackbar message with error
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
          duration: Duration(seconds: 3),
        ),
      );
    }
  } // enc function

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: columnElements(),
    );
  } // end build

  //-------------------------------Column --------------------------------------
  Widget columnElements() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            imageBackground(),
            registerContainer(),
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
              image: AssetImage('assets/screens/register/register.jpg'), fit: BoxFit.contain),
        ),
      ),
    );
  }

//--------------------------------Widgets---------------------------------------
  //-> Register User Button
  Widget Register() {
    return Container(
      padding: EdgeInsets.only(right: 55.0, left: 55.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        color: Colors.blue,
        child: Text(
          "تسجيل",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: Colors.blueAccent,
          ),
        ),
        onPressed: login,
      ),
    );
  }

  //-> Container for having elements
  Widget registerContainer() {
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
              height: 2.0,
            ),
            Text(
              "تسجيل",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black38),
            ),
            SizedBox(
              height: 4.0,
            ),
            TextInputField(
              hint_text: "اسم المستخدم",
              controller_text: _usernameController,
              show_password: false,
              error_msg: _validateUsername ? "يرجى تعبئة الحقل" : " ",
            ),
            SizedBox(
              height: 5.0,
            ),
            TextInputField(
              hint_text: "كلمة المرور",
              controller_text: _passwordController,
              show_password: true, // hide password for the user
              error_msg: _validatePassword ? "يرجى تعبئة الحقل" : " ",
            ),
            SizedBox(
              height: 5.0,
            ),
            TextInputField(
              hint_text: "رقم الهاتف",
              controller_text: _phoneController,
              show_password: false,
              error_msg: _validatePhone ? "يرجى تعبئة الحقل" : "  ",
            ),
            SizedBox(
              height: 5.0,
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
            Register(),
          ],
        ),
      ],
    );
  }
} // end class
