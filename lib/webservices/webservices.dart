import 'dart:convert';

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
} //end class 1
