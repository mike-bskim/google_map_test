import 'package:flutter/material.dart';
// import 'package:place_picker/place_picker.dart';
// import 'package:provider/provider.dart';

import 'key.dart';
import 'pages/places_nearby.dart';
import 'widgets/custom_button.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Google Maps Demo',
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomButton(
              title: 'Places Nearby',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PlacesNearby()),
                );
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              title: 'Place Picker',
              onPressed: (){
                debugPrint('Skip function');
              },
              // onPressed: () async {
              //   LocationResult result = await Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => PlacePicker(API_KEY),
              //     ),
              //   );
              //
              //   // Handle the result in your way
              //   debugPrint(result.toString());
              // },
            ),
            const SizedBox(height: 20),
            CustomButton(
              title: 'Place Autocomplete',
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder: (context) {
                //     return PlaceAutocomplete();
                //   }),
                // );
              },
            ),
            // const SizedBox(height: 20),
            // CustomButton(
            //   title: 'Place Autocomplete + Location',
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(builder: (context) {
            //         return AutocompleteLocation();
            //       }),
            //     );
            //   },
            // ),
            // const SizedBox(height: 20),
            // CustomButton(
            //   title: 'Pick a location',
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(builder: (context) {
            //         return ImportantLocations();
            //       }),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}


// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:google_map_test/key.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:http/http.dart' as http;
// import 'package:form_builder_validators/form_builder_validators.dart';
//
// import 'constants/constants.dart';
// import 'models/model_google.dart';
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Flutter Google Maps Demo',
//       home: MapSample(),
//     );
//   }
// }
//
// class MapSample extends StatefulWidget {
//   const MapSample({Key? key}) : super(key: key);
//
//   @override
//   State<MapSample> createState() => MapSampleState();
// }
//
// class MapSampleState extends State<MapSample> {
//   // 다트에서 furture 만드는것임. 추후 다시 설명 예정
//   final Completer<GoogleMapController> _controller = Completer();
//
//   // 5가지, non, normal, satellite, terrain, hybrid 등등.
//   MapType _googleMapType = MapType.normal;
//
//   // 매번 4로 나눠서 나머지 값을 사용
//   int _mapType = 0;
//   final Set<Marker> _markers = {};
//
//   //
//   final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
//
//   @override
//   void initState() {
//     super.initState();
//     _markers.add(
//       const Marker(
//         markerId: MarkerId('myInitPosition'),
//         position: LatLng(37.53609444, 126.9675222),
//         infoWindow: InfoWindow(title: 'My Position', snippet: 'Where am I ?'),
//       ),
//     );
//   }
//
//   final CameraPosition _initCameraPosition = const CameraPosition(
//     target: LatLng(37.53609444, 126.9675222),
//     zoom: 14,
//   );
//
//   void _onMapCreated(GoogleMapController controller) {
//     // 이제 이 콘트롤을 프로그램애서 사용하기 위한 준비 완료.
//     _controller.complete(controller);
//   }
//
//   void _changeMapType() {
//     setState(() {
//       _mapType++;
//       _mapType = _mapType % 4;
//
//       switch (_mapType) {
//         case 0:
//           _googleMapType = MapType.normal;
//           break;
//         case 1:
//           _googleMapType = MapType.satellite;
//           break;
//         case 2:
//           _googleMapType = MapType.terrain;
//           break;
//         case 3:
//           _googleMapType = MapType.hybrid;
//           break;
//         default:
//           _googleMapType = MapType.normal;
//           break;
//       }
//     });
//   }
//
//   void _searchPlaces({
//     required String locationName,
//     required double latitude,
//     required double longitude,
//   }) async {
//     setState(() {
//       _markers.clear();
//     });
//
//     //radius=1000 1km 이내. 언어 한국어,
//     final String url =
//         '$baseUrl?key=$API_KEY&location=$latitude,$longitude&radius=500&language=ko&keyword=$locationName';
//     debugPrint('url: [$url]');
//
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//
//
//       if (data['status'] == 'OK') {
//         GoogleMapController controller = await _controller.future;
//         controller.animateCamera(
//           CameraUpdate.newLatLng(
//             LatLng(latitude, longitude),
//           ),
//         );
//
//         setState(() {
//           final foundPlaces = data['results'];
//           debugPrint(foundPlaces.toString());
//
//           for (int i = 0; i < foundPlaces.length; i++) {
//             ModelGoogle googleResults = ModelGoogle.fromJson(foundPlaces[i]);
//             // debugPrint('store name: [${googleResults.name}]');
//             _markers.add(
//               Marker(
//                 // markerId: MarkerId(foundPlaces[i]['place_id']),
//                 markerId: MarkerId(googleResults.placeId),
//                 position: LatLng(
//                   googleResults.geometry.location.lat,
//                   googleResults.geometry.location.lng,
//                   // foundPlaces[i]['geometry']['location']['lat'],
//                   // foundPlaces[i]['geometry']['location']['lng'],
//                 ),
//                 infoWindow: InfoWindow(
//                   // title: foundPlaces[i]['name'],
//                   // snippet: foundPlaces[i]['vicinity'],
//                   title: googleResults.name,
//                   snippet: googleResults.vicinity,
//                 ),
//               ),
//             );
//           }
//         });
//       }
//     } else {
//       debugPrint('Fail to fetch place data');
//     }
//   }
//
//   void _submit() {
//     if (!_fbKey.currentState!.validate()) {
//       return;
//     }
//
//     _fbKey.currentState!.save();
//     final inputValues = _fbKey.currentState!.value;
//     final id = inputValues['placeId'];
//
//     final foundPlace = places.firstWhere(
//           (place) => place['id'] == id,
//       orElse: () => {}, //'id': 'null', 'placeName': 'null'
//     );
//
//     debugPrint(foundPlace.toString());
//
//     if (foundPlace['placeName'] == null) {
//       Navigator.of(context).pop();
//       return;
//     } else {
//       _searchPlaces(
//         locationName: foundPlace['placeName']!,
//         latitude: 37.53609444,
//         longitude: 126.9675222,
//       ); //37.498295, 127.026437);
//       Navigator.of(context).pop();
//     }
//   }
//
//   void _gotoGangnam() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(15.0),
//           topRight: Radius.circular(15.0),
//         ),
//       ),
//       builder: (context) {
//         return SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     top: 40,
//                     right: 20,
//                     left: 20,
//                     bottom: 20,
//                   ),
//                   child: FormBuilder(
//                     key: _fbKey,
//                     child: Column(
//                       children: <Widget>[
//                         FormBuilderDropdown(
//                           name: 'placeId', // map 의 키값
//                           // attribute: 'placeId',
//                           hint: const Text('어떤 장소를 원하세요?'),
//                           decoration: const InputDecoration(
//                             filled: true,
//                             labelText: '장소',
//                             border: OutlineInputBorder(),
//                           ),
//                           validator: FormBuilderValidators.required(
//                             errorText: '장소 선택은 필수입니다!',
//                           ),
//                           // validators: [
//                           //   FormBuilderValidators.required(
//                           //     errorText: '장소 선택은 필수입니다!',
//                           //   )
//                           // ],
//                           items: places.map<DropdownMenuItem<String>>(
//                             (place) {
//                               return DropdownMenuItem<String>(
//                                 value: place['id'],
//                                 child: Text(place['placeName']!),
//                               );
//                             },
//                           ).toList(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 MaterialButton(
//                   onPressed: _submit,
//                   color: Colors.indigo,
//                   textColor: Colors.white,
//                   child: const Text('Submit'),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           GoogleMap(
//             mapType: _googleMapType,
//             initialCameraPosition: _initCameraPosition,
//             onMapCreated: _onMapCreated,
//             // myLocationEnabled: true,
//             markers: _markers,
//           ),
//           Container(
//             margin: const EdgeInsets.only(top: 60, right: 10),
//             alignment: Alignment.topRight,
//             child: Column(
//               children: <Widget>[
//                 FloatingActionButton.extended(
//                   heroTag: 'btn1',
//                   label: Text('$_googleMapType'),
//                   icon: const Icon(Icons.map),
//                   elevation: 8,
//                   backgroundColor: Colors.red[400],
//                   onPressed: _changeMapType,
//                 ),
//                 const SizedBox(height: 10),
//                 FloatingActionButton.extended(
//                   heroTag: 'btn2',
//                   label: const Text('어디에서 볼까?'),
//                   icon: const Icon(Icons.zoom_out_map),
//                   elevation: 8,
//                   backgroundColor: Colors.blue[400],
//                   onPressed: _gotoGangnam,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
