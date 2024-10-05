// lib/store_details.dart

import 'customization_option.dart'; // Import the CustomizationOption class
import 'menu_item.dart';

class StoreDetails {
  final String storeName;
  final String placeId; // Unique identifier from Google Places
  final double latitude;
  final double longitude;
  final String imagePath; // URL to store image or asset path
  final Map<String, List<MenuItem>> categories;

  StoreDetails({
    required this.storeName,
    this.placeId = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.imagePath = 'assets/defaultstorepic.png',
    required this.categories,
  });

  /// Factory method to create StoreDetails from Google Place JSON response
  factory StoreDetails.fromJson(Map<String, dynamic> json, String apiKey) {
    // Construct the image URL using the first photo reference, if available
    String imageUrl = 'assets/defaultstorepic.png'; // Default image

    if (json['photos'] != null && json['photos'].isNotEmpty) {
      String photoReference = json['photos'][0]['photo_reference'];
      imageUrl =
          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
    }

    // Initialize categories as empty
    Map<String, List<MenuItem>> categories = {};

    // Check the store name and add corresponding menu data
    if (json['name'] != null) {
      if (json['name'] == 'The French Ladle') {
        categories = _getFrenchLadleMenu();
      } else if (json['name'] == 'Taiwan Ichiban SIM') {
        categories = _getMalaXiangGuoMenu();
      } else if (json['name'] == 'Mala Xiang Guo 华新麻辣香锅') {
        categories = _getMalaXiangGuoMenu();
      }
      // Add more stores here as needed
    }

    return StoreDetails(
      storeName: json['name'] ?? 'Unknown Store',
      placeId: json['place_id'] ?? '',
      latitude: json['geometry']['location']['lat']?.toDouble() ?? 0.0,
      longitude: json['geometry']['location']['lng']?.toDouble() ?? 0.0,
      imagePath: imageUrl,
      categories: categories,
    );
  }

  /// Factory method to create StoreDetails from a scanned menu
  factory StoreDetails.fromScannedMenu(
      String storeName, List<MenuItem> menuItems) {
    Map<String, List<MenuItem>> categories = {
      'Menu Items': menuItems,
    };

    return StoreDetails(
      storeName: storeName,
      categories: categories,
    );
  }

  /// Getter to retrieve all menu items across all categories
  List<MenuItem> get allMenuItems {
    List<MenuItem> allItems = [];
    for (var items in categories.values) {
      allItems.addAll(items);
    }
    return allItems;
  }

