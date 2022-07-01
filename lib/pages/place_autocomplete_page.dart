import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

import '../models/place.dart';
import '../services/google_map_service.dart';

class PlaceAutocompletePage extends StatefulWidget {
  const PlaceAutocompletePage({Key? key}) : super(key: key);

  @override
  PlaceAutocompletePageState createState() => PlaceAutocompletePageState();
}

class PlaceAutocompletePageState extends State<PlaceAutocompletePage> {
  final TextEditingController _searchController = TextEditingController();
  var uuid = const Uuid();
  // 패키지 버전 및 null safety 업데이트로 인해서 변수 초기화 절차가 달라졌다
  // 몇몇 설정은 오류는 없어도 경고문구가 발생해서 추가한 경우도 있음
  late String sessionToken;
  // googleMapServices, 초기에 선언만하면 나중에 인스턴스를 할당할때 하위함수들을 못찾아서 여기서 할당함.
  // googleMapServices, 선언만 해도 동작하는데 문제가 없음
  var googleMapServices = GoogleMapServices(sessionToken: const Uuid().v4());
  // PlaceDetail?, null 가능하게 처리하여 이후 변수사용시 ! 사용하여 에러처리함
  PlaceDetail? placeDetail;
  final Completer<GoogleMapController> _completeController = Completer();
  final Set<Marker> _markers = {}; //Set();

  @override
  void initState() {
    super.initState();
    // 초기 세션을 미리할때 할당해서 오류 방지
    sessionToken = uuid.v4();
    _markers.add(const Marker(
      markerId: MarkerId('myInitialPosition'),
      position: LatLng(37.382782, 127.1189054),
      infoWindow: InfoWindow(title: 'My Position', snippet: 'Where am I?'),
    ));
  }

// 새로 받은 상세정보를 마커에 추가하고 지도위치도 새로 갱신
  void _moveCamera() async {
    if (_markers.isNotEmpty) {
      setState(() {
        _markers.clear();
      });
    }

    GoogleMapController controller = await _completeController.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(placeDetail!.lat, placeDetail!.lng),
      ),
    );

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

// 상세 정보를 화면에 표시 with 카드 위젯
  Widget _showPlaceInfo() {
    if (placeDetail == null) {
      return Container();
    }
    return Column(
      children: <Widget>[
        Card(
          child: ListTile(
            leading: const Icon(Icons.branding_watermark),
            title: Text(placeDetail!.name),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(placeDetail!.formattedAddress),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.phone),
            title: Text(placeDetail!.formattedPhoneNumber),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.favorite),
            title: Text('${placeDetail!.rating}'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.place),
            title: Text(placeDetail!.vicinity),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.web),
            title: Text(placeDetail!.website),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Places Autocomplete'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 45.0,
                child: Image.asset('assets/images/powered_by_google.png'),
              ),

              // 검색어와 관련이 높은 검색 결과 표시
              TypeAheadField(
                // TypeAheadField, TypeAheadFormField
                // 0.5초 이내 변경은 무시함
                debounceDuration: const Duration(milliseconds: 500),
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Search places...'),
                ),
                // 0.5초 동안 입력변화가 없으면 suggestionsCallback 실행
                // 검색어(pattern)를 이용하여 유사 결과 제안
                suggestionsCallback: (pattern) async {
                  if (sessionToken.isEmpty) { //  == null, isNotEmpty
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
                    title: Text(temp.name),
                    subtitle: Text(temp.description),
                  );
                },
                onSuggestionSelected: (suggestion) async {
                  // suggestion 의 타입 캐스팅을 안하면 아래처럼 직접 캐스팅 후 접근 가능
                  placeDetail = await googleMapServices.getPlaceDetail(
                    (suggestion as Place).placeId,
                    sessionToken,
                  );
                  sessionToken = ''; //null;
                  _moveCamera();
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 350,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(37.382782, 127.1189054),
                    // target: LatLng(placeDetail!.lat, placeDetail!.lng),
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
              _showPlaceInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
