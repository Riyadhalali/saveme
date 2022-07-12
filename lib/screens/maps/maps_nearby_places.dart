import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saveme/screens/maps/maps_nearby_places_screen.dart';
import 'package:saveme/webservices/webservices.dart';

class NearByPlaceScreen extends StatefulWidget {
  static const id = 'nearby_place_screen';

  @override
  State<NearByPlaceScreen> createState() => _NearByPlaceScreenState();
}

class _NearByPlaceScreenState extends State<NearByPlaceScreen> {
  // late List<NearbyPlacesModel> nearbyList;
  String kGoogleApiKey = "AIzaSyA54WuN4cuPPdhHB5hW-ibaYJGF7ZB_1mE"; // google api keys
  late LatLng currentLocation;
  late LatLng nearbyLocation;
  double? lat;
  double? long;

  void getPlace() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double longitudeData = position.longitude;
    double latitudeData = position.latitude;
    setState(() {
      lat = latitudeData;
      long = longitudeData;
      currentLocation = LatLng(position.latitude, position.longitude);
      // destinationLocation = LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
    });
    // receive it as Map
    Map place = await WebServices.searchNearbyPlacesOnePlace(
        "hospital", latitudeData.toString(), long.toString(), kGoogleApiKey, "1500");
    setState(() {
      nearbyLocation = LatLng(place["lat"], place["lng"]);
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MapsNearByPlacesScreen(
                  currentLocation: currentLocation,
                  nearbyLocation: nearbyLocation,
                )));

    print(place["lat"].toString());
    print(place["lng"].toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPlace();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
