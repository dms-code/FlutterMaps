import 'package:flutter/material.dart';
import 'package:flutter_maps/src/util/infowindow.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

void main() {
  testWidgets('MapInfoWindow displays place information correctly', (tester) async {
    // Create a dummy place object
    final place = PlacesSearchResult(
      name: 'Google',
      formattedAddress: '1600 Amphitheatre Pkwy, Mountain View, CA 94043, United States',
      photos: [], placeId: '', reference: '',
    );

    // Create a dummy screen coordinate
    const screenCoordinate = ScreenCoordinate(x: 100, y: 200);

    // Create a dummy LatLng object
    const position = LatLng(37.4219999,-122.0840575);

    // Create the widget
    final widget = MapInfoWindow(
      place: place,
      screenCoordinate: screenCoordinate,
      position: position,
      onTap: () {},
      displayThumbnail: false,
    );

    // Build the widget and add it to the test tree
    await tester.pumpWidget(MaterialApp(home: Scaffold(
      body: Stack(
        children: [widget],
      )
       
    )));

    // Verify that the place name is displayed correctly
    expect(find.text('Google'), findsOneWidget);

    // Verify that the place address is displayed correctly
    expect(find.text('1600 Amphitheatre Pkwy, Mountain View, CA 94043, United States'), findsOneWidget);

    // Verify that the "Open Details" button is displayed
    expect(find.text('Open Details'), findsOneWidget);

  });
}
