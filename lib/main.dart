// lib/main.dart

import 'package:flutter/material.dart';
import 'package:foodpal/home.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'controllers/selected_items_controllers.dart';
import 'controllers/language_controller.dart'; // Import LanguageController
import 'controllers/tts_controller.dart'; // Import TtsController
import 'package:flutter/services.dart'; // For SystemUiOverlayStyle

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize the Controllers
  Get.put(SelectedItemsController());
  Get.put(LanguageController()); // Initialize LanguageController
  Get.put(TtsController()); // Initialize TtsController

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FoodPal',
      theme: ThemeData(
        primaryColor: const Color(0xFF1E88E5), // Blue
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E88E5),
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E88E5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black, fontSize: 18),
          bodyMedium: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      home: const Home(),
      debugShowCheckedModeBanner: false, // Hides the debug banner
    );
  }
}
