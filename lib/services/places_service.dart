// lib/services/places_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../store_details.dart';

class PlacesService {
  // Include your API key directly here
  final String apiKey = ''; //Add your own google places api key here

  /// Fetches nearby restaurants using Google Places API
  Future<List<StoreDetails>> fetchNearbyRestaurants(
      double latitude, double longitude) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=500&type=restaurant&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['results'] != null) {
        List<StoreDetails> stores = [];

        for (var jsonStore in data['results']) {
          stores.add(StoreDetails.fromJson(jsonStore, apiKey));
        }

        return stores;
      } else {
        throw Exception('No results found');
      }
    } else {
      throw Exception('Failed to load nearby restaurants');
    }
  }
}
