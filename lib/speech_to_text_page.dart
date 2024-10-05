// lib/speech_to_text_page.dart

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextPage extends StatefulWidget {
  const SpeechToTextPage({super.key});

  @override
  State<SpeechToTextPage> createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  late stt.SpeechToText _speech;
  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeSpeech();
  }

  /// Initializes the speech recognition.
  Future<void> _initializeSpeech() async {
    _speechEnabled = await _speech.initialize(
      onStatus: _onSpeechStatus,
      onError: _onSpeechError,
    );
    setState(() {});
  }

  /// Starts listening to the user's speech.
  void _startListening() async {
    await _speech.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0.0;
    });
  }

  /// Stops listening to the user's speech.
  void _stopListening() async {
    await _speech.stop();
    setState(() {});
  }

  /// Handles the speech recognition result.
  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.hasConfidenceRating && result.confidence > 0
          ? result.confidence
          : 1.0;
    });
  }

  /// Handles speech recognition status changes.
  void _onSpeechStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      setState(() {
        _speechEnabled = false;
      });
      if (_wordsSpoken.isEmpty) {
        _showSnackBar('No text recognized.');
      }
    }
  }

  /// Handles speech recognition errors.
  void _onSpeechError(error) {
    setState(() {
      _speechEnabled = false;
    });
    _showSnackBar('Speech recognition error: ${error.errorMsg}');
  }

  /// Displays a snackbar with the provided message.
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Speech Recognizer',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _speech.isListening
                    ? "Listening..."
                    : _speechEnabled
                        ? "Tap the microphone to start listening..."
                        : "Speech converted to text:",
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _wordsSpoken.isNotEmpty
                        ? _wordsSpoken
                        : "Your speech will appear here...",
                    style: const TextStyle(
                      fontSize: 30.0, // Increased font size
                      fontWeight: FontWeight.bold, // Made text bold
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Display confidence level
            if (!_speech.isListening && _confidenceLevel > 0)
              Text(
                "Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 80.0, // Adjusted width
        height: 80.0, // Adjusted height
        child: FloatingActionButton(
          onPressed: _speech.isListening ? _stopListening : _startListening,
          tooltip: 'Listen',
          backgroundColor:
              _speech.isListening ? Colors.redAccent : Colors.blueAccent,
          child: Icon(
            _speech.isListening ? Icons.mic_off : Icons.mic,
            size: 40.0, // Increased icon size
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
