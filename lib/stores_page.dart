// lib/stores_page.dart

import 'package:flutter/material.dart';
import 'store_details.dart'; // Import StoreDetails
import 'menu.dart'; // Import Menu widget
import 'package:get/get.dart';
import 'controllers/selected_items_controllers.dart';
import 'controllers/tts_controller.dart'; // Import TtsController
import 'calculator.dart';
import 'communication_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'services/places_service.dart'; // Import PlacesService

class StoresPage extends StatefulWidget {
  const StoresPage({super.key});

  @override
  _StoresPageState createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  final PlacesService _placesService = PlacesService();

  List<StoreDetails> stores = [];
  bool isLoading = true;
  String errorMessage = '';

  // Access the TtsController
  final TtsController ttsController = Get.find<TtsController>();

  Position? userPosition; // Variable to store user's current position

  @override
  void initState() {
    super.initState();
    _fetchNearbyStores();
  }

  /// Fetches nearby stores using the device's current location and Google Places API.
  Future<void> _fetchNearbyStores() async {
    // Check and request location permissions
    PermissionStatus permission = await Permission.location.status;
    if (!permission.isGranted) {
      permission = await Permission.location.request();
      if (!permission.isGranted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Location permission denied.';
        });
        await ttsController.speakPrompt("location_permission_denied");
        return;
      }
    }

    // Get current location
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      userPosition = position; // Store user's position for distance calculations
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error retrieving location.';
      });
      await ttsController.speakPrompt("error_retrieving_location");
      return;
    }

    // Fetch nearby restaurants using PlacesService
    try {
      List<StoreDetails> fetchedStores = await _placesService
          .fetchNearbyRestaurants(position.latitude, position.longitude);

      // Calculate distance for each store and sort the list
      fetchedStores.sort((a, b) {
        double distanceA = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          a.latitude,
          a.longitude,
        );
        double distanceB = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          b.latitude,
          b.longitude,
        );
        return distanceA.compareTo(distanceB);
      });

      setState(() {
        stores = fetchedStores;
        isLoading = false;
      });

      if (stores.isNotEmpty) {
        await ttsController.speakPrompt(
            'found_nearby_stores',
            params: {'count': stores.length.toString()});
      } else {
        await ttsController.speakPrompt('no_nearby_stores');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching nearby stores.';
      });
      await ttsController.speakPrompt('error_fetching_stores');
    }
  }

  /// Navigates to the Menu page with the selected store details.
  void navigateToStoreMenu(StoreDetails store) async {
    if (store.categories.isNotEmpty) {
      Get.to(() => Menu(store: store));
      await ttsController.speakPrompt(
          'navigating_to_menu',
          params: {'storeName': store.storeName});
    } else {
      await ttsController.speakPrompt(
          'menu_not_available',
          params: {'storeName': store.storeName});
      Get.snackbar(
        "Menu Not Available",
        "Sorry, the menu for ${store.storeName} is not available.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Builds a single store card widget.
  Widget _buildStoreCard(StoreDetails store) {
    double distanceInMeters = userPosition != null
        ? Geolocator.distanceBetween(
            userPosition!.latitude,
            userPosition!.longitude,
            store.latitude,
            store.longitude,
          )
        : 0.0;

    String distanceText;
    if (distanceInMeters >= 1000) {
      distanceText = '${(distanceInMeters / 1000).toStringAsFixed(2)} km';
    } else {
      distanceText = '${distanceInMeters.toStringAsFixed(0)} m';
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => navigateToStoreMenu(store),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Store Image
            SizedBox(
              height: 200,
              child: store.imagePath.startsWith('https://')
                  ? Image.network(
                      store.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/defaultstorepic.png',
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      store.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/defaultstorepic.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            ),
            // Store Name, Distance, and TTS Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      store.storeName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        distanceText,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up, size: 32),
                        onPressed: () =>
                            ttsController.speakText(store.storeName),
                        tooltip: 'Speak ${store.storeName}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the list of store cards or displays appropriate messages.
  Widget _buildStoresList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          errorMessage,
          style: const TextStyle(fontSize: 20, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    } else if (stores.isEmpty) {
      return const Center(
        child: Text(
          'No nearby stores found.',
          style: TextStyle(fontSize: 20),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: stores.length,
        itemBuilder: (context, index) {
          return _buildStoreCard(stores[index]);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nearby Stores',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: _buildStoresList(),
    );
  }
}
