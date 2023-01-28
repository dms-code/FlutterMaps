
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

// This class is a stateful widget that displays an info window on a Google Map, showing information about a specific place
class MapInfoWindow extends StatefulWidget {

  final PlacesSearchResult place; // Place information to be displayed in the info window
  final ScreenCoordinate screenCoordinate; // Coordinates on the screen where the info window should be displayed
  final LatLng position; // Latitude and longitude of the place
  final Function() onTap; // Function to be called when the "Open Details" button is pressed
  final bool displayThumbnail;

  const MapInfoWindow({
    super.key, 
    required this.place, 
    required this.position, 
    required this.screenCoordinate,
    required this.onTap,
    required this.displayThumbnail});

  @override
  State<MapInfoWindow> createState() => _MapInfoWindowState();
}

class _MapInfoWindowState extends State<MapInfoWindow> {
  @override
  Widget build(BuildContext context) {

    var androidDeviceRatio =  MediaQuery.of(context).devicePixelRatio;

    // Calculate the device pixel ratio
    double devicePixelRatio = Platform.isAndroid ? androidDeviceRatio : 1.0;

    // Calculate the position of the info window on the screen
    var markerPopupLeft =(widget.screenCoordinate.x.toDouble() / devicePixelRatio) - 120;
    var markerPopupTop = (widget.screenCoordinate.y.toDouble() / devicePixelRatio) - (50 + 240);

    return Positioned(
      left: markerPopupLeft,
      top: markerPopupTop,
      child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  // If there is a photo available for the place, display it
                  if(widget.displayThumbnail && widget.place.photos.isNotEmpty) 
                    Image.network("https://maps.googleapis.com/maps/api/place/photo?photoreference=${widget.place.photos[0].photoReference}&maxwidth=80&key=AIzaSyAzHaMiZrr3u_rinVi28xgpT4KAHLwehVA",height: 60),
                  const SizedBox(height: 10),
                  Text(widget.place.name, style: const TextStyle(color: Colors.black)),
                  const SizedBox(height: 10),
                  // If the place has a formatted address, display it, otherwise display "N/A"
                  Text(widget.place.formattedAddress ?? "N/A", style: const TextStyle(color: Colors.black,)),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: widget.onTap,child: const Text("Open Details"),)
                ],
              ),
            ),
    );
  }
}