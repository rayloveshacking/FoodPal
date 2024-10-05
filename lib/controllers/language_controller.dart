// lib/controllers/language_controller.dart

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodpal/tts_prompts.dart'; // Import the TtsPrompts

class LanguageController extends GetxController {
  // Observable language code, default is English
  var selectedLanguage = 'en-US'.obs;

  @override
  void onInit() {
    super.onInit();
    loadLanguage();
  }

  // Load saved language from SharedPreferences
  Future<void> loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('selectedLanguage');
    if (lang != null) {
      selectedLanguage.value = lang;
    }
  }

  // Update language and save to SharedPreferences
  Future<void> updateLanguage(String langCode) async {
    selectedLanguage.value = langCode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', langCode);
  }

  // Get human-readable language names
  String getLanguageName(String langCode) {
    switch (langCode) {
      case 'en-US':
        return 'English';
      case 'zh-CN':
        return 'Chinese';
      case 'ms-MY':
        return 'Malay';
      case 'ta-IN':
        return 'Tamil';
      default:
        return 'English';
    }
  }

  /// Retrieves the translated prompt based on the selected language.
  String getPrompt(String promptKey, {Map<String, String>? params}) {
    Map<String, String>? languagePrompts =
        TtsPrompts.prompts[selectedLanguage.value];
    if (languagePrompts != null && languagePrompts.containsKey(promptKey)) {
      String prompt = languagePrompts[promptKey]!;
      if (params != null) {
        params.forEach((key, value) {
          prompt = prompt.replaceAll('{$key}', value);
        });
      }
      return prompt;
    } else {
      // Fallback to English if translation is missing
      return TtsPrompts.prompts['en-US']?[promptKey] ?? 'Prompt not found';
    }
  }
}
