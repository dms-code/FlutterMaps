import 'package:google_maps_webservice/places.dart';

// PlacesRepository class that handles the communication with the Google Maps Places API
class PlacesRepository {
  
  // Private variable to store an instance of the GoogleMapsPlaces class
  final _places = GoogleMapsPlaces(apiKey: "AIzaSyAzHaMiZrr3u_rinVi28xgpT4KAHLwehVA");

  // Method to search for places using the Google Maps Places API
  Future<List<PlacesSearchResult>> searchPlace(String query) async {
    // Call the google maps places API to search for places using the given query
    final result = await _places.searchByText(query);
    return result.results;
  }
}