  /// Private method to provide the menu data for "The French Ladle"
  static Map<String, List<MenuItem>> _getFrenchLadleMenu() {
    return {
      'Appetizers': [
        MenuItem(
          name: 'French Onion Soup',
          price: 8.50,
          category: 'Appetizers',
          imagePath: 'assets/french_ladle/french_onion_soup.jpg',
          customizations: [
            CustomizationOption(
              option: 'No Onions',
              imagePath: 'assets/customizations/no_onions.png',
            ),
            CustomizationOption(
              option: 'Extra Cheese',
              imagePath: 'assets/customizations/extra_cheese.png',
            ),
          ],
        ),
        MenuItem(
          name: 'Escargots',
          price: 12.00,
          category: 'Appetizers',
          imagePath: 'assets/french_ladle/escargots.jpg',
          customizations: [
            CustomizationOption(
              option: 'Less Garlic',
              imagePath: 'assets/customizations/less_garlic.png',
            ),
            CustomizationOption(
              option: 'Extra Butter',
              imagePath: 'assets/customizations/extra_butter.png',
            ),
          ],
        ),
      ],
      'Main Courses': [
        MenuItem(
          name: 'Coq au Vin',
          price: 18.00,
          category: 'Main Courses',
          imagePath: 'assets/french_ladle/coq_au_vin.jpg',
          customizations: [
            CustomizationOption(
              option: 'Extra Wine Sauce',
              imagePath: 'assets/customizations/extra_wine_sauce.png',
            ),
            CustomizationOption(
              option: 'Less Salt',
              imagePath: 'assets/customizations/less_salt.png',
            ),
          ],
        ),
        MenuItem(
          name: 'Beef Bourguignon',
          price: 22.00,
          category: 'Main Courses',
          imagePath: 'assets/french_ladle/beef_bourguignon.jpg',
          customizations: [
            CustomizationOption(
              option: 'Extra Mushrooms',
              imagePath: 'assets/customizations/extra_mushrooms.png',
            ),
            CustomizationOption(
              option: 'No Carrots',
              imagePath: 'assets/customizations/no_carrots.png',
            ),
          ],
        ),
        MenuItem(
          name: 'Ratatouille',
          price: 15.00,
          category: 'Main Courses',
          imagePath: 'assets/french_ladle/ratatouille.jpg',
          customizations: [
            CustomizationOption(
              option: 'Less Oil',
              imagePath: 'assets/customizations/less_oil.png',
            ),
            CustomizationOption(
              option: 'Extra Herbs',
              imagePath: 'assets/customizations/extra_herbs.png',
            ),
          ],
        ),
      ],
      'Desserts': [
        MenuItem(
          name: 'Crème Brûlée',
          price: 7.50,
          category: 'Desserts',
          imagePath: 'assets/french_ladle/creme_brulee.jpg',
          customizations: [
            CustomizationOption(
              option: 'Extra Sugar',
              imagePath: 'assets/customizations/extra_sugar.png',
            ),
            CustomizationOption(
              option: 'No Vanilla',
              imagePath: 'assets/customizations/no_vanilla.png',
            ),
          ],
        ),
        MenuItem(
          name: 'Chocolate Mousse',
          price: 7.00,
          category: 'Desserts',
          imagePath: 'assets/french_ladle/chocolate_mousse.jpg',
          customizations: [
            CustomizationOption(
              option: 'Extra Whipped Cream',
              imagePath: 'assets/customizations/extra_whipped_cream.png',
            ),
            CustomizationOption(
              option: 'Less Sugar',
              imagePath: 'assets/customizations/less_sugar.png',
            ),
          ],
        ),
      ],
      'Beverages': [
        MenuItem(
          name: 'Coffee',
          price: 3.50,
          category: 'Beverages',
          imagePath: 'assets/french_ladle/coffee.jpg',
          customizations: [
            CustomizationOption(
              option: 'Extra Shot',
              imagePath: 'assets/customizations/extra_shot.png',
            ),
            CustomizationOption(
              option: 'No Sugar',
              imagePath: 'assets/customizations/no_sugar.png',
            ),
          ],
        ),
        MenuItem(
          name: 'Red Wine',
          price: 10.00,
          category: 'Beverages',
          imagePath: 'assets/french_ladle/red_wine.jpg',
          customizations: [
            CustomizationOption(
              option: 'Extra Bottle',
              imagePath: 'assets/customizations/extra_bottle.png',
            ),
            CustomizationOption(
              option: 'Less Acid',
              imagePath: 'assets/customizations/less_acid.png',
            ),
          ],
        ),
      ],
    };
  }

