import 'package:carsharingapp/screens/paypal_webview.dart';
import 'package:flutter/material.dart';
import '../controller/payment_controller.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final PaymentController controller = PaymentController();

  String selectedMethod = "";

  final paypalEmail = TextEditingController();
  final cardName = TextEditingController();
  final cardNumber = TextEditingController();
  final cardExpiry = TextEditingController();
  final cardCVV = TextEditingController();

  // --------------------------------------------------------------------------
  // ⭐ START PAYPAL
  // --------------------------------------------------------------------------
  void startPayPalFlow() async {
    String? approvalUrl = await controller.createOrder("32.40");

    if (approvalUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create order")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PayPalWebView(
          url: approvalUrl,
          paymentController: controller,
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // ⭐ PAY NOW LOGIC
  // --------------------------------------------------------------------------
  void onPayNow() {
    if (selectedMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select a payment method")),
      );
      return;
    }

    if (selectedMethod == "paypal") {
      startPayPalFlow();
    }

    if (selectedMethod == "card") {
      if (cardName.text.isEmpty ||
          cardNumber.text.isEmpty ||
          cardExpiry.text.isEmpty ||
          cardCVV.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all card details")),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Card Payment Successful")),
      );
    }
  }

  // --------------------------------------------------------------------------
  // ⭐ PAYMENT OPTION CARD (modern glass UI)
  // --------------------------------------------------------------------------
  Widget paymentOption({
    required String title,
    required IconData icon,
    required String method,
  }) {
    bool active = selectedMethod == method;

    return GestureDetector(
      onTap: () => setState(() => selectedMethod = method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: active
                  ? Colors.black.withOpacity(0.18)
                  : Colors.black.withOpacity(0.06),
              blurRadius: active ? 12 : 8,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: active ? Colors.black : Colors.grey.shade300,
            width: active ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: active ? Colors.black : Colors.grey),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.black : Colors.grey.shade700,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: active ? 1 : 0,
              child: const Icon(Icons.check_circle, color: Colors.green, size: 26),
            )
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // ⭐ BEAUTIFUL TEXT FIELD
  // --------------------------------------------------------------------------
  Widget inputField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // ⭐ PAYPAL FORM
  // --------------------------------------------------------------------------
  Widget paypalForm() {
    return _glassContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "PayPal Email (Optional)",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          inputField("your-email@paypal.com", paypalEmail),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // ⭐ CARD FORM
  // --------------------------------------------------------------------------
  Widget cardForm() {
    return _glassContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Card Payment Details",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),

          inputField("Card Holder Name", cardName),
          const SizedBox(height: 14),

          inputField("Card Number", cardNumber, keyboard: TextInputType.number),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(child: inputField("MM/YY", cardExpiry, keyboard: TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(child: inputField("CVV", cardCVV, keyboard: TextInputType.number)),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // ⭐ GLASS CONTAINER WRAPPER
  // --------------------------------------------------------------------------
  Widget _glassContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // --------------------------------------------------------------------------
  // ⭐ MAIN BUILD
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        title: const Text(
          "Payment Summary",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // ⭐ Payment Methods
            paymentOption(
                title: "PayPal",
                icon: Icons.account_balance_wallet,
                method: "paypal"),
            if (selectedMethod == "paypal") paypalForm(),

            paymentOption(
                title: "Credit / Debit Card",
                icon: Icons.credit_card,
                method: "card"),
            if (selectedMethod == "card") cardForm(),

            const SizedBox(height: 20),

            // ⭐ Pay Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPayNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Pay \$32.40 →",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
