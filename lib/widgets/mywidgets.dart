import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyWidgets {
  //-----------------------------SnackBar Message-------------------------------
  void displaySnackMessage(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.white,
    ));
  }

  //---------------------------------Processing Dialog--------------------------
  void showProcessingDialog(String text, BuildContext context) async {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            content: Container(
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 5.0,
                ),
                Text(text, style: TextStyle(fontFamily: "OpenSans", color: Color(0xFF5B6978)))
              ]),
            ),
          );
        });
  }

  //------------------------------Toast Message------------------------------------------------
  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }

//---------------------------------------------------------------------------------------------
}
