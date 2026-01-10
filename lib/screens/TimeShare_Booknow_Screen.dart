import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class TimeShare_BookNowScreen extends StatefulWidget {
  final Map<String, dynamic> car;

  const TimeShare_BookNowScreen({super.key, required this.car});

  @override
  State<TimeShare_BookNowScreen> createState() => _TimeShare_BookNowScreenState();
}

class _TimeShare_BookNowScreenState extends State<TimeShare_BookNowScreen> {
  DateTime? pickupTime;
  DateTime? dropTime;
  int waitingTime = 0;

  // Format time
  String format(DateTime? time) =>
      time == null ? "--:--" : DateFormat("hh:mm a").format(time);

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Book ${car["name"]}"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ------------------ CAR IMAGE ------------------
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                car["img"],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 18),

            // ------------------ CAR TITLE ------------------
            Text(
              car["name"],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Icon(Icons.star, size: 18, color: Colors.orange.shade700),
                const SizedBox(width: 4),
                Text("${car["rating"]} Rating • ${car["type"]}"),
              ],
            ),

            const SizedBox(height: 25),

            // -------------------------------------------------------
            // 📍 PICKUP TIME
            // -------------------------------------------------------
            _title("Pickup Time"),

            _selectorTile(
              label: format(pickupTime),
              icon: Icons.access_time,
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  final now = DateTime.now();
                  setState(() {
                    pickupTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      picked.hour,
                      picked.minute,
                    );
                  });
                }
              },
            ),

            const SizedBox(height: 18),

            // -------------------------------------------------------
            // 📍 DROP TIME
            // -------------------------------------------------------
            _title("Drop Time"),

            _selectorTile(
              label: format(dropTime),
              icon: Icons.timelapse,
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  final now = DateTime.now();
                  setState(() {
                    dropTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      picked.hour,
                      picked.minute,
                    );
                  });
                }
              },
            ),

            const SizedBox(height: 18),

            // -------------------------------------------------------
            // 🕒 WAITING TIME
            // -------------------------------------------------------
            _title("Waiting Time (minutes)"),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.timer, color: Colors.black54),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Slider(
                      value: waitingTime.toDouble(),
                      min: 0,
                      max: 60,
                      divisions: 6,
                      thumbColor: Colors.black,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        setState(() {
                          waitingTime = value.toInt();
                        });
                      },
                    ),
                  ),
                  Text("$waitingTime min"),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // -------------------------------------------------------
            // 💰 TOTAL PRICE CALCULATION
            // -------------------------------------------------------
            _title("Estimated Cost"),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade100,
              ),
              child: Column(
                children: [
                  _priceRow("Price per Hour", "\$${car["price"]}"),
                  const SizedBox(height: 6),
                  _priceRow("Waiting Charges", "\$${(waitingTime * 0.2).toStringAsFixed(1)}"),
                  const Divider(),
                  _priceRow(
                    "Total Estimate",
                    "\$${_calculateTotal(car["price"])}",
                    isBold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // -------------------------------------------------------
            // 🚗 CONFIRM BOOKING BUTTON
            // -------------------------------------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Confirm Booking",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // 🔧 REUSABLE WIDGETS
  // =============================================================

  Widget _selectorTile({required String label, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _title(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // 🔥 Calculate Price
  String _calculateTotal(int pricePerHour) {
    if (pickupTime == null || dropTime == null) return "0";

    final diff = dropTime!.difference(pickupTime!).inHours;
    final baseCost = diff * pricePerHour;
    final waitingCost = waitingTime * 0.2;

    return (baseCost + waitingCost).toStringAsFixed(1);
  }
}
