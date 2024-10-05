// lib/controllers/tts_controller.dart

import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'language_controller.dart';

class TtsController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final LanguageController languageController = Get.find<LanguageController>();

  bool isInitialized = false;

  // Queue to hold speech prompts
  final List<String> _speechQueue = [];

  // Flag to indicate if TTS is currently speaking
  bool _isSpeaking = false;

  // Reactive speechRate variable with default value
  RxDouble speechRate = 0.5.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSpeechRate().then((_) {
      _initTts();
    });

    // Listen for language changes
    ever(languageController.selectedLanguage, (_) {
      _updateTtsLanguage();
    });

    // Listen for TTS completion events
    flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      _processQueue();
    });

    // Listen for TTS error events
    flutterTts.setErrorHandler((msg) {
      print("TTS Error: $msg");
      _isSpeaking = false;
      _processQueue();
    });

    // Listen for speechRate changes and update FlutterTts accordingly
    ever(speechRate, (_) {
      if (isInitialized) {
        flutterTts.setSpeechRate(speechRate.value);
      }
    });
  }

  /// Loads the saved speech rate from SharedPreferences
  Future<void> _loadSpeechRate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double savedRate = prefs.getDouble('speechRate') ?? 0.5; // Default to 0.5
    speechRate.value = savedRate;
  }

  /// Saves the current speech rate to SharedPreferences
  Future<void> _saveSpeechRate(double rate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('speechRate', rate);
  }

  /// Initializes the TTS engine with current speech rate.
  Future<void> _initTts() async {
    await _updateTtsLanguage();

    await flutterTts.setSpeechRate(speechRate.value);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    isInitialized = true;
    update();
  }

  /// Updates the TTS language based on the selected language.
  Future<void> _updateTtsLanguage() async {
    String lang = languageController.selectedLanguage.value;
    var result = await flutterTts.setLanguage(lang);
    if (result == 1 || result == '1') {
      print("TTS language set to $lang");
    } else {
      print("Failed to set TTS language to $lang. Falling back to English.");
      await flutterTts.setLanguage('en-US');
      languageController.updateLanguage('en-US');
      Get.snackbar(
        "Language Unsupported",
        "${languageController.getLanguageName(lang)} is not supported on your device. Reverting to English.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Enqueues the given prompt key with optional dynamic parameters.
  Future<void> enqueuePrompt(String promptKey, {Map<String, String>? params}) async {
    if (!isInitialized) return;
    String prompt = languageController.getPrompt(promptKey, params: params);
    _speechQueue.add(prompt);
    _processQueue();
  }

  /// Enqueues arbitrary text.
  Future<void> enqueueText(String text) async {
    if (!isInitialized) return;
    _speechQueue.add(text);
    _processQueue();
  }

  /// Processes the speech queue.
  void _processQueue() async {
    if (_isSpeaking || _speechQueue.isEmpty) {
      return;
    }

    _isSpeaking = true;
    String nextSpeech = _speechQueue.removeAt(0);
    await flutterTts.speak(nextSpeech);
  }

  /// Speaks the given prompt key with optional dynamic parameters.
  Future<void> speakPrompt(String promptKey, {Map<String, String>? params}) async {
    await enqueuePrompt(promptKey, params: params);
  }

  /// Speaks arbitrary text.
  Future<void> speakText(String text) async {
    await enqueueText(text);
  }

  /// Updates the speech rate and persists the new value.
  Future<void> updateSpeechRate(double newRate) async {
    // Ensure the newRate is within a reasonable range
    if (newRate < 0.1) newRate = 0.1;
    if (newRate > 1.0) newRate = 1.0;

    speechRate.value = newRate;
    await _saveSpeechRate(newRate);
    // The 'ever' listener will automatically update the FlutterTts speech rate
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
