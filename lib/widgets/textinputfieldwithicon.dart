import 'package:flutter/material.dart';

class TextInputFieldWithIcon extends StatelessWidget {
  final TextEditingController controller_text;
  final String hint_text;
  final String error_msg;
  final Icon icon_widget;
  final bool show_password;
  Function FunctionToDo;

  TextInputFieldWithIcon(
      {required this.hint_text,
      required this.controller_text,
      required this.error_msg,
      required this.icon_widget,
      required this.show_password,
      required this.FunctionToDo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 55.0, right: 55.0),
      child: TextField(
        //  autofocus: true,
        textAlign: TextAlign.start,
        obscureText: show_password, // to show password or not
        controller: controller_text, // the variable that will contain input user data
        decoration: InputDecoration(
          filled: true,
          //   suffix: InkWell(onTap: FunctionToDo, child: icon_widget),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),

          fillColor: Colors.white,
          hintText: hint_text,
          errorText: error_msg,
          // labelText: label_text.tr().toString(),

          //suffix: InkWell(onTap: FunctionToDo, child: icon_widget),
          //   helperText: "Please put your password",
        ),
      ),
    );
  }
} //end class
