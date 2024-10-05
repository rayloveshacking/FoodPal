// lib/communication_page.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/tts_controller.dart'; // Import TtsController

// Define a data class for communication phrases
class CommunicationPhrase {
  final String phrase;
  final String imagePath;
  final String? promptKey; // Optional promptKey for predefined phrases

  CommunicationPhrase({
    required this.phrase,
    required this.imagePath,
    this.promptKey, // Initialize promptKey
  });

  // Convert a CommunicationPhrase into a Map
  Map<String, dynamic> toMap() {
    return {
      'phrase': phrase,
      'imagePath': imagePath,
      'promptKey': promptKey,
    };
  }

  // Create a CommunicationPhrase from a Map
  factory CommunicationPhrase.fromMap(Map<String, dynamic> map) {
    return CommunicationPhrase(
      phrase: map['phrase'],
      imagePath: map['imagePath'],
      promptKey: map['promptKey'], // Assign promptKey if present
    );
  }
}

class CommunicationPage extends StatefulWidget {
  const CommunicationPage({super.key});

  @override
  _CommunicationPageState createState() => _CommunicationPageState();
}

class _CommunicationPageState extends State<CommunicationPage> {
  final ImagePicker _picker = ImagePicker();

  final TtsController ttsController = Get.find<TtsController>(); // Access TtsController

  // Define a separate list for predefined phrases
  final List<CommunicationPhrase> predefinedPhrases = [
    CommunicationPhrase(
      phrase: 'I would like to order food.',
      imagePath: 'assets/communication/order_food.png',
      promptKey: 'phrase_order_food',
    ),
    CommunicationPhrase(
      phrase: 'Can I have the menu, please?',
      imagePath: 'assets/communication/menu.png',
      promptKey: 'phrase_menu_request',
    ),
    CommunicationPhrase(
      phrase: 'I need assistance.',
      imagePath: 'assets/communication/need_assistance.png',
      promptKey: 'phrase_need_assistance',
    ),
    CommunicationPhrase(
      phrase: 'Where is the restroom?',
      imagePath: 'assets/communication/restroom.png',
      promptKey: 'phrase_restroom_location',
    ),
    CommunicationPhrase(
      phrase: 'Thank you.',
      imagePath: 'assets/communication/thank_you.png',
      promptKey: 'phrase_thank_you',
    ),
    CommunicationPhrase(
      phrase: 'Please call a waiter.',
      imagePath: 'assets/communication/call_waiter.png',
      promptKey: 'phrase_call_waiter',
    ),
    CommunicationPhrase(
      phrase: 'I am ready to pay.',
      imagePath: 'assets/communication/ready_to_pay.png',
      promptKey: 'phrase_ready_to_pay',
    ),
    CommunicationPhrase(
      phrase: 'Excuse me.',
      imagePath: 'assets/communication/excuse_me.png',
      promptKey: 'phrase_excuse_me',
    ),
    CommunicationPhrase(
      phrase: 'Could you repeat that?',
      imagePath: 'assets/communication/repeat_that.png',
      promptKey: 'phrase_repeat',
    ),
    CommunicationPhrase(
      phrase: 'I have a question.',
      imagePath: 'assets/communication/have_question.png',
      promptKey: 'phrase_have_question',
    ),
    CommunicationPhrase(
      phrase: 'I am hungry.',
      imagePath: 'assets/communication/hungry.png',
      promptKey: 'phrase_hungry',
    ),
    CommunicationPhrase(
      phrase: 'I am thirsty.',
      imagePath: 'assets/communication/thirsty.png',
      promptKey: 'phrase_thirsty',
    ),
    CommunicationPhrase(
      phrase: 'How much does this cost?',
      imagePath: 'assets/communication/cost.png',
      promptKey: 'phrase_cost_inquiry',
    ),
    CommunicationPhrase(
      phrase: 'I do not understand.',
      imagePath: 'assets/communication/do_not_understand.png',
      promptKey: 'phrase_do_not_understand',
    ),
    CommunicationPhrase(
      phrase: 'Please help me.',
      imagePath: 'assets/communication/please_help.png',
      promptKey: 'phrase_please_help',
    ),
    CommunicationPhrase(
      phrase: 'Goodbye.',
      imagePath: 'assets/communication/goodbye.png',
      promptKey: 'phrase_goodbye',
    ),
  ];

  List<CommunicationPhrase> communicationPhrases = [];

  @override
  void initState() {
    super.initState();
    communicationPhrases = List.from(predefinedPhrases); // Initialize with predefined
    _loadPhrases();
  }

