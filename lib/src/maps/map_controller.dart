import 'package:flutter/material.dart';
import 'package:flutter_maps/src/maps/places_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class MapController with ChangeNotifier {
    MapController();

    final PlacesRepository _placesRepository = PlacesRepository();
    Set<Marker> markers = {};
    
    //Function to create a marker from a place
    Marker createMarkerFromPlace(PlacesSearchResult place, LatLng position, Function(PlacesSearchResult place, LatLng position) markerCallBack) {
      // Return a new Marker with specified properties
      return Marker(
        markerId: MarkerId(place.placeId),
        position: position,
        infoWindow: InfoWindow.noText,
        onTap: () => markerCallBack(place,position),
      );
    }

    // Function to search for a place based on a query
    Future<void> searchPlace(String query, Function(PlacesSearchResult place, LatLng position) markerCallBack) async {

      // Search for the place using the repository
      _placesRepository.searchPlace(query).then((places){

        // If the search returns any results
        if(places.isNotEmpty){
            markers.clear();
            for(PlacesSearchResult place in places){
                if(place.geometry != null && place.geometry?.location != null){
                  // Create a marker for each place and add it to the markers set
                  markers.add(createMarkerFromPlace(place, LatLng(place.geometry!.location.lat, place.geometry!.location.lng), markerCallBack));
                } 
            }
        }
        
        notifyListeners();

      });

    }


  }

  