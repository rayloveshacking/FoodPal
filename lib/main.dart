import 'package:flutter/material.dart';
import 'package:foodpal/home.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';  // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // Add this line
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Image to Text Converter GetX',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to FoodPal'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('Go to Home'),
            onPressed: () {
              Get.to(() => Home());
            },
          ),
        ),
      ),
    );
  }
}

