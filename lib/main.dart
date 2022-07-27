import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saveme/navigator.dart';
import 'package:saveme/provider/permissions_provider.dart';
import 'package:saveme/screens/add_post_from_doctor/add_post_from_doctor.dart';
import 'package:saveme/screens/maps/maps_nearby_places_screen.dart';
import 'package:saveme/screens/maps/maps_search_screen.dart';
import 'package:saveme/screens/maps/maps_shortest_path.dart';
import 'package:saveme/screens/myappointments/myappointments.dart';
import 'package:saveme/screens/register/register.dart';
import 'package:saveme/screens/search_doctors/search_doctors.dart';
import 'package:saveme/screens/sign_in/sign_in.dart';

import 'screens/doctor_services/doctor_services.dart';
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
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PermissionsProvider())],
      child: MaterialApp(
          title: 'Save Me',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: SplashScreen.id,
          debugShowCheckedModeBanner: false,
          routes: {
            SplashScreen.id: (context) => SplashScreen(),
            SignIn.id: (context) => SignIn(),
            RegisterPage.id: (context) => RegisterPage(),

            Navigations.id: (context) => Navigations(),
            MapsPageShortestPath.id: (context) => MapsPageShortestPath(), // shortest path
            MapsSearchScreen.id: (context) => MapsSearchScreen(),
            MapsNearByPlacesScreen.id: (context) => MapsNearByPlacesScreen(),
            AddPostsFromDoctor.id: (context) => AddPostsFromDoctor(),
            DoctorServices.id: (context) => DoctorServices(),
            MyAppointments.id: (context) => MyAppointments(),
            SearchResults.id: (context) => SearchResults(),
          }),
    );
  }
}
