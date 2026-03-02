import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'model/user_model.dart';
import 'payment_sucess_screen.dart';
import 'paypal_webview.dart';
import 'controller/payment_controller.dart';

class ConfirmBookingScreen extends StatefulWidget {
  final CarItem car;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final double totalCost;
  final bool collectFromPickup;
  final double pickupCharge;
  final double pickupDistance;
  final String? pickupAddress;

  const ConfirmBookingScreen({
    super.key,
    required this.car,
    required this.startDateTime,
    required this.endDateTime,
    required this.totalCost,
    required this.collectFromPickup,
    required this.pickupCharge,
    required this.pickupDistance,
    this.pickupAddress,
  });

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

enum PaymentMethod { card, paypal }

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  PaymentMethod selectedPaymentMethod = PaymentMethod.paypal;

  Duration get tripDuration =>
      widget.endDateTime.difference(widget.startDateTime);

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    // 🪙 Base Coins (NO TAX HERE)
    final baseCoins = widget.totalCost - widget.pickupCharge;

// 🪙 Pickup Coins (if any)
    final pickupCoins = widget.pickupCharge;

// 💵 Convert Coins → Dollar
    final baseDollar = baseCoins / 10;
    final pickupDollar = pickupCoins / 10;

// 💵 Subtotal in Dollar
    final subTotalDollar = baseDollar + pickupDollar;

// 💵 10% TAX ON DOLLAR (IMPORTANT CHANGE)
    final taxDollar = subTotalDollar * 0.10;

// 💵 Final Dollar Total
    final totalDollar = subTotalDollar + taxDollar;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Confirm Booking",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: _bottomPayButton(totalDollar),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _carDetailsCard(car),

            const SizedBox(height: 20),

            _tripSummaryCard(),

            const SizedBox(height: 24),

            const Text(
              "Payment Method",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _paymentMethodDropdown(),

                const SizedBox(height: 16),

                if (selectedPaymentMethod == PaymentMethod.card)
                  _turoStyleCardForm(),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              "Payment Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            _priceRowCoinsWithDollar("Rental", baseCoins),

            if (widget.collectFromPickup)
              _priceRowCoinsWithDollar("Pickup Charge", pickupCoins),

            _priceRowDollarOnly("Tax (10%)", taxDollar),

            const Divider(height: 24),

            _priceRowDollarOnly("Total", totalDollar, bold: true),
          ],
        ),
      ),
    );
  }

  // ------------------------------
  // CAR CARD
  // ------------------------------

  Widget _carDetailsCard(CarItem car) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              car.picVehicleImage ?? "",
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Image.asset(
                    "assets/images/benz_car.webp",
                    width: 100,
                    height: 100,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "${car.vehicle?.make ?? ''} ${car.vehicle?.model ?? ''}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------
  // TRIP SUMMARY
  // ------------------------------

  Widget _tripSummaryCard() {
    final DateFormat dateFormat = DateFormat("EEE, MMM d");
    final DateFormat timeFormat = DateFormat("hh:mm a");

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green,
            Colors.grey.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 Header
          Row(
            children: const [
              Icon(Icons.directions_car, size: 22),
              SizedBox(width: 8),
              Text(
                "Trip Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// 🔹 Start
          _modernRow(
            icon: Icons.login,
            title: "Start",
            value:
            "${dateFormat.format(widget.startDateTime)} • ${timeFormat.format(widget.startDateTime)}",
          ),

          const SizedBox(height: 14),

          /// 🔹 End
          _modernRow(
            icon: Icons.logout,
            title: "End",
            value:
            "${dateFormat.format(widget.endDateTime)} • ${timeFormat.format(widget.endDateTime)}",
          ),

          const SizedBox(height: 14),

          /// 🔹 Duration
          _modernRow(
            icon: Icons.timer,
            title: "Duration",
            value: _formattedDuration(),
          ),

          if (widget.collectFromPickup) ...[
            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on,
                      color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pickup Location",
                          style: TextStyle(
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${widget.pickupDistance.toStringAsFixed(2)} miles away",
                          style: const TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.pickupAddress ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _modernRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formattedDuration() {
    final duration = tripDuration;

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    List<String> parts = [];

    if (days > 0) parts.add("$days day${days > 1 ? 's' : ''}");
    if (hours > 0) parts.add("$hours hr");
    if (minutes > 0) parts.add("$minutes min");

    return parts.join(" ");
  }


  // ------------------------------
  // PAYMENT METHOD
  // ------------------------------

  Widget _paymentMethodDropdown() {
    return DropdownButtonFormField<PaymentMethod>(
      value: selectedPaymentMethod,
      decoration: InputDecoration(
        labelText: "Select Payment Method",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      items: PaymentMethod.values.map((m) {
        return DropdownMenuItem(
          value: m,
          child: Row(
            children: [
              Icon(
                m == PaymentMethod.card
                    ? Icons.credit_card
                    : Icons.account_balance_wallet,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(m == PaymentMethod.card ? "Card" : "PayPal"),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedPaymentMethod = value!;
        });
      },
    );
  }

  Widget _turoStyleCardForm() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Header
          Row(
            children: const [
              Icon(Icons.lock, size: 18),
              SizedBox(width: 8),
              Text(
                "Secure card payment",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Card Number
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Card number",
              hintText: "1234 5678 9012 3456",
              prefixIcon: const Icon(Icons.credit_card),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),

          const SizedBox(height: 16),

          /// Expiry + CVV
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Expiry",
                    hintText: "MM/YY",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "CVV",
                    hintText: "123",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Card Holder Name
          TextField(
            decoration: InputDecoration(
              labelText: "Cardholder name",
              hintText: "John Doe",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),

          const SizedBox(height: 12),

          /// Small secure note
          Row(
            children: const [
              Icon(Icons.verified, color: Colors.green, size: 16),
              SizedBox(width: 6),
              Text(
                "Your payment is encrypted & secure",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ------------------------------
  // PRICE ROW
  // ------------------------------

  Widget _priceRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------
  // PAY BUTTON
  // ------------------------------

  Widget _bottomPayButton(double totalAmount) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 90,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          if (selectedPaymentMethod == PaymentMethod.paypal) {
            await _handlePayPalPayment(totalAmount);
          }
        },
        child: Text(
          "Pay \$${totalAmount.toStringAsFixed(2)} →",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }


  Widget _priceRowCoinsWithDollar(String label, double coins,
      {bool bold = false}) {
    final dollar = coins / 10;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${coins.toStringAsFixed(0)} Coins",
                style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.w600,
                ),
              ),
              Text(
                "(\$${dollar.toStringAsFixed(2)})",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _priceRowDollarOnly(String label, double dollar,
      {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          Text(
            "\$${dollar.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w700,
              fontSize: bold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------
  // PAYPAL HANDLER
  // ------------------------------

  Future<void> _handlePayPalPayment(double total) async {
    try {
      final response = await PaymentService.createPayPalOrder(
        amount: total,
        carId: widget.car.id,
        userId: 199,
        pickupAddress: widget.pickupAddress ?? "",
        bookedFrom: widget.startDateTime.toUtc().toIso8601String(),
        bookedTill: widget.endDateTime.toUtc().toIso8601String(),
        id: '',
      );

      final orderId = response["id"];
      final approvalUrl =
          response["links"].firstWhere((l) => l["rel"] == "approve")["href"];

      final success = await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => PayPalWebViewScreen(
                approvalUrl: approvalUrl,
                orderId: orderId,
              ),
        ),
      );

      if (success == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const PaymentSuccessScreen(captureResponse: {}),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Payment failed: $e")));
    }
  }
}
