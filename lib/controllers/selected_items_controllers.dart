// lib/controllers/selected_items_controllers.dart

import 'package:get/get.dart';
import '../menu_item.dart';
import 'package:flutter/foundation.dart';

class SelectedItemsController extends GetxController {
  // Observable list of items selected in the Menu page
  var menuSelectedItems = <SelectedMenuItem>[].obs;

  // Observable list of items added to the Order Summary
  var orderSelectedItems = <SelectedMenuItem>[].obs;

  // Method to add an item to both Menu and Order Summary selections
  void addItem(SelectedMenuItem item) {
    menuSelectedItems.add(item);
    orderSelectedItems.add(item);
  }

  // Method to remove an item from both Menu and Order Summary selections
  void removeItem(SelectedMenuItem item) {
    menuSelectedItems.removeWhere((i) =>
        i.menuItem.name == item.menuItem.name &&
        listEquals(i.customizations, item.customizations));
    orderSelectedItems.removeWhere((i) =>
        i.menuItem.name == item.menuItem.name &&
        listEquals(i.customizations, item.customizations));
  }

  // Remove all items with a specific name (regardless of customizations)
  void removeAllItemsByName(String name) {
    menuSelectedItems.removeWhere((item) => item.menuItem.name == name);
    orderSelectedItems.removeWhere((item) => item.menuItem.name == name);
  }

  // Method to clear all items from both lists
  void clearAllItems() {
    menuSelectedItems.clear();
    orderSelectedItems.clear();
  }
}
