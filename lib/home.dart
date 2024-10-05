// lib/home.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'calculator.dart';
import 'communication_page.dart';
import 'controllers/selected_items_controllers.dart';
import 'controllers/language_controller.dart';
import 'controllers/tts_controller.dart'; // Import TtsController
import 'stores_page.dart';
import 'language_settings_page.dart';
import 'speech_to_text_page.dart'; // Import SpeechToTextPage

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? image;
  final ImagePicker imagePicker = ImagePicker();
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  bool isLoading = false;
  String recognizedText = ''; // Store the recognized text

  final LanguageController languageController = Get.find<LanguageController>();
  final TtsController ttsController = Get.find<TtsController>(); // Access TtsController

  @override
  void initState() {
    super.initState();
    // No need to initialize TTS here as it's handled by TtsController
    // Listen for language changes is already handled in TtsController
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile =
          await imagePicker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });
        // Automatically process the image after it's picked
        await performImageLabeling();
      } else {
        await ttsController.speakPrompt('no_image_selected');
      }
    } catch (e) {
      await ttsController.speakPrompt('error_picking_image');
      _showErrorDialog("An error occurred while picking the image.");
      print('Error picking image: $e');
    }
  }

  Future<void> performImageLabeling() async {
    if (image == null) return;
    final inputImage = InputImage.fromFilePath(image!.path);

    setState(() {
      isLoading = true;
      recognizedText = ''; // Reset recognized text
    });

    try {
      final RecognizedText result =
          await textRecognizer.processImage(inputImage);

      setState(() {
        recognizedText = result.text; // Store the recognized text
      });
    } catch (e) {
      // Handle errors appropriately
      await ttsController.speakPrompt('error_processing_image');
      _showErrorDialog("An error occurred while processing the image.");
      print('Error during text recognition: $e');
      return; // Early exit to avoid setting isLoading again
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    if (recognizedText.isNotEmpty) {
      // Read aloud the recognized text without awaiting
      await ttsController.speakText(recognizedText);
    } else {
      await ttsController.speakPrompt('no_text_recognized');
      _showErrorDialog("No text recognized in the image.");
    }
  }

  void navigateToCalculator() async {
    double totalPrice = calculateTotalPrice();
    Get.to(() => Calculator(initialTotal: totalPrice));
    await ttsController.speakPrompt("navigating_to_calculator");
  }

  double calculateTotalPrice() {
    // Access the SelectedItemsController
    final SelectedItemsController controller =
        Get.find<SelectedItemsController>();
    double total = 0.0;
    for (var selectedItem in controller.orderSelectedItems) {
      total += selectedItem.menuItem.price;
    }
    return total;
  }

  void navigateToStores() async {
    Get.to(() => const StoresPage());
    await ttsController.speakPrompt('navigating_to_stores');
  }

  void navigateToGallery() async {
    pickImage(ImageSource.gallery);
    await ttsController.speakPrompt('opening_gallery');
  }

  void navigateToCamera() async {
    pickImage(ImageSource.camera);
    await ttsController.speakPrompt('opening_camera');
  }

  void navigateToCommunication() async {
    Get.to(() => CommunicationPage());
    await ttsController.speakPrompt('opening_communication_assist');
  }

  void navigateToSpeechToText() async {
    Get.to(() => const SpeechToTextPage());
    await ttsController.speakPrompt('navigating_to_speech_to_text');
  }

  void _showErrorDialog(String message) {
    Get.defaultDialog(
      title: "Error",
      middleText: message,
      textConfirm: "OK",
      onConfirm: () {
        Get.back();
      },
    );
  }

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }

  Widget _buildImageButton({
    required VoidCallback onPressed,
    required String imagePath,
    required String label,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(fontSize: 24),
        backgroundColor: Colors.blueAccent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            height: 180,
            width: 180,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.error,
                size: 180,
                color: Colors.red,
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }

  /// Builds the Speech-to-Text button
  Widget _buildSpeechToTextButton() {
    return ElevatedButton(
      onPressed: navigateToSpeechToText,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(fontSize: 24),
        backgroundColor: Colors.green, // Distinct color for differentiation
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.mic,
            size: 180,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Text(
            'Speech Assist',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FoodPal',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.to(() => LanguageSettingsPage());
            },
            tooltip: 'Language Settings',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                // Retain SingleChildScrollView for scrollability
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    _buildImageButton(
                      onPressed: navigateToGallery,
                      imagePath: 'assets/Gallery.png',
                      label: 'Gallery',
                    ),
                    const SizedBox(height: 20),
                    _buildImageButton(
                      onPressed: navigateToCamera,
                      imagePath: 'assets/Camera.png',
                      label: 'Camera',
                    ),
                    const SizedBox(height: 20),
                    _buildImageButton(
                      onPressed: navigateToStores,
                      imagePath: 'assets/Stores.png',
                      label: 'Stores',
                    ),
                    const SizedBox(height: 20),
                    // Calculator Button
                    _buildImageButton(
                      onPressed: navigateToCalculator,
                      imagePath: 'assets/calculator.png',
                      label: 'Calculator',
                    ),
                    const SizedBox(height: 20),
                    // Communication Assist Button
                    _buildImageButton(
                      onPressed: navigateToCommunication,
                      imagePath: 'assets/communication.png', // Ensure this asset exists
                      label: 'Communicate',
                    ),
                    const SizedBox(height: 20),
                    // Speech Assist Button
                    _buildSpeechToTextButton(),
                    const SizedBox(height: 20),
                    if (recognizedText.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Recognized Text:',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (recognizedText.isNotEmpty)
                      Text(
                        recognizedText,
                        style: const TextStyle(fontSize: 20),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
