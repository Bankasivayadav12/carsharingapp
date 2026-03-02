import 'package:f_demo/screens/CarSharing/User/user_screen.dart';
import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final Map<String, dynamic> captureResponse;

  const PaymentSuccessScreen({
    super.key,
    required this.captureResponse,
  });

  @override
  State<PaymentSuccessScreen> createState() =>
      _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnim;




  //String get address => "";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 🔥 Format ISO Date to readable format
  String formatDate(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return isoDate;

    return "${date.day}/${date.month}/${date.year} "
        "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  @override
  Widget build(BuildContext context) {
    final result = widget.captureResponse["_result"]?[0]?["json"]?[0];


    final carOwnerAddress =
        result?["car"]?["address"] ?? "Address Not Available";

    final costCoins = (result?["cost"] ?? 0).toDouble();
    final pickup = result?["booked_from"] ?? "";
    final drop = result?["booked_till"] ?? "";

    final car = result?["car"];
    final carName =
        car?["vehicle_deatils"]?["name"] ?? "Car";

    final costDollar = costCoins / 10;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F9D58),
              Color(0xFF0A7D44),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              children: [

                const SizedBox(height: 20),

                // ✅ Animated Success Icon
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha(38),
                      border: Border.all(
                        color: Colors.white.withAlpha(77),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Payment Successful",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Your booking has been confirmed!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withAlpha(217),
                  ),
                ),

                const SizedBox(height: 35),

                // ✅ Premium Glass Card
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withAlpha(217),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(51),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      _premiumRow(Icons.location_on,
                          "Car Owner Address", carOwnerAddress),

                      _premiumRow(Icons.directions_car,
                          "Car", carName),

                      _premiumRow(Icons.calendar_today,
                          "Pickup", formatDate(pickup)),

                      _premiumRow(Icons.calendar_today_outlined,
                          "Drop", formatDate(drop)),

                      const Divider(height: 25),

                      _premiumRow(Icons.attach_money,
                          "Total Paid",
                          "${costCoins.toStringAsFixed(0)} Coins  "
                              "(\$${costDollar.toStringAsFixed(2)})",
                          isHighlight: true),
                    ],
                  ),
                ),

                const SizedBox(height: 45),

                // ✅ Premium Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => UserCarsScreen()),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Go To Home",
                      style: TextStyle(
                        color: Color(0xFF0F9D58),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }




  Widget _premiumRow(
      IconData icon,
      String title,
      String value, {
        bool isHighlight = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: isHighlight
                ? const Color(0xFF0F9D58)
                : Colors.grey.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$title\n",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                      isHighlight ? FontWeight.bold : FontWeight.w500,
                      color: isHighlight
                          ? const Color(0xFF0F9D58)
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



}