  /// Private method to provide the menu data for "Mala Xiang Guo 华新麻辣香锅"
  static Map<String, List<MenuItem>> _getMalaXiangGuoMenu() {
    return {
      'Appetizers': [
        MenuItem(
          name: 'Spicy Cucumber',
          price: 6.00,
          category: 'Appetizers',
          imagePath: 'assets/mala_xiang_guo/spicy_cucumber.jpg',
          customizations: [
            CustomizationOption(
              option: 'Less Chili',
              imagePath: 'assets/customizations/less_chili.png',
            ),
            CustomizationOption(
              option: 'Extra Garlic',
              imagePath: 'assets/customizations/extra_garlic.png',
            ),
          ],
        ),
        MenuItem(
          name: 'Sichuan Dumplings',
          price: 7.50,
          category: 'Appetizers',
          imagePath: 'assets/mala_xiang_guo/sichuan_dumplings.jpg',
          customizations: [
            CustomizationOption(
              option: 'Steamed',
              imagePath: 'assets/customizations/steamed.png',
            ),
            CustomizationOption(
              option: 'Fried',
              imagePath: 'assets/customizations/fried.png',
            ),
          ],
        ),
      ],
      'Main Dishes': [
        MenuItem(
          name: 'Mala Xiang Guo',
          price: 15.00,
          category: 'Main Dishes',
          imagePath: 'assets/mala_xiang_guo/mala_xiang_guo.jpg',
          customizations: [
            CustomizationOption(
              option: 'Extra Noodles',
              imagePath: 'assets/customizations/extra_noodles.png',
            ),
            CustomizationOption(
              option: 'Less Oil',
              imagePath: 'assets/customizations/less_oil.png',
            ),
          ],
        ),
        MenuItem(
          name: 'Beef with Broccoli',
          price: 14.50,
          category: 'Main Dishes',
          imagePath: 'assets/mala_xiang_guo/beef_with_broccoli.jpg',
          customizations: [
            CustomizationOption(
              option: 'Extra Broccoli',
              imagePath: 'assets/customizations/extra_broccoli.png',
            ),
            CustomizationOption(
              option: 'Less Sauce',
              imagePath: 'assets/customizations/less_sauce.png',
            ),
          ],
        ),
        MenuItem(
          name: 'Kung Pao Chicken',
          price: 13.00,
          category: 'Main Dishes',
          imagePath: 'assets/mala_xiang_guo/kung_pao_chicken.jpg',
          customizations: [
            CustomizationOption(
              option: 'Less Peanuts',
              imagePath: 'assets/customizations/less_peanuts.png',
            ),
            CustomizationOption(
              option: 'Extra Vegetables',
              imagePath: 'assets/customizations/extra_vegetables.png',
            ),
          ],
        ),
      ],
      'Sides': [
        MenuItem(
          name: 'Steamed Rice',
          price: 2.50,
          category: 'Sides',
          imagePath: 'assets/mala_xiang_guo/steamed_rice.jpg',
          customizations: [
            CustomizationOption(
              option: 'Brown Rice',
              imagePath: 'assets/customizations/brown_rice.png',
            ),
            CustomizationOption(
              option: 'White Rice',
              imagePath: 'assets/customizations/white_rice.png',
            ),
          ],
        ),
        MenuItem(
          name: 'Fried Rice',
          price: 3.00,
          category: 'Sides',
          imagePath: 'assets/mala_xiang_guo/fried_rice.jpg',
          customizations: [
            CustomizationOption(
              option: 'Extra Egg',
              imagePath: 'assets/customizations/extra_egg.png',
            ),
            CustomizationOption(
              option: 'Less Oil',
              imagePath: 'assets/customizations/less_oil.png',
            ),
          ],
        ),
      ],
      'Desserts': [
        MenuItem(
          name: 'Fortune Cookies',
          price: 2.00,
          category: 'Desserts',
          imagePath: 'assets/mala_xiang_guo/fortune_cookies.jpg',
          customizations: [
            CustomizationOption(
              option: 'No Sugar',
              imagePath: 'assets/customizations/no_sugar.png',
            ),
            CustomizationOption(
              option: 'Extra Crispy',
              imagePath: 'assets/customizations/extra_crispy.png',
            ),
          ],
        ),
        MenuItem(
          name: 'Sweet Tofu',
          price: 3.50,
          category: 'Desserts',
          imagePath: 'assets/mala_xiang_guo/sweet_tofu.jpg',
          customizations: [
            CustomizationOption(
              option: 'Less Sweet',
              imagePath: 'assets/customizations/less_sweet.png',
            ),
            CustomizationOption(
              option: 'Extra Syrup',
              imagePath: 'assets/customizations/extra_syrup.png',
            ),
          ],
        ),
      ],
      'Beverages': [
        MenuItem(
          name: 'Green Tea',
          price: 3.00,
          category: 'Beverages',
          imagePath: 'assets/mala_xiang_guo/green_tea.jpg',
          customizations: [
            CustomizationOption(
              option: 'Less Sugar',
              imagePath: 'assets/customizations/less_sugar.png',
            ),
            CustomizationOption(
              option: 'Extra Ice',
              imagePath: 'assets/customizations/extra_ice.png',
            ),
          ],
        ),
        MenuItem(
          name: 'Soda',
          price: 2.50,
          category: 'Beverages',
          imagePath: 'assets/mala_xiang_guo/soda.jpg',
          customizations: [
            CustomizationOption(
              option: 'Diet',
              imagePath: 'assets/customizations/diet.png',
            ),
            CustomizationOption(
              option: 'No Ice',
              imagePath: 'assets/customizations/no_ice.png',
            ),
          ],
        ),
      ],
    };
  }
}
