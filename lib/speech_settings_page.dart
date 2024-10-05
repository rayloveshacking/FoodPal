// lib/speech_settings_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/tts_controller.dart'; // Import TtsController

class SpeechSettingsPage extends StatelessWidget {
  SpeechSettingsPage({super.key});

  // Access the TtsController
  final TtsController ttsController = Get.find<TtsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Speech Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Adjust Speech Rate',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Obx(() => Slider(
                  value: ttsController.speechRate.value,
                  min: 0.1,
                  max: 1.0,
                  divisions: 9,
                  label: ttsController.speechRate.value.toStringAsFixed(1),
                  onChanged: (double value) {
                    ttsController.updateSpeechRate(value);
                  },
                )),
            const SizedBox(height: 10),
            Obx(() => Text(
                  'Current Speech Rate: ${ttsController.speechRate.value.toStringAsFixed(1)}',
                  style: const TextStyle(fontSize: 16),
                )),
          ],
        ),
      ),
    );
  }
}
