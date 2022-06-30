import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../key.dart';
import '../models/place.dart';

class GoogleMapServices {
  final String sessionToken;

  GoogleMapServices({required this.sessionToken});

  Future<List> getSuggestions(String query) async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = 'establishment';
    String url =
        '$baseUrl?input=$query&key=$API_KEY&type=$type&language=ko&components=country:kr&sessiontoken=$sessionToken';

    debugPrint('url: $url');
    debugPrint('Autocomplete(sessionToken): $sessionToken');

    final http.Response response = await http.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    final predictions = responseData['predictions'];

    List<Place> suggestions = [];

    for (int i = 0; i < predictions.length; i++) {
      final place = Place.fromJson(predictions[i]);
      suggestions.add(place);
    }

    return suggestions;
  }

  // token 은 세션이 끝날때까지 사용가능
  Future<PlaceDetail> getPlaceDetail(String placeId, String token) async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/details/json';
    String url =
        '$baseUrl?key=$API_KEY&place_id=$placeId&language=ko&sessiontoken=$token';

    debugPrint('Place Detail(sessionToken): $sessionToken');
    final http.Response response = await http.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    final result = responseData['result'];

    final PlaceDetail placeDetail = PlaceDetail.fromJson(result);
    debugPrint(placeDetail.toMap().toString());

    return placeDetail;
  }

  static Future<String> getAddrFromLocation(double lat, double lng) async {
    const String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
    String url = '$baseUrl?latlng=$lat,$lng&key=$API_KEY&language=ko';

    final http.Response response = await http.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    final formattedAddr = responseData['results'][0]['formatted_address'];
    debugPrint(formattedAddr);

    return formattedAddr;
  }

  static String getStaticMap(double latitude, double longitude) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$API_KEY';
  }
}