  Future<void> _loadPhrases() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phrasesJson = prefs.getString('custom_phrases');
    if (phrasesJson != null) {
      List<dynamic> decoded = jsonDecode(phrasesJson);
      List<CommunicationPhrase> customPhrases =
          decoded.map((item) => CommunicationPhrase.fromMap(item)).toList();

      // Filter out any custom phrases that duplicate predefined phrases
      customPhrases = customPhrases.where((customPhrase) {
        return !predefinedPhrases.any((predefined) =>
            predefined.phrase.toLowerCase() ==
            customPhrase.phrase.toLowerCase());
      }).toList();

      setState(() {
        communicationPhrases.addAll(customPhrases);
      });
    }
  }

  Future<void> _savePhrases() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> customPhrases = communicationPhrases
        .skip(predefinedPhrases.length) // Skip predefined
        .map((phrase) => phrase.toMap())
        .toList();
    String encoded = jsonEncode(customPhrases);
    await prefs.setString('custom_phrases', encoded);
  }

  Future<void> _addPhrase() async {
    String newPhrase = '';
    File? newImage;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Add New Phrase"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Phrase'),
                    onChanged: (value) {
                      newPhrase = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final XFile? image = await _picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 80);
                      if (image != null) {
                        setStateDialog(() {
                          newImage = File(image.path);
                        });
                      }
                    },
                    icon: const Icon(Icons.image),
                    label: const Text('Select Image'),
                  ),
                  const SizedBox(height: 10),
                  newImage != null
                      ? Image.file(
                          newImage!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  if (newPhrase.trim().isNotEmpty && newImage != null) {
                    // Check for duplicates in predefined phrases
                    bool isDuplicate = predefinedPhrases.any(
                      (predefined) =>
                          predefined.phrase.toLowerCase() ==
                          newPhrase.trim().toLowerCase(),
                    );

                    if (isDuplicate) {
                      Get.snackbar(
                        "Duplicate Phrase",
                        "This phrase already exists in predefined phrases.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    // Optionally, copy the image to a permanent location
                    // For simplicity, we'll use the image path directly
                    CommunicationPhrase addedPhrase = CommunicationPhrase(
                        phrase: newPhrase.trim(), imagePath: newImage!.path);
                    setState(() {
                      communicationPhrases.add(addedPhrase);
                    });
                    await _savePhrases();
                    Navigator.of(context).pop(); // Close the dialog
                    await ttsController.speakPrompt(
                        'add_phrase_success'); // Speak the success prompt
                    await ttsController.speakText(newPhrase.trim()); // Speak the new phrase
                  } else {
                    // Show an error or do nothing
                    Get.snackbar(
                        "Incomplete Data",
                        "Please enter a phrase and select an image.",
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
                child: const Text("Add"),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _buildPhraseButton(CommunicationPhrase phraseObj) {
    bool isAssetImage = phraseObj.imagePath.startsWith('assets/');

    return ElevatedButton(
      onPressed: () async {
        if (phraseObj.promptKey != null) {
          await ttsController.speakPrompt(phraseObj.promptKey!);
        } else {
          await ttsController.speakText(phraseObj.phrase);
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        backgroundColor: Colors.blueAccent, // Updated from 'primary'
        foregroundColor: Colors.white, // Updated from 'onPrimary'
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          // Display the image
          isAssetImage
              ? Image.asset(
                  phraseObj.imagePath,
                  width: 60, // Increased image size
                  height: 60, // Increased image size
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 60,
                    );
                  },
                )
              : Image.file(
                  File(phraseObj.imagePath),
                  width: 60, // Increased image size
                  height: 60, // Increased image size
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 60,
                    );
                  },
                ),
          const SizedBox(width: 16),
          // Display the phrase
          Expanded(
            child: Text(
              phraseObj.phrase,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePhrase(int index) async {
    if (index < predefinedPhrases.length) return; // Prevent deleting predefined phrases
    setState(() {
      communicationPhrases.removeAt(index);
    });
    await _savePhrases();
    await ttsController.speakPrompt('remove_phrase'); // Speak removal confirmation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Communication Assist',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              bool? confirm = await Get.defaultDialog(
                title: "Clear All Custom Phrases",
                middleText: "Are you sure you want to delete all custom phrases?",
                textCancel: "Cancel",
                textConfirm: "Delete",
                confirmTextColor: Colors.white,
                onConfirm: () {
                  Get.back(result: true);
                },
                onCancel: () {
                  Get.back(result: false);
                },
              );
              if (confirm == true) {
                setState(() {
                  communicationPhrases = List.from(predefinedPhrases);
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('custom_phrases');
                await ttsController.speakPrompt('remove_phrase'); // You might want a different prompt
                Get.snackbar(
                  "Custom Phrases Cleared",
                  "All custom phrases have been deleted.",
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            tooltip: 'Clear All Custom Phrases',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addPhrase,
            tooltip: 'Add New Phrase',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: communicationPhrases.isEmpty
            ? const Center(child: Text('No phrases available.'))
            : ListView.builder(
                itemCount: communicationPhrases.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () async {
                      if (index < predefinedPhrases.length) {
                        Get.snackbar(
                            "Deletion Restricted",
                            "Cannot delete predefined phrases.",
                            snackPosition: SnackPosition.BOTTOM);
                        return;
                      }
                      bool? confirm = await Get.defaultDialog(
                        title: "Delete Phrase",
                        middleText:
                            "Are you sure you want to delete \"${communicationPhrases[index].phrase}\"?",
                        textCancel: "Cancel",
                        textConfirm: "Delete",
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          Get.back(result: true);
                        },
                        onCancel: () {
                          Get.back(result: false);
                        },
                      );
                      if (confirm == true) {
                        await _deletePhrase(index);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child:
                          _buildPhraseButton(communicationPhrases[index]),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
