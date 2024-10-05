// lib/order_summary_unpartnered.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:foodpal/home.dart';
import 'package:foodpal/menu_item.dart';
import 'package:foodpal/calculator.dart';
import 'package:foodpal/communication_page.dart';
import 'package:foodpal/speech_to_text_page.dart'; // Import SpeechToTextPage
import 'controllers/selected_items_controllers.dart';
import 'controllers/tts_controller.dart'; // Import TtsController

class OrderSummaryUnpartnered extends StatefulWidget {
  const OrderSummaryUnpartnered({super.key});

  @override
  _OrderSummaryUnpartneredState createState() =>
      _OrderSummaryUnpartneredState();
}

class _OrderSummaryUnpartneredState extends State<OrderSummaryUnpartnered> {
  bool isAssistingPayment = false;

  // Access the TtsController
  final TtsController ttsController = Get.find<TtsController>();

  // Access the SelectedItemsController
  final SelectedItemsController selectedItemsController =
      Get.find<SelectedItemsController>();

  // Updated list of Singapore denominations in descending order
  final List<double> denominations = [
    100.0,
    10.0,
    5.0,
    2.0,
    1.0,
    0.5,
  ];

  @override
  void initState() {
    super.initState();
    // Trigger reading the order aloud and then provide payment instructions when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await readOrderAloud();
      // Provide instructions for payment assistance
      await ttsController.speakPrompt('payment_assist_instructions');
    });
  }

  /// Calculates the total price of the order.
  double calculateTotalPrice() {
    double total = 0.0;
    for (var selectedItem in selectedItemsController.orderSelectedItems) {
      total += selectedItem.menuItem.price;
    }
    return total;
  }

  /// Calculates the minimal set of notes and coins needed for the amount.
  Map<double, int> calculateNotesAndCoins(double amount) {
    Map<double, int> result = {};
    double remainingAmount = amount;

    for (double denom in denominations) {
      int count = (remainingAmount ~/ denom).toInt();
      if (count > 0) {
        result[denom] = count;
        remainingAmount -= denom * count;
        remainingAmount = double.parse(remainingAmount.toStringAsFixed(2));
      }
    }

    // If there is a remaining amount due to rounding errors, suggest adding an extra 0.5 coin
    if (remainingAmount > 0 && remainingAmount <= 0.5) {
      result[0.5] = (result.containsKey(0.5) ? result[0.5]! + 1 : 1);
    }

    return result;
  }

  /// Builds the order summary widgets, including customizations.
  List<Widget> buildOrderSummary() {
    List<Widget> summary = [];
    for (var selectedItem in selectedItemsController.orderSelectedItems) {
      String customizationDescription = '';
      if (selectedItem.customizations.isNotEmpty) {
        customizationDescription =
            'customized with ${selectedItem.customizations.join(', ')}';
      } else {
        customizationDescription = 'with no customizations';
      }

      summary.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${selectedItem.menuItem.name} $customizationDescription - \$${selectedItem.menuItem.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              // Remove Icon Button
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 24),
                onPressed: () => _removeItem(selectedItem),
                tooltip: 'Remove Item',
              ),
            ],
          ),
        ),
      );
    }
    return summary;
  }

  /// Removes a selected item from the order.
  void _removeItem(SelectedMenuItem item) async {
    selectedItemsController.removeItem(item);
    // Use prompt key for item removal
    await ttsController.speakPrompt(
      'item_removed',
      params: {
        'itemName': item.menuItem.name,
      },
    );
    // No need to call setState() since we're using Obx
  }

  /// Reads aloud the entire order summary to the user.
  Future<void> readOrderAloud() async {
    if (selectedItemsController.orderSelectedItems.isEmpty) {
      await ttsController.speakPrompt("no_items_to_read");
      return;
    }

    await ttsController.speakPrompt('order_summary_intro');

    for (var selectedItem in selectedItemsController.orderSelectedItems) {
      String customizationDescription = '';
      if (selectedItem.customizations.isNotEmpty) {
        customizationDescription =
            'customized with ${selectedItem.customizations.join(', ')}';
      } else {
        customizationDescription = 'with no customizations';
      }

      await ttsController.speakPrompt(
        'order_item',
        params: {
          'itemName': selectedItem.menuItem.name,
          'customizationDescription': customizationDescription,
          'price': selectedItem.menuItem.price.toStringAsFixed(2),
        },
      );
    }

    double totalPrice = calculateTotalPrice();

    await ttsController.speakPrompt(
      'order_total',
      params: {
        'total': totalPrice.toStringAsFixed(2),
      },
    );

    await ttsController.speakPrompt(
      'proceed_to_confirm',
    );
  }

  /// Assists the user with the payment process by providing auditory instructions and interactive learning.
  void assistPayment() async {
    if (selectedItemsController.orderSelectedItems.isEmpty) {
      await ttsController.speakPrompt("payment_assist_no_items");
      Get.snackbar(
        "No Selection",
        "Please select at least one item to proceed.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    double totalPrice = calculateTotalPrice();

    // Start the Payment Assistance Module and await the result
    bool? paymentResult = await Get.to(() => PaymentAssistance(
          totalAmount: totalPrice,
          denominations: denominations,
        ));

    // After returning from PaymentAssistance, check if payment was successful
    if (paymentResult == true) {
      await ttsController.speakPrompt("payment_assist_payment_success");
      // Navigate back to Home or another appropriate screen
      Get.offAll(() => const Home()); // Assuming you have a Home widget
    } else {
      await ttsController.speakPrompt("payment_assist_payment_failure");
    }
  }

  /// Navigates to the Calculator page.
  void navigateToCalculator() async {
    double totalPrice = calculateTotalPrice();
    Get.to(() => Calculator(initialTotal: totalPrice));
    await ttsController.speakPrompt("navigating_to_calculator");
  }

  /// Navigates to the Communication Assist page.
  void navigateToCommunicationAssist() async {
    Get.to(() => CommunicationPage());
    await ttsController.speakPrompt("opening_communication_assist");
  }

  /// Navigates to the Speech-to-Text Assist page.
  void navigateToSpeechToTextAssist() async {
    Get.to(() => const SpeechToTextPage());
    await ttsController.speakPrompt('navigating_to_speech_to_text');
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = calculateTotalPrice();

    // Calculate the notes and coins required
    Map<double, int> notesAndCoins = calculateNotesAndCoins(totalPrice);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Summary',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(
        () => selectedItemsController.orderSelectedItems.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Order Review Text
                    Text(
                      'Please review your order below.',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    // Expanded widget with SingleChildScrollView to prevent overflow
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Order Items Summary
                            ...buildOrderSummary(),
                            const SizedBox(height: 10),
                            // Total Amount
                            Text(
                              'Total Amount: \$${totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            // Display Notes and Coins
                            const Text(
                              'You can pay with:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.center,
                              children: notesAndCoins.entries.map((entry) {
                                double denomination = entry.key;
                                int count = entry.value;
                                return Column(
                                  children: [
                                    // Quantity Text Above the Image
                                    Text(
                                      'x$count',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Image.asset(
                                      'assets/currency/${denomination.toStringAsFixed(2)}.png',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.money,
                                          size: 60,
                                          color: Colors.green,
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                            // Use Calculator Button
                            ElevatedButton.icon(
                              onPressed: navigateToCalculator,
                              icon: const Icon(Icons.calculate, size: 24),
                              label: const Text(
                                'Use Calculator',
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Assist Order Button
                            ElevatedButton.icon(
                              onPressed: navigateToCommunicationAssist,
                              icon: const Icon(Icons.assistant, size: 24),
                              label: const Text(
                                'Assist Order',
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Speech Assist Button
                            ElevatedButton.icon(
                              onPressed: navigateToSpeechToTextAssist,
                              icon: const Icon(Icons.mic, size: 24),
                              label: const Text(
                                'Speech Assist',
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Colors.green, // Distinct color
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Read Order Button
                            ElevatedButton.icon(
                              onPressed: readOrderAloud,
                              icon: const Icon(Icons.volume_up, size: 24),
                              label: const Text(
                                'Read Order',
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Final Instruction Text
                    const Text(
                      'Please show this screen to the cashier to place your order.',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : const Center(
                child: Text(
                  'No items in your order.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
      ),
      bottomNavigationBar: Obx(() {
        return selectedItemsController.orderSelectedItems.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: assistPayment,
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor:
                        Colors.orangeAccent, // Changed to backgroundColor
                  ),
                  child: const Text('Assist Payment'),
                ),
              )
            : const SizedBox.shrink();
      }),
    );
  }
}

/// Payment Assistance Module Widget
class PaymentAssistance extends StatefulWidget {
  final double totalAmount;
  final List<double> denominations;

  const PaymentAssistance({
    super.key,
    required this.totalAmount,
    required this.denominations,
  });

  @override
  _PaymentAssistanceState createState() => _PaymentAssistanceState();
}

class _PaymentAssistanceState extends State<PaymentAssistance> {
  double remainingAmount = 0.0;
  Map<double, int> selectedDenominations = {};
  double totalSelectedAmount = 0.0;
  double changeDue = 0.0;

  // Access the TtsController
  final TtsController ttsController = Get.find<TtsController>();

  @override
  void initState() {
    super.initState();
    remainingAmount = widget.totalAmount;
    totalSelectedAmount = 0.0;
    changeDue = 0.0;
    _startTutorial();
  }

  /// Starts the payment assistance tutorial.
  Future<void> _startTutorial() async {
    await ttsController.speakPrompt('intro_payment_assist');

    await ttsController.speakPrompt(
      'step1_payment_assist',
      params: {
        'amount': widget.totalAmount.toStringAsFixed(2),
      },
    );

    await ttsController.speakPrompt('step2_payment_assist');

    await ttsController.speakPrompt('step3_payment_assist');

    await ttsController.speakPrompt('step4_payment_assist');

    await ttsController.speakPrompt('encouragement_payment_assist');
  }

  /// Handles denomination selection.
  void _selectDenomination(double denomination) async {
    setState(() {
      selectedDenominations[denomination] =
          (selectedDenominations[denomination] ?? 0) + 1;
      totalSelectedAmount += denomination;
      totalSelectedAmount =
          double.parse(totalSelectedAmount.toStringAsFixed(2));
      remainingAmount = widget.totalAmount - totalSelectedAmount;
      remainingAmount = double.parse(remainingAmount.toStringAsFixed(2));

      if (remainingAmount <= 0) {
        changeDue = -remainingAmount;
        remainingAmount = 0.0;
      } else {
        changeDue = 0.0;
      }
    });

    await ttsController.speakPrompt(
      'selected_denomination',
      params: {
        'denomination': denomination.toStringAsFixed(2),
      },
    );
  }

  /// Handles payment confirmation.
  Future<void> _confirmPayment() async {
    if (totalSelectedAmount < widget.totalAmount) {
      await ttsController.speakPrompt(
        'insufficient_payment',
        params: {
          'remainingAmount':
              (widget.totalAmount - totalSelectedAmount).toStringAsFixed(2),
        },
      );
      return;
    }

    await ttsController.speakPrompt(
      'confirm_payment_success',
      params: {
        'changeDue': changeDue.toStringAsFixed(2),
      },
    );
    // Show the congratulatory popup
    await _showCongratulationsPopup();
    // Clear the order
    Get.find<SelectedItemsController>().clearAllItems();
    // Navigate back with success result
    Get.back(result: true);
  }

  /// Resets the payment selections.
  Future<void> _resetPayment() async {
    setState(() {
      selectedDenominations.clear();
      remainingAmount = widget.totalAmount;
      totalSelectedAmount = 0.0;
      changeDue = 0.0;
    });
    await ttsController.speakPrompt('payment_assist_reset');
  }

  /// Speaks out the change due to the user.
  Future<void> _speakChangeDue() async {
    if (changeDue > 0) {
      await ttsController.speakPrompt(
        'speak_changes_due',
        params: {
          'changeDue': changeDue.toStringAsFixed(2),
        },
      );
    }
  }

  /// Shows a congratulatory popup with a GIF animation and "Congratulations!" text.
  Future<void> _showCongratulationsPopup() async {
    await showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing the dialog by tapping outside
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // GIF Animation
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/congratulations.gif', // Ensure this path is correct
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.sentiment_very_satisfied,
                        size: 100,
                        color: Colors.green,
                      );
                    },
                  ),
                  // Positioned Close Button
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        // Treat closing the popup as successful payment
                        Get.back(result: true); // Indicate success
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // "Congratulations!" Text
              const Text(
                'Congratulations!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  /// Builds the denomination buttons.
  Widget _buildDenominationButton(double denomination) {
    return GestureDetector(
      onTap: () => _selectDenomination(denomination),
      child: Column(
        children: [
          Image.asset(
            'assets/currency/${denomination.toStringAsFixed(2)}.png',
            width: 80,
            height: 80,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.money,
                size: 60,
                color: Colors.green,
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            '\$${denomination.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Builds the list of selected denominations.
  Widget _buildSelectedDenominations() {
    if (selectedDenominations.isEmpty) {
      return const Text(
        'No denominations selected.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      );
    }

    List<Widget> selectedList = [];
    selectedDenominations.forEach((denomination, count) {
      selectedList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/currency/${denomination.toStringAsFixed(2)}.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.money,
                  size: 30,
                  color: Colors.green,
                );
              },
            ),
            const SizedBox(width: 4),
            Text(
              'x$count',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    });

    return Column(
      children: selectedList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Assistance',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Total Amount
            Text(
              'Total Amount: \$${widget.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Total Selected Amount
            Text(
              'Total Selected: \$${totalSelectedAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // Remaining Amount or Change Due with Voice Icon
            if (remainingAmount > 0)
              Text(
                'Remaining Amount: \$${remainingAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, color: Colors.redAccent),
              )
            else if (changeDue > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Change Due: \$${changeDue.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  const SizedBox(width: 8),
                  // Voice Icon Button
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.green),
                    onPressed: _speakChangeDue,
                    tooltip: 'Speak Change Due',
                  ),
                ],
              ),
            const SizedBox(height: 10),
            // Selected Denominations
            const Text(
              'Selected Denominations:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            _buildSelectedDenominations(),
            const SizedBox(height: 20),
            // Denomination Selection Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1,
                children: widget.denominations
                    .map((denomination) =>
                        _buildDenominationButton(denomination))
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),
            // Payment Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _confirmPayment,
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Confirm Payment',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: _resetPayment,
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
