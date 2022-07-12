import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saveme/webservices/webservices.dart';

import 'maps_utils.dart';

// this class is for showing the nearby places using polylines
class MapsNearByPlacesScreen extends StatefulWidget {
  static const id = 'maps_places';
  final LatLng? nearbyLocation;
  final LatLng? currentLocation;

  const MapsNearByPlacesScreen({this.nearbyLocation, this.currentLocation});

  @override
  State<MapsNearByPlacesScreen> createState() => _MapsNearByPlacesScreenState();
}

class _MapsNearByPlacesScreenState extends State<MapsNearByPlacesScreen> {
  String kGoogleApiKey = "AIzaSyA54WuN4cuPPdhHB5hW-ibaYJGF7ZB_1mE"; // google api keys
  late CameraPosition _initalPosition;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

//**************Variables for nearby place
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
    super.initState();
    _initalPosition = CameraPosition(
        target: LatLng(widget.currentLocation!.latitude, widget.currentLocation!.longitude),
        zoom: 14.4746);
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        kGoogleApiKey,
        // current location
        PointLatLng(widget.currentLocation!.latitude, widget.currentLocation!.longitude),
        // destination location
        PointLatLng(widget.nearbyLocation!.latitude, widget.nearbyLocation!.longitude),
        travelMode: TravelMode.driving);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> _markers = {
      Marker(
        markerId: MarkerId('start'),
        position: LatLng(widget.currentLocation!.latitude, widget.currentLocation!.longitude),
      ),
      Marker(
        markerId: MarkerId('end'),
        position: LatLng(widget.nearbyLocation!.latitude, widget.nearbyLocation!.longitude),
      )
    };

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //     icon: CircleAvatar(
      //       backgroundColor: Colors.white,
      //       child: Icon(
      //         Icons.arrow_back,
      //         color: Colors.black,
      //       ),
      //     ),
      //   ),
      // ),
      body: GoogleMap(
        initialCameraPosition: _initalPosition,
        markers: Set.from(_markers),
        onMapCreated: (GoogleMapController controller) {
          Future.delayed(Duration(milliseconds: 2000), () {
            controller.animateCamera(CameraUpdate.newLatLngBounds(
                MapUtils.boundsFromLatLngList(_markers.map((loc) => loc.position).toList()), 1));
          });
          _getPolyline();
        },
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }
}
