import 'package:flutter/material.dart';
import 'package:flutter_maps/src/maps/map_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

import '../place/place_details_page.dart';
import '../util/infowindow.dart';

// This code defines a MapScreenView widget that displays a Google Map on the screen and allows the user to search for places.
class MapScreenView extends StatefulWidget {
  const MapScreenView({Key? key}) : super(key: key);

  static const routeName = '/maps';

  @override
  State<MapScreenView> createState() => MapScreenViewState();
}

class MapScreenViewState extends State<MapScreenView> {

  final TextEditingController _searchController = TextEditingController();
  late GoogleMapController _googleMapController;
  PlacesSearchResult? _selectedPlace;
  LatLng? _selectedPlacePosition;
  ScreenCoordinate? _selectedPlaceScreenCoordinate;

  final CameraPosition _cameraPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {

    var mapController = Provider.of<MapController>(context, listen: true);

    List<Widget> widgets = [
      // Positioned widget that displays the Google Map
      Positioned(
          child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _cameraPosition,
              onTap: (position) {
                  // resets the selected place when the user taps on the map
                  setState(() {
                    _selectedPlaceScreenCoordinate = null;
                    _selectedPlace = null;
                    _selectedPlacePosition = null;
                  });
              },
              onCameraMove: (position) {
                  // updates the screen coordinate of the selected place
                  if(_selectedPlacePosition != null){
                    _googleMapController.getScreenCoordinate(_selectedPlacePosition!).then((value) {
                      setState(() {
                        _selectedPlaceScreenCoordinate = value;  
                      });
                    });
                  }

              },
              onMapCreated: (GoogleMapController controller) {
                _googleMapController = controller;
              },
              markers: mapController.markers,
          ),
        ),
    ];

    // displays the MapInfoWindow for the selected place
    if(_selectedPlace != null && _selectedPlacePosition!=null && _selectedPlaceScreenCoordinate != null){
         widgets.add(MapInfoWindow(
          displayThumbnail: true,
          place: _selectedPlace!, 
          position: _selectedPlacePosition!, 
          screenCoordinate: _selectedPlaceScreenCoordinate!,
          onTap: () {
            Navigator.pushNamed(context, PlaceDetailsPage.routeName, arguments: _selectedPlace);
          },
         ));
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Search for a place",
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            if(value.isEmpty){
               setState(() {
                  _selectedPlaceScreenCoordinate = null;
                  _selectedPlacePosition = null;
                  _selectedPlace = null;
                });
            }
          },
          onSubmitted: (value){
            if(value.isNotEmpty){
 
              mapController.searchPlace(value, (place, position) async {
                
                _selectedPlaceScreenCoordinate = await _googleMapController.getScreenCoordinate(position);
                _selectedPlacePosition = position;
                _selectedPlace = place;
                setState(() {});
                
              },).then((value) {

                if(mapController.markers.isNotEmpty && _selectedPlacePosition == null){
                  _googleMapController.animateCamera( 
                        CameraUpdate.newCameraPosition(
                              CameraPosition(target: mapController.markers.first.position, zoom: 17)
                        )
                  );

               
              }

              });
            }
          },
        ),
      ),
      body: Stack(
        children: widgets
      )
    );
  }
}