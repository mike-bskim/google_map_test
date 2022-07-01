import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

import '../models/place.dart';
import '../services/google_map_service.dart';

class AutocompleteLocationPage extends StatefulWidget {
  const AutocompleteLocationPage({Key? key}) : super(key: key);

  @override
  AutocompleteLocationPageState createState() =>
      AutocompleteLocationPageState();
}

class AutocompleteLocationPageState extends State<AutocompleteLocationPage> {
  final TextEditingController _searchController = TextEditingController();
  var uuid = const Uuid();
  late String sessionToken;
  var googleMapServices = GoogleMapServices(sessionToken: const Uuid().v4());
  PlaceDetail? placeDetail;
  final Completer<GoogleMapController> _completeController = Completer();
  final Set<Marker> _markers = {};

  // 더미 객체 생성, 지도 초기 위치 설정용
  Position position = Position(
      longitude: 127.1189054,
      latitude: 37.382782,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);
  double distance = 0.0;
  String myAddress = '';

  @override
  void initState() {
    super.initState();
    sessionToken = uuid.v4();
    _checkGPSAvailability();
  }

  void _checkGPSAvailability() async {
// gps 사용 허가 확인
    LocationPermission geolocationStatus = await Geolocator
        .checkPermission(); // Geolocator().checkGeolocationPermissionStatus
    debugPrint('geolocationStatus: [$geolocationStatus]');

    // GeolocationStatus.granted
    if (geolocationStatus == LocationPermission.denied ||
        geolocationStatus == LocationPermission.deniedForever) {
      showDialog(
        // 다이얼로그 밖 영역 클릭시 사라지지 않게 처리
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('GPS 사용 불가'),
            content: const Text('GPS 사용 불가로 앱을 사용할 수 없습니다'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(ctx);
                },
              ),
            ],
          );
        },
      ).then((_) => Navigator.pop(context));
    } else {
      await _getGPSLocation();
      myAddress = await GoogleMapServices.getAddrFromLocation(
          position.latitude, position.longitude);
      _setMyLocation();
      _goToCurrentPosition(position.latitude, position.longitude);
    }
  }

// 현재 내 위치 리턴
  Future<void> _getGPSLocation() async {
    // Geolocator().getCurrentPosition()
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

// 현재 내위치로 지도 이동
  Future<void> _goToCurrentPosition(double lat, double lng) async {
    final GoogleMapController controller = await _completeController.future;
    controller.animateCamera(
      // CameraUpdate.newCameraPosition(
      //     CameraPosition(target: LatLng(lat, lng), zoom: 14)),
      CameraUpdate.newLatLng(LatLng(lat, lng)),
    );
  }

// _markers 에 위치 정보 추가
  void _setMyLocation() {
    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId('myInitPosition'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: '내 위치', snippet: myAddress),
      ));
    });
  }

// 검색 결과를
  void _moveCamera() async {
    if (_markers.isNotEmpty) {
      setState(() {
        _markers.clear();
      });
    }

    // 검색 결과 위치로 이동
    GoogleMapController controller = await _completeController.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(placeDetail!.lat, placeDetail!.lng),
      ),
    );

    // 내 위치의 위도/경도 정보 추출
    await _getGPSLocation();
    // 내 위도/경도를 기반으로 주소명 추출
    myAddress = await GoogleMapServices.getAddrFromLocation(
        position.latitude, position.longitude);

    // 내위치와 검색위치 사이의 거리 계산
    distance = Geolocator.distanceBetween(position.latitude, position.longitude,
        placeDetail!.lat, placeDetail!.lng);

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(placeDetail!.placeId),
          position: LatLng(placeDetail!.lat, placeDetail!.lng),
          infoWindow: InfoWindow(
            title: placeDetail!.name,
            snippet: placeDetail!.formattedAddress,
          ),
        ),
      );
    });
  }

  // 검색결과의 상세 정보 화면 출력
  Widget _showPlaceInfo() {
    if (placeDetail == null) {
      return Container();
    }
    return Column(
      children: <Widget>[
        Card(
          child: ListTile(
            title: Text('내 위치: $myAddress - ${placeDetail!.name}'),
            subtitle: Text('${distance.toStringAsFixed(2)} m'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.branding_watermark),
            title: Text(placeDetail!.name),
            visualDensity: const VisualDensity(vertical: -1),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(placeDetail!.formattedAddress),
            visualDensity: const VisualDensity(vertical: -1),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.phone),
            title: Text(placeDetail!.formattedPhoneNumber),
            visualDensity: const VisualDensity(vertical: -1),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.favorite),
            title: Text('${placeDetail!.rating}'),
            visualDensity: const VisualDensity(vertical: -1),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.place),
            title: Text(placeDetail!.vicinity),
            visualDensity: const VisualDensity(vertical: -1),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.web),
            title: Text(placeDetail!.website),
            visualDensity: const VisualDensity(vertical: -1),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 키보드 숨기기
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Places Autocomplete & distance'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 25.0,
                child: Image.asset('assets/images/powered_by_google.png'),
              ),
              // 검색어와 관련이 높은 검색 결과 표시
              TypeAheadField(
                // 0.5초 동안 입력변화가 없으면 suggestionsCallback 실행
                debounceDuration: const Duration(milliseconds: 500),
                textFieldConfiguration: TextFieldConfiguration(
                  style: const TextStyle(fontSize: 12),
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      border: OutlineInputBorder(),
                      hintText: 'Search places...'),
                ),
                // 검색어(pattern)를 이용하여 유사 결과 제안
                suggestionsCallback: (pattern) async {
                  if (sessionToken.isEmpty) {
                    // == null, isNotEmpty
                    sessionToken = uuid.v4();
                  }

                  googleMapServices =
                      GoogleMapServices(sessionToken: sessionToken);

                  // googleMapServices 을 위에서 선언과 동시에 객체를 할당하지 않으면
                  // getSuggestions 선언 위치를 찾을수 없음(Ctrl+좌클릭), 못찾는 이유는 모르겠음
                  // 객체는 바로위에서 할당을 다시 하므로 동작에는 문제가 없음,
                  return await googleMapServices.getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  // suggestion 의 타입 캐스팅을 해야 객체 변수에 접근 가능
                  var temp = suggestion as Place;
                  return ListTile(
                    title: Text(temp.description),
                    subtitle: Text(temp.name),
                  );
                },
                // suggestion 의 타입 캐스팅을 안하면 아래처럼 직접 캐스팅 후 접근 가능
                onSuggestionSelected: (suggestion) async {
                  placeDetail = await googleMapServices.getPlaceDetail(
                    (suggestion as Place).placeId,
                    sessionToken,
                  );
                  sessionToken = '';
                  _moveCamera();
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 250,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      position.latitude, position.longitude,
                      // 37.382782,
                      // 127.118905,
                    ),
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _completeController.complete(controller);
                  },
                  myLocationEnabled: true,
                  markers: _markers,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(child: SingleChildScrollView(child: _showPlaceInfo())),
            ],
          ),
        ),
      ),
    );
  }
}
