// lib/language_settings_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/language_controller.dart';
import 'controllers/tts_controller.dart'; // Import TtsController
import 'speech_settings_page.dart'; // Import SpeechSettingsPage

class LanguageSettingsPage extends StatelessWidget {
  LanguageSettingsPage({super.key});

  // Access the LanguageController
  final LanguageController languageController = Get.find<LanguageController>();

  // Access the TtsController
  final TtsController ttsController = Get.find<TtsController>();

  // Map language codes to their corresponding flag image paths
  final Map<String, String> languageFlags = {
    'en-US': 'assets/flags/en-US.png',
    'zh-CN': 'assets/flags/zh-CN.png',
    'ms-MY': 'assets/flags/ms-MY.png',
    'ta-IN': 'assets/flags/ta-IN.png',
  };

  // Map language codes to their display names
  final Map<String, String> languageNames = {
    'en-US': 'English',
    'zh-CN': 'Chinese',
    'ms-MY': 'Malay',
    'ta-IN': 'Tamil',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Language Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: languageFlags.keys.map((langCode) {
            String langName = languageNames[langCode]!;
            String flagPath = languageFlags[langCode]!;

            bool isSelected = langCode == languageController.selectedLanguage.value;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GestureDetector(
                onTap: () async {
                  if (!isSelected) {
                    await languageController.updateLanguage(langCode);
                    await ttsController.speakPrompt(
                      'language_changed',
                      params: {'langName': langName},
                    );
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  elevation: isSelected ? 6 : 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                    child: Column(
                      children: [
                        // Language Image
                        Image.asset(
                          flagPath,
                          width: 300,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.language,
                              size: 100,
                              color: Colors.grey,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        // Language Name
                        Text(
                          langName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Radio Button
                        Radio<String>(
                          value: langCode,
                          groupValue: languageController.selectedLanguage.value,
                          onChanged: (String? value) async {
                            if (value != null) {
                              await languageController.updateLanguage(value);
                              await ttsController.speakPrompt(
                                'language_changed',
                                params: {'langName': languageNames[value]!},
                              );
                            }
                          },
                          activeColor: Colors.blueAccent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList()
            ..add(
              // Add a button to navigate to Speech Settings
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => SpeechSettingsPage());
                  },
                  icon: const Icon(Icons.settings_voice),
                  label: const Text('Adjust Speech Rate'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
        ),
      ),
    );
  }
}
