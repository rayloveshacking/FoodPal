// lib/menu.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'menu_item.dart';
import 'order_summary_unpartnered.dart';
import 'controllers/selected_items_controllers.dart';
import 'controllers/tts_controller.dart'; // Import TtsController
import 'package:flutter/foundation.dart';
import 'customization_option.dart'; // Import the CustomizationOption class
import 'store_details.dart';

class Menu extends StatefulWidget {
  final StoreDetails store;

  const Menu({required this.store, super.key});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final SelectedItemsController selectedItemsController =
      Get.find<SelectedItemsController>();
  final TtsController ttsController = Get.find<TtsController>(); // Access TtsController

  @override
  void initState() {
    super.initState();
    // No need to initialize TTS here as it's handled by TtsController
  }

  /// Speaks the given text using TTS.
  Future<void> _speak(String text) async {
    await ttsController.speakText(text);
  }

  /// Adds or removes an item from the order.
  void toggleSelection(SelectedMenuItem selectedItem) {
    if (selectedItemsController.orderSelectedItems.any((item) =>
        item.menuItem.name == selectedItem.menuItem.name &&
        listEquals(item.customizations, selectedItem.customizations))) {
      selectedItemsController.removeItem(selectedItem);
    } else {
      selectedItemsController.addItem(selectedItem);
    }
  }

