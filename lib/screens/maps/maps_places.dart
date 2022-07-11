import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

import 'maps_utils.dart';

class MapsPlaces extends StatefulWidget {
  static const id = 'maps_places';
  final DetailsResult? startPosition;
  final DetailsResult? endPosition;

  const MapsPlaces({this.startPosition, this.endPosition});

  @override
  State<MapsPlaces> createState() => _MapsPlacesState();
}

class _MapsPlacesState extends State<MapsPlaces> {
  String kGoogleApiKey = "AIzaSyA54WuN4cuPPdhHB5hW-ibaYJGF7ZB_1mE"; // google api keys
  late CameraPosition _initalPosition;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  @override
  void initState() {
    super.initState();
    _initalPosition = CameraPosition(
        target: LatLng(widget.startPosition!.geometry!.location!.lat!,
            widget.startPosition!.geometry!.location!.lng!),
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
        PointLatLng(widget.startPosition!.geometry!.location!.lat!,
            widget.startPosition!.geometry!.location!.lng!),
        PointLatLng(widget.endPosition!.geometry!.location!.lat!,
            widget.endPosition!.geometry!.location!.lng!),
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
        position: LatLng(widget.startPosition!.geometry!.location!.lat!,
            widget.startPosition!.geometry!.location!.lng!),
      ),
      Marker(
        markerId: MarkerId('end'),
        position: LatLng(widget.endPosition!.geometry!.location!.lat!,
            widget.endPosition!.geometry!.location!.lng!),
      )
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
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
