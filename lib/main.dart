import 'package:flutter/material.dart';
import 'package:google_map_test/pages/autocomplete_location_page.dart';

import 'pages/place_autocomplete_page.dart';
import 'pages/places_nearby_page.dart';
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
    return GestureDetector(
      onTap: () {
        debugPrint('FocusScope.of(context).unfocus()');
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                    MaterialPageRoute(builder: (context) => const PlacesNearbyPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                title: 'Place Autocomplete',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return const PlaceAutocompletePage();
                    }),
                  );
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                title: 'Place Autocomplete + Location',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return const AutocompleteLocationPage();
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

