// lib/text_output.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'menu_item.dart';
import 'controllers/tts_controller.dart'; // Import TtsController

class TextOutput extends StatefulWidget {
  final Map<String, int> selectedItems;
  final List<MenuItem> menuItems;

  const TextOutput({
    super.key,
    required this.selectedItems,
    required this.menuItems,
  });

  @override
  _TextOutputState createState() => _TextOutputState();
}

class _TextOutputState extends State<TextOutput> {
  bool isProcessingPayment = false;
  bool paymentSuccess = false;
  String orderNumber = '';

  // Access the TtsController
  final TtsController ttsController = Get.find<TtsController>();

  @override
  void initState() {
    super.initState();
    // Optionally, you can initiate any TTS-related setup here if needed
  }

  /// Calculates the total price of the order.
  double calculateTotalPrice() {
    double total = 0.0;
    widget.selectedItems.forEach((itemName, quantity) {
      final menuItem =
          widget.menuItems.firstWhere((item) => item.name == itemName);
      total += menuItem.price * quantity;
    });
    return total;
  }

  /// Builds the order summary widgets.
  List<Widget> buildOrderSummary() {
    List<Widget> summary = [];
    widget.selectedItems.forEach((itemName, quantity) {
      final menuItem =
          widget.menuItems.firstWhere((item) => item.name == itemName);
      summary.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '$quantity x ${menuItem.name} - \$${(menuItem.price * quantity).toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
    return summary;
  }

  /// Handles the payment processing.
  void processPayment() async {
    setState(() {
      isProcessingPayment = true;
    });

    // Speak the initiation of payment processing
    await ttsController.speakPrompt('processing_payment');

    // Simulate payment processing delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate payment success
    setState(() {
      isProcessingPayment = false;
      paymentSuccess = true;
      orderNumber = 'ORD${DateTime.now().millisecondsSinceEpoch}';
    });

    // Speak the payment confirmation
    await ttsController.speakPrompt('payment_confirmed');
  }

  @override
  Widget build(BuildContext context) {
    if (paymentSuccess) {
      // Display order confirmation screen
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Order Confirmed',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Thank you! Your order has been placed.',
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                const Text(
                  'Order Number:',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                Text(
                  orderNumber,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                const Text(
                  'Please show this screen to the stall owner to collect your order.',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    double totalPrice = calculateTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Summary',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: isProcessingPayment
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Processing Payment...',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Your Order:',
                    style: TextStyle(
                      fontSize: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: buildOrderSummary(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Total Amount: \$${totalPrice.toStringAsFixed(2)}',
                    style:
                        const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: processPayment,
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    ),
                    child: const Text(
                      'Confirm Order',
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
