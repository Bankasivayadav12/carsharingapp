import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/booking_controller.dart';

class ReviewScreen extends StatelessWidget {

  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final bookingController = Get.find<BookingController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Review"),
        backgroundColor: const Color(0xFF00A86B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _row("Booking ID",
                bookingController.bookingId.value.toString()),

            _row("Order ID",
                bookingController.orderId.value),

            _row("Car",
                bookingController.carName.value),

            _row("Pickup",
                bookingController.pickupAddress.value),

            _row("Start",
                bookingController.startDate.value?.toString() ?? ""),

            _row("End",
                bookingController.endDate.value?.toString() ?? ""),

            _row("Amount Paid",
                "\$${bookingController.amount.value.toStringAsFixed(2)}"),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text("Back to Home"),
              ),
            )
          ],
        )),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
