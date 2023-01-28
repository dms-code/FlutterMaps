import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';

// PlaceDetailsPage class that displays detailed information about a selected place
class PlaceDetailsPage extends StatelessWidget {
  
  // Final variable to store the selected place
  final PlacesSearchResult place;

  // Constant variable to store the route name
  static const routeName = '/details';

  const PlaceDetailsPage({super.key,required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: Column(
        children: [ 
         Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          height: 200,
          // List of images generated from the place's photos
          child:  GridView.count(
              crossAxisCount: 3,
              children: List.generate(place.photos.length, (index) {
                return Center(
                  // Image widget to display the place's photo
                  child: Image.network("https://maps.googleapis.com/maps/api/place/photo?photoreference=${place.photos[index].photoReference}&maxwidth=200&key=AIzaSyAzHaMiZrr3u_rinVi28xgpT4KAHLwehVA",height: 150),
                );  
              })),
         ),
         Text(place.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
         const SizedBox(height: 10,),
         Padding(padding: const EdgeInsets.only(left: 10, right: 10), child: Text("Address: ${place.formattedAddress} PriceLevel: ${place.priceLevel ?? 'N/A'}"),)  

      ],),
    );
  }
}