  /// Navigates to the Order Summary Page with selected items.
  void finishChoosing() {
    if (selectedItemsController.orderSelectedItems.isNotEmpty) {
      // Navigate to Order Summary Page without speaking the summary here
      Get.to(() => const OrderSummaryUnpartnered());
    } else {
      // Speak a prompt indicating no items are selected
      ttsController.speakPrompt("no_items_selected");
      Get.snackbar(
        "No Selection",
        "Please select at least one item to proceed.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Calculates the total price of the selected items.
  double calculateTotalPrice() {
    double total = 0.0;
    for (var selectedItem in selectedItemsController.orderSelectedItems) {
      total += selectedItem.menuItem.price;
    }
    return total;
  }

  /// Opens the customization dialog for the selected menu item.
  Future<void> _customizeItem(MenuItem menuItem) async {
    List<String> selectedCustomizations = [];
    bool noCustomizationsSelected = false;

    // Check if the item is already in the order with no customizations
    bool isAlreadyInOrder = selectedItemsController.orderSelectedItems.any(
      (item) =>
          item.menuItem.name == menuItem.name &&
          listEquals(item.customizations, selectedCustomizations),
    );

    // Retrieve customization options from the menu item
    List<CustomizationOption> availableCustomizations = menuItem.customizations;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Customize ${menuItem.name}"),
          content: StatefulBuilder(builder: (context, setStateDialog) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // "No Customizations" Option
                  GestureDetector(
                    onTap: () {
                      setStateDialog(() {
                        noCustomizationsSelected = !noCustomizationsSelected;
                        if (noCustomizationsSelected) {
                          selectedCustomizations.clear();
                        }
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/customizations/no_customizations.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported,
                              size: 60,
                              color: Colors.grey,
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'No Customizations',
                          style: TextStyle(fontSize: 16),
                        ),
                        Checkbox(
                          value: noCustomizationsSelected,
                          onChanged: (bool? value) {
                            setStateDialog(() {
                              noCustomizationsSelected = value ?? false;
                              if (noCustomizationsSelected) {
                                selectedCustomizations.clear();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Other Customization Options
                  ...availableCustomizations.map((customization) {
                    bool isChecked =
                        selectedCustomizations.contains(customization.option);
                    return Opacity(
                      opacity: noCustomizationsSelected ? 0.5 : 1.0,
                      child: IgnorePointer(
                        ignoring: noCustomizationsSelected,
                        child: GestureDetector(
                          onTap: () {
                            setStateDialog(() {
                              if (isChecked) {
                                selectedCustomizations.remove(customization.option);
                              } else {
                                selectedCustomizations.add(customization.option);
                              }
                            });
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                customization.imagePath,
                                width: 60,
                                height: 60,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                    size: 60,
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              Text(
                                customization.option,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Checkbox(
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setStateDialog(() {
                                    if (value == true) {
                                      selectedCustomizations.add(customization.option);
                                    } else {
                                      selectedCustomizations.remove(customization.option);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  // Remove from Order Button
                  if (isAlreadyInOrder)
                    ElevatedButton.icon(
                      onPressed: () async {
                        SelectedMenuItem itemToRemove = selectedItemsController
                            .orderSelectedItems
                            .firstWhere((item) =>
                                item.menuItem.name == menuItem.name &&
                                listEquals(item.customizations, selectedCustomizations));
                        selectedItemsController.removeItem(itemToRemove);
                        Navigator.of(context).pop(); // Close the dialog
                        await ttsController.speakPrompt(
                          'item_removed',
                          params: {
                            'itemName': menuItem.name,
                          },
                        );
                      },
                      icon: const Icon(Icons.remove_circle, color: Colors.white),
                      label: const Text(
                        'Remove from Order',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                    ),
                ],
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                ttsController.speakPrompt('customization_cancelled'); // Speak cancellation
              },
              child: const Text("Cancel"),
            ),
            if (!isAlreadyInOrder)
              TextButton(
                onPressed: () async {
                  if (noCustomizationsSelected ||
                      selectedCustomizations.isNotEmpty) {
                    // Create a SelectedMenuItem with or without customizations
                    SelectedMenuItem selectedItem = SelectedMenuItem(
                      menuItem: menuItem,
                      customizations: noCustomizationsSelected
                          ? []
                          : selectedCustomizations,
                    );
                    toggleSelection(selectedItem);
                    Navigator.of(context).pop(); // Close the dialog

                    if (noCustomizationsSelected) {
                      await ttsController.speakPrompt(
                        'item_added_no_customizations',
                        params: {
                          'itemName': menuItem.name,
                        },
                      );
                    } else {
                      await ttsController.speakPrompt(
                        'item_added_with_customizations',
                        params: {
                          'itemName': menuItem.name,
                          'customizations': selectedCustomizations.join(', '),
                        },
                      );
                    }
                  } else {
                    // If no customization selected and "No Customizations" not checked
                    await ttsController.speakPrompt('add_phrase_error');
                    Get.snackbar(
                      "No Customization Selected",
                      "Please select at least one customization or choose no customizations.",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: const Text("Add to Order"),
              ),
          ],
        );
      });
    }

    /// Helper method to create customization description
    String customizationDescription(MenuItem menuItem, List<String> customizations) {
      if (customizations.isEmpty) return '';
      return 'customized with ${customizations.join(', ')}';
    }

    /// Builds the menu item card with a "1" badge if selected.
    Widget _buildMenuItemCard(MenuItem item) {
      return GestureDetector(
        onTap: () => _customizeItem(item),
        child: Container(
          width: 160,
          margin: const EdgeInsets.only(right: 16),
          child: Obx(() {
            bool isSelected = selectedItemsController.orderSelectedItems.any(
              (selectedItem) =>
                  selectedItem.menuItem.name == item.name,
            );

            return Stack(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Item Image
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.vertical(top: Radius.circular(16)),
                          child: item.imagePath.startsWith('http')
                              ? Image.network(
                                  item.imagePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/defaultfoodpic.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  item.imagePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/defaultfoodpic.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                        ),
                      ),
                      // Item Name and TTS Button
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(height: 8),
                            // TTS Button
                            IconButton(
                              icon: const Icon(Icons.volume_up),
                              onPressed: () => _speak(item.name),
                              tooltip: 'Speak ${item.name}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // "1" Badge Indicator
                if (isSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        '1',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      final List<MenuItem> menuItems = widget.store.allMenuItems;

      // Organize menu items by category
      Map<String, List<MenuItem>> categorizedMenu = {};
      for (var item in menuItems) {
        if (categorizedMenu.containsKey(item.category)) {
          categorizedMenu[item.category]!.add(item);
        } else {
          categorizedMenu[item.category] = [item];
        }
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Menu',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => finishChoosing(),
              tooltip: 'View Order Summary',
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: categorizedMenu.keys.length,
          itemBuilder: (context, index) {
            String category = categorizedMenu.keys.elementAt(index);
            List<MenuItem> items = categorizedMenu[category]!;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Title
                  Text(
                    category,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Horizontally scrollable list of items
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (context, itemIndex) {
                        final item = items[itemIndex];
                        return _buildMenuItemCard(item);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Obx(() =>
            selectedItemsController.orderSelectedItems.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: finishChoosing,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                        textStyle: const TextStyle(fontSize: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Finish Choosing'),
                    ),
                  )
                : const SizedBox.shrink()),
      );
    }
}
