import 'package:flutter/material.dart';
import 'package:saveme/services/sharedpreferences.dart';
import 'package:saveme/widgets/textinputfield.dart';
import 'package:saveme/widgets/textinputfieldwithicon.dart';

import '../register/register.dart';

class SignIn extends StatefulWidget {
  static const id = 'sign_in';

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late String phone_data, password_data; //variables for holding shared pref data
  late String usernameData; // this variable to store data returned from getUserInfo Api
  late String userPhoneData; // this variable to store data returned from getUserInfo Api
  late String userGenderData; // this variable to store data returned from getUserInfo Api
  final _phonecontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

  bool validatePhone = false;
  bool validatePassword = false;
  bool _isHidden = false;

  SharedPref sharedPref = new SharedPref();
  //------------------------------Functions-------------------------------------
  //-> Loading User Data if he is already signed in to the program
  Future loadUserDataLogin() async {
    phone_data = await sharedPref.LoadData("phone");
    password_data = await sharedPref.LoadData('password');
    if (phone_data != null && password_data != null) {
      setState(() {
        _phonecontroller.text = phone_data;
        _passwordcontroller.text = password_data;
      });
    }
  }

//******************************************************************************

  @override
  void initState() {
    super.initState();
    loadUserDataLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: columnElements(),
    );
  }

  Widget columnElements() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            imageBackground(),
            sign_in_Container(),
          ],
        ),
      ),
    );
  }

//------------------------------------------------------------------------------
  //-> Widget of background
  Widget imageBackground() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/screens/signin/signin2.jpeg'), fit: BoxFit.contain),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------
  //-> Button for sign in
  Widget Login() {
    return Container(
      padding: EdgeInsets.only(right: 55.0, left: 55.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        color: Colors.blue,
        child: Text(
          "تسجيل الدخول",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: Colors.blue,
          ),
        ),
        onPressed: signInFunction,
      ),
    );
  }

  //----------------------------------------------------------------------------
  //-> Flatted Button for forget password
  Widget forgetPassword() {
    return Container(
      width: MediaQuery.of(context).size.width, // take all space available
      child: FlatButton(
        onPressed: () {
          //     Navigator.pushNamed(context, ForgetPassword.id);
        },
        child: Text("نسيت كلمة المرور؟"),
      ),
    );
  }

  //----------------------------------------------------------------------------
  //-> I am new User Sign up
  Widget Signup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text("مستخدم جديد"),
        ),
        Container(
          child: FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, RegisterPage.id);
            },
            child: Text(
              'التسجيل',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------
  //-> Container for having all elements with sign in and username
  Widget sign_in_Container() {
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
              height: 5.0,
            ),
            Text(
              "تسجيل الدخول",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black38),
            ),
            SizedBox(
              height: 2.0,
            ),
            TextInputField(
              hint_text: "رقم الهاتف",
              //label_text: "username",
              controller_text: _phonecontroller,
              show_password: false,
              error_msg: validatePassword ? "يرجى تعبئة الحقل" : "",
              FunctionToDo: () {},
            ),
            SizedBox(
              height: 3.0,
            ),
            // it must be another textinputfield
            TextInputFieldWithIcon(
              hint_text: "كلمة المرور",
              // label_text: "password",
              controller_text: _passwordcontroller,
              icon_widget: _isHidden ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
              show_password: _isHidden,
              error_msg: validatePassword ? "يرجى تعبئة الحقل" : "",
              // error_msg:
              //     _passwordcontroller.text.isEmpty ? "يرجى تعبئة الحقل" : "",
              FunctionToDo: () {
                setState(() {
                  _isHidden = !_isHidden;
                });
              },
            ),
            SizedBox(
              height: 1.0,
            ),
            // forgetPassword(),
            SizedBox(
              height: 1.0,
            ),
            Login(),
            SizedBox(
              height: 1.0,
            ),
            Signup(),
          ],
        ),
      ],
    );
  }

//------------------------------------------------------------------------------
//-----------------------------------Functions----------------------------------
  void signInFunction() {
    setState(() {
      _phonecontroller.text.isEmpty ? validatePhone = true : validatePhone = false;

      _passwordcontroller.text.isEmpty ? validatePassword = true : validatePassword = false;
    });

    if (validatePhone || validatePassword) {
      return;
    }

    sharedPref.setData('phone', _phonecontroller.text);
    sharedPref.setData('password', _passwordcontroller.text);
    // show a snackbar message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "تم تسجيل الدخول بنجاح",
        style: TextStyle(
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.white,
    ));

    // Navigator.pushNamed(context, Navigations.id);
  }
//------------------------------------------------------------------------------

} // end class
