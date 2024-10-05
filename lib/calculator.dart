// lib/calculator.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/tts_controller.dart'; // Import TtsController
import 'controllers/language_controller.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  final double initialTotal;

  const Calculator({super.key, required this.initialTotal});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  // Access the TtsController
  final TtsController ttsController = Get.find<TtsController>();

  String _expression = '';
  String _result = '';

  @override
  void initState() {
    super.initState();
    // No need to initialize TTS here as it's handled by TtsController
  }

  /// Handles button presses on the calculator.
  Future<void> _onButtonPressed(String value) async {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '';
      } 
      // Removed the redundant _calculateResult() call here
      else if (value == '=') {
        // Do nothing here
      } else {
        _expression += value;
      }
    });

    // Determine the prompt key based on the button pressed
    String promptKey;
    Map<String, String>? params;

    switch (value) {
      case 'C':
        promptKey = 'clear';
        break;
      case 'x':
        promptKey = 'multiply';
        break;
      case '÷':
        promptKey = 'divide';
        break;
      case '=':
        promptKey = 'equals';
        break;
      default:
        promptKey = 'button_pressed';
        params = {'button': value};
        break;
    }

    // Speak the prompt if it's not '='
    if (value != '=') {
      if (params != null) {
        await ttsController.speakPrompt(promptKey, params: params);
      } else {
        await ttsController.speakPrompt(promptKey);
      }
    } else {
      // Speak the 'equals' prompt before calculating the result
      await ttsController.speakPrompt(promptKey);
    }

    // If the button pressed was '=', wait for the result to be spoken
    if (value == '=') {
      await _calculateResult();
    }
  }

  /// Calculates the result of the expression using math_expressions.
  Future<void> _calculateResult() async {
    try {
      // Replace 'x' and '÷' with '*' and '/' for evaluation
      String exp = _expression.replaceAll('x', '*').replaceAll('÷', '/');

      Parser p = Parser();
      Expression expression = p.parse(exp);
      ContextModel cm = ContextModel();
      double eval = expression.evaluate(EvaluationType.REAL, cm);

      setState(() {
        _result = eval.toString();
      });

      // Speak the result
      await ttsController.speakPrompt('result_computed', params: {'result': _result});
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
      await ttsController.speakPrompt('calculation_error');
    }
  }

  /// Builds a calculator button.
  Widget _buildButton(String value, {Color? color, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(value),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.blueGrey,
            padding: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 24,
              color: textColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the calculator UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculator',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Display for the expression
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              child: Text(
                _expression,
                style: const TextStyle(
                    fontSize: 60, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          // Display for the result
          Container(
            alignment: Alignment.bottomRight,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text(
              _result,
              style: const TextStyle(
                  fontSize: 80, fontWeight: FontWeight.bold),
            ),
          ),
          // Calculator buttons
          Column(
            children: [
              Row(
                children: [
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('÷',
                      color: Colors.orange, textColor: Colors.white),
                ],
              ),
              Row(
                children: [
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('x',
                      color: Colors.orange, textColor: Colors.white),
                ],
              ),
              Row(
                children: [
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('-',
                      color: Colors.orange, textColor: Colors.white),
                ],
              ),
              Row(
                children: [
                  _buildButton('C', color: Colors.redAccent),
                  _buildButton('0'),
                  _buildButton('=',
                      color: Colors.green, textColor: Colors.white),
                  _buildButton('+',
                      color: Colors.orange, textColor: Colors.white),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
