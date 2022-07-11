import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:saveme/screens/maps/maps_places.dart';

class MapsSearchScreen extends StatefulWidget {
  static const id = 'maps_search_screen';

  @override
  State<MapsSearchScreen> createState() => _MapsSearchScreenState();
}

class _MapsSearchScreenState extends State<MapsSearchScreen> {
  late GooglePlace googlePlace;
  final _startSearchFieldController = TextEditingController();
  final _endSearchFieldController = TextEditingController();
  List<AutocompletePrediction> predictions = []; // create an empty list
  DetailsResult? startPosition;
  DetailsResult? endPosition;
  late FocusNode startFocusNode;
  late FocusNode endFocusNode;
  late LatLng currentLocation;
  late LatLng destinationLocation;
  double? lat;
  double? long;

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double longitudeData = position.longitude;
    double latitudeData = position.latitude;
    setState(() {
      lat = latitudeData;
      long = longitudeData;
      currentLocation = LatLng(position.latitude, position.longitude);
      // destinationLocation = LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
    });
    print(lat);
    print(long);
  }

  @override
  void initState() {
    super.initState();
    String kGoogleApiKey = "AIzaSyA54WuN4cuPPdhHB5hW-ibaYJGF7ZB_1mE"; // google api keys
    googlePlace = GooglePlace(kGoogleApiKey);
    startFocusNode = FocusNode();
    endFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    startFocusNode.dispose();
    endFocusNode.dispose();
  }

// function to search in google places
  void autoCompleteSearch(String value) async {
    var results = await googlePlace.autocomplete.get(value);
    if (results != null && results.predictions != null && mounted) {
      setState(() {
        print(results.predictions!.first.description);
        predictions = results.predictions!; // to make sure it is not null
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TextField(
              controller: _startSearchFieldController,
              autofocus: false,
              focusNode: startFocusNode,
              style: TextStyle(fontSize: 24),
              decoration: InputDecoration(
                  hintText: 'Start Point',
                  hintStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: InputBorder.none),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  autoCompleteSearch(value);
                } else {
                  // clear out the results
                  setState(() {
                    predictions = [];
                    startPosition = null;
                  });
                }
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            TextField(
              controller: _endSearchFieldController,
              autofocus: false,
              focusNode: endFocusNode,
              style: TextStyle(fontSize: 24),
              decoration: InputDecoration(
                  hintText: 'End Point',
                  hintStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: InputBorder.none),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  autoCompleteSearch(value);
                } else {
                  // clear out the results
                  setState(() {
                    predictions = [];
                    endPosition = null;
                  });
                }
              },
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.pin_drop,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(predictions[index].description.toString()),
                    onTap: () async {
                      final placeID = predictions[index].placeId!;
                      final details = await googlePlace.details.get(placeID);
                      if (details != null && details.result != null && mounted) {
                        if (startFocusNode.hasFocus) {
                          setState(() {
                            startPosition = details.result;
                            _startSearchFieldController.text = details.result!.name!;
                            predictions = []; // empty list when done selection
                          });
                        } else {
                          setState(() {
                            endPosition = details.result;
                            _endSearchFieldController.text = details.result!.name!;
                            predictions = []; // empty list when done selection
                          });
                        }
                        if (startPosition != null && endPosition != null) {
                          print("navigate to another screen");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapsPlaces(
                                        startPosition: startPosition,
                                        endPosition: endPosition,
                                      )));
                        }
                      }
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
} // end class
