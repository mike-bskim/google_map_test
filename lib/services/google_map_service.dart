import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../key.dart';
import '../models/place.dart';

class GoogleMapServices {
  final String sessionToken;

  GoogleMapServices({required this.sessionToken});

// 검색어 관련 추천 결과를 리턴
  Future<List> getSuggestions(String query) async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = 'establishment';
    String url =
        '$baseUrl?input=$query&key=$googleApiKey&type=$type&language=ko&components=country:kr&sessiontoken=$sessionToken';

    debugPrint('url: $url');
    debugPrint('Autocomplete(sessionToken): $sessionToken');

    final http.Response response = await http.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    final predictions = responseData['predictions'];

    List<Place> suggestions = [];

    for (int i = 0; i < predictions.length; i++) {
      final place = Place.fromJson(predictions[i]);
      suggestions.add(place);
      // debugPrint('${suggestions[i].description}, ${suggestions[i].placeId}');
      // debugPrint('${place.description}, ${place.placeId}');
    }

    return suggestions;
  }

// token 은 sessionToken 값이고, 지명 id 를 전달하여 상세 정보를 리턴
  Future<PlaceDetail> getPlaceDetail(String placeId, String token) async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/details/json';
    String url =
        '$baseUrl?key=$googleApiKey&place_id=$placeId&language=ko&sessiontoken=$token';

    debugPrint('Place Detail(sessionToken): $sessionToken');
    final http.Response response = await http.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    final result = responseData['result'];

    final PlaceDetail placeDetail = PlaceDetail.fromJson(result);
    // debugPrint(placeDetail.toMap().toString());

    return placeDetail;
  }


  static Future<String> getAddrFromLocation(double lat, double lng) async {
    const String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
    String url = '$baseUrl?latlng=$lat,$lng&key=$googleApiKey&language=ko';

    final http.Response response = await http.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    final formattedAddr = responseData['results'][0]['formatted_address'];
    debugPrint(formattedAddr);

    return formattedAddr;
  }

  static String getStaticMap(double latitude, double longitude) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$googleApiKey';
  }
}
