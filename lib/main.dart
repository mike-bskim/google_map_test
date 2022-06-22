import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;

import 'constants/constants.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  // 다트에서 furture 만드는것임. 추후 다시 설명 예정
  final Completer<GoogleMapController> _controller = Completer();

  // 5가지, non, normal, satellite, terrain, hybrid 등등.
  MapType _googleMapType = MapType.normal;

  // 매번 4로 나눠서 나머지 값을 사용
  int _mapType = 0;
  Set<Marker> _markers = Set();

  //
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _markers.add(
      const Marker(
        markerId: MarkerId('myInitPosition'),
        position: LatLng(37.53609444, 126.9675222),
        infoWindow: InfoWindow(title: 'My Position', snippet: 'Where am I ?'),
      ),
    );
  }

  final CameraPosition _initCameraPosition = const CameraPosition(
    target: LatLng(37.53609444, 126.9675222),
    zoom: 14,
  );

  void _onMapCreated(GoogleMapController controller) {
    // 이제 이 콘트롤을 프로그램애서 사용중비 완료.
    _controller.complete(controller);
  }

  void _changeMapType() {
    setState(() {
      _mapType++;
      _mapType = _mapType % 4;

      switch (_mapType) {
        case 0:
          _googleMapType = MapType.normal;
          break;
        case 1:
          _googleMapType = MapType.satellite;
          break;
        case 2:
          _googleMapType = MapType.terrain;
          break;
        case 3:
          _googleMapType = MapType.hybrid;
          break;
        default:
          _googleMapType = MapType.normal;
          break;
      }
    });
  }

  void _gotoGangnam() {}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: _googleMapType,
            initialCameraPosition: _initCameraPosition,
            onMapCreated: _onMapCreated,
            // myLocationEnabled: true,
            markers: _markers,
          ),
          Container(
            margin: const EdgeInsets.only(top: 60, right: 10),
            alignment: Alignment.topRight,
            child: Column(
              children: <Widget>[
                FloatingActionButton.extended(
                  heroTag: 'btn1',
                  label: Text('$_googleMapType'),
                  icon: const Icon(Icons.map),
                  elevation: 8,
                  backgroundColor: Colors.red[400],
                  onPressed: _changeMapType,
                ),
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                  heroTag: 'btn2',
                  label: const Text('강남에서 볼까?'),
                  icon: const Icon(Icons.zoom_out_map),
                  elevation: 8,
                  backgroundColor: Colors.blue[400],
                  onPressed: _gotoGangnam,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
