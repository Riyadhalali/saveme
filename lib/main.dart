import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:saveme/navigator.dart';
import 'package:saveme/screens/home_screen/home_screen.dart';
import 'package:saveme/screens/maps/maps_nearby_places_screen.dart';
import 'package:saveme/screens/maps/maps_search_screen.dart';
import 'package:saveme/screens/maps/maps_shortest_path.dart';
import 'package:saveme/screens/register/register.dart';
import 'package:saveme/screens/sign_in/sign_in.dart';

import 'screens/splash_screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          SignIn.id: (context) => SignIn(),
          RegisterPage.id: (context) => RegisterPage(),
          HomeScreen.id: (context) => HomeScreen(),
          Navigations.id: (context) => Navigations(),
          MapsPageShortestPath.id: (context) => MapsPageShortestPath(), // shortest path
          MapsSearchScreen.id: (context) => MapsSearchScreen(),
          MapsNearByPlacesScreen.id: (context) => MapsNearByPlacesScreen(),
        });
  }
}
