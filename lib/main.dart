import 'package:flutter/material.dart';
import 'package:saveme/screens/sign_in/sign_in.dart';
import 'package:saveme/screens/splash_screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: SplashScreen.id,
      debugShowCheckedModeBanner: false,
      routes: {SplashScreen.id: (context) => SplashScreen(), SignIn.id: (context) => SignIn()},
    );
  }
}
