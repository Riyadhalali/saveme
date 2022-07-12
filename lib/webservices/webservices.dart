import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class WebServices {
  static Future<String?> getTimeBetweenDestinations(
      String sourceLong, String sourceLat, String destinationLong, String destinationLat) async {
    String? listData;
    var url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$sourceLat,$sourceLong&destinations=$destinationLat,$destinationLong&key=AIzaSyA54WuN4cuPPdhHB5hW-ibaYJGF7ZB_1mE';
    var data;
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        data = response.body;
        var decodedData = jsonDecode(data); // decoding data
        var distance = decodedData['rows'][0]['elements'][0]['duration']['text'];

        print('time is to get');
        print(distance);
        return distance;
      }
    } catch (e) {
      return listData;
    }
  }

  //--------------------------------------------------------------------------------------------
  // static Future<NearbyPlacesModel> searchNearbyPlaces(
  //     String place, String Lat, String Lng, String apiKey, String raduis) async {
  //   var body;
  //   final NearbyPlacesModel nearbyPlacesModel;
  //   var url =
  //       'https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=$place&location=$Lat%2C$Lng&radius=$raduis&type=hospital|pharmacy|doctor&key=$apiKey';
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       body = response.body;
  //       print(response.body);
  //       var decodedData = jsonDecode(body); // decoding data
  //       nearbyPlacesModel = nearbyPlacesModelFromJson(response.body);
  //       print(nearbyPlacesModel);
  //       return nearbyPlacesModel;
  //     } else {
  //       throw Exception('error 1');
  //     }
  //   } on SocketException {
  //     throw Exception('No Internet connection');
  //   } on TimeoutException {
  //     throw Exception(' time out ');
  //   } on Error catch (e) {
  //     throw Exception('error$e');
  //   }
  // }

  //---------------------------------------------------------------------------------------------
  //-> display the first option
  static Future<Map<String, dynamic>> searchNearbyPlacesOnePlace(
      String place, String Lat, String Lng, String apiKey, String raduis) async {
    var body;
    var placeFound;
    //  final NearbyPlacesModel nearbyPlacesModel;
    var url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=$place&location=$Lat%2C$Lng&radius=$raduis&type=hospital|pharmacy|doctor&key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        body = response.body;
        var decodedData = jsonDecode(body); // decoding data
        var placeFoundLat = decodedData['results'][0]['geometry']['location']['lat'];
        var placeFoundLng = decodedData['results'][0]['geometry']['location']['lng'];
        // var placeLocation = print("place that found is: $placeFoundLat,$placeFoundLng");
        Map<String, dynamic> placeLocation = {"lat": placeFoundLat, "lng": placeFoundLng};
        return placeLocation;
      } else {
        throw Exception('error 1');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } on TimeoutException {
      throw Exception(' time out ');
    } on Error catch (e) {
      throw Exception('error$e');
    }
  }
  //-------------------------------------------------------------------------------------------------
} //end class 1
