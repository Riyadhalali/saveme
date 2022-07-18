import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saveme/screens/maps/maps_utils.dart';
import 'package:saveme/webservices/webservices.dart';
import 'package:saveme/widgets/mywidgets.dart';

// this class is for showing the nearby places using polylines
class MapsNearByPlacesScreen extends StatefulWidget {
  static const id = 'maps_near_places_screen';
  final String? placetoSearch;
  final String? typetoSearch;

  const MapsNearByPlacesScreen({this.placetoSearch, this.typetoSearch});

  @override
  State<MapsNearByPlacesScreen> createState() => _MapsNearByPlacesScreenState();
}

class _MapsNearByPlacesScreenState extends State<MapsNearByPlacesScreen> {
  String kGoogleApiKey = "AIzaSyA54WuN4cuPPdhHB5hW-ibaYJGF7ZB_1mE"; // google api keys
  late CameraPosition _initalPosition;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  MyWidgets myWidgets = MyWidgets();

//**************Variables for nearby place***************************************
  late LatLng currentLocation;
  late LatLng nearbyLocation;
  double? lat;
  double? long;
  double? nearbyLocationLat;
  double? nearbyLocationLtn;
  String? nearbyPlaceName;

  Future<dynamic> getPlace() async {
    //-> first get location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double longitudeData = position.longitude;
    double latitudeData = position.latitude;
    setState(() {
      lat = latitudeData;
      long = longitudeData;
      currentLocation = LatLng(position.latitude, position.longitude);
      _initalPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude), zoom: 14.4746);
      // destinationLocation = LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
    });
    // receive it as Map from webservices

    try {
      Map place = await WebServices.searchNearbyPlacesOnePlace(
          widget.placetoSearch.toString(),
          latitudeData.toString(),
          long.toString(),
          kGoogleApiKey,
          "500",
          widget.typetoSearch.toString());
      setState(() {
        nearbyLocation = LatLng(place["lat"], place["lng"]);
        nearbyPlaceName = place['name'];
      });
    } on Exception catch (e) {
      myWidgets.displaySnackMessage(e.toString(), context);
    }
  }

  @override
  void initState() {
    super.initState();
    getPlace();
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
        PointLatLng(currentLocation.latitude, currentLocation.longitude),
        // destination location
        PointLatLng(nearbyLocation.latitude, nearbyLocation.longitude),
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
        infoWindow: InfoWindow(title: "موقعك الحالي"),
        markerId: MarkerId('start'),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
      ),
      Marker(
        infoWindow: InfoWindow(title: nearbyPlaceName.toString()),
        markerId: MarkerId('end'),
        position: LatLng(nearbyLocation.latitude, nearbyLocation.longitude),
      )
    };

    return Scaffold(
      body: long == null || lat == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              initialCameraPosition: _initalPosition,
              markers: Set.from(_markers),
              onMapCreated: (GoogleMapController controller) {
                Future.delayed(Duration(milliseconds: 2000), () {
                  controller.animateCamera(CameraUpdate.newLatLngBounds(
                      MapUtils.boundsFromLatLngList(_markers.map((loc) => loc.position).toList()),
                      1));
                });
                _getPolyline();
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }
}
