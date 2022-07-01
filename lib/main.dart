import 'package:flutter/material.dart';

import 'pages/place_autocomplete.dart';
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
              title: 'Place Autocomplete',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return const PlaceAutocomplete();
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

