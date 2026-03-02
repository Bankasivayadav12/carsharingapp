import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // 🔥 Dummy Booking Data
    final List<Map<String, dynamic>> bookings = [
      {
        "bookingId": 101,
        "orderId": "PAYPAL12345",
        "carName": "Mercedes Benz C-Class",
        "pickup": "Hyderabad",
        "start": DateTime(2026, 2, 10, 10, 0),
        "end": DateTime(2026, 2, 12, 10, 0),
        "amount": 285.34,
      },
      {
        "bookingId": 102,
        "orderId": "PAYPAL56789",
        "carName": "BMW X5",
        "pickup": "Gachibowli",
        "start": DateTime(2026, 1, 20, 9, 0),
        "end": DateTime(2026, 1, 22, 9, 0),
        "amount": 165.00,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking History"),
        backgroundColor: const Color(0xFF00A86B),
      ),
      body: bookings.isEmpty
          ? const Center(
        child: Text(
          "No bookings yet",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {

          final booking = bookings[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Car Name
                Text(
                  booking["carName"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                _row("Booking ID", booking["bookingId"].toString()),
                _row("Order ID", booking["orderId"]),
                _row("Pickup", booking["pickup"]),

                _row(
                  "Start",
                  booking["start"].toString(),
                ),

                _row(
                  "End",
                  booking["end"].toString(),
                ),

                const Divider(height: 20),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "\$${booking["amount"].toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
