import 'package:flutter/foundation.dart';
import 'customization_option.dart'; // Import the CustomizationOption class

class MenuItem {
  final String name;
  final double price;
  final String category;
  final String imagePath;
  final List<CustomizationOption> customizations; // New field

  MenuItem({
    required this.name,
    required this.price,
    required this.category,
    required this.imagePath,
    this.customizations = const [], // Default to empty list
  });

  // Override == and hashCode for accurate comparisons
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MenuItem &&
        other.name == name &&
        other.price == price &&
        other.category == category &&
        other.imagePath == imagePath &&
        listEquals(other.customizations, customizations);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        price.hashCode ^
        category.hashCode ^
        imagePath.hashCode ^
        customizations.hashCode;
  }
}

/// Represents a selected menu item along with its customization options.
class SelectedMenuItem {
  final MenuItem menuItem;
  final List<String> customizations;

  SelectedMenuItem({
    required this.menuItem,
    required this.customizations,
  });

  // Override == and hashCode for accurate comparisons
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SelectedMenuItem &&
        other.menuItem == menuItem &&
        listEquals(other.customizations, customizations);
  }

  @override
  int get hashCode => menuItem.hashCode ^ customizations.hashCode;
}
