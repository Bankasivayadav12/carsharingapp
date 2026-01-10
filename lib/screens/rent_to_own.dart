import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RentToOwnMainScreen extends StatefulWidget {
  const RentToOwnMainScreen({super.key});

  @override
  State<RentToOwnMainScreen> createState() => _RentToOwnMainScreenState();
}

class _RentToOwnMainScreenState extends State<RentToOwnMainScreen> {
  final Color green = const Color(0xFF00C853);

  // ---------------------------------------------------------
  // 🟧 SAMPLE AVAILABLE CARS (Dummy Data)
  // ---------------------------------------------------------
  final List<Map<String, dynamic>> availableCars = [
    {
      "name": "Toyota Glanza",
      "price": "\$ 500 / month",
      "img": "assets/images/benz_car.webp"
    },
    {
      "name": "Suzuki Swift",
      "price": "\$ 300 / month",
      "img": "assets/images/benz_car.webp"
    },
    {
      "name": "Hyundai i20",
      "price": "\$ 400 / month",
      "img": "assets/images/benz_car.webp"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: green,
        centerTitle: true,
        title: const Text(
          "Rent To Own",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerBanner(),

            const SizedBox(height: 20),

            const Text(
              "Available Cars",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),

            _availableCarsSection(),

            const SizedBox(height: 14),
             const Text(
              "Quick Access",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            _menuGrid(),
            const SizedBox(height: 14),




            const SizedBox(height: 30),
            const Text(
              "Your Ownership Progress",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),
            _progressCard(),

            const SizedBox(height: 30),

            // ⭐⭐ NEW SECTION: Available Cars ⭐⭐ // ⭐ Added here
          ],
        ),
      ),
    );
  }

  // -------------------------------
  // 🔶 HEADER BANNER
  // -------------------------------
  Widget _headerBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [green, green.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.car_rental, size: 55, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Drive Daily.\nOwn in 12 Months.",
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------
  // 🟠 DASHBOARD MENU GRID
  // -------------------------------
  Widget _menuGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.15,
      children: [
        _menuButton(Icons.directions_car, "My Car", Colors.redAccent, () {}),
        _menuButton(Icons.timeline, "Ownership Timeline", Colors.purple, () {}),
        _menuButton(Icons.support_agent, "Support", Colors.teal, () {}),
        _menuButton(Icons.info, "Plan Details", Colors.brown, () {}),
      ],
    );
  }

  Widget _menuButton(IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black12.withOpacity(0.08),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  // -------------------------------
  // 📊 PROGRESS CARD
  // -------------------------------
  Widget _progressCard() {
    double progress = 0.45;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12.withOpacity(0.08),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Car Ownership Progress",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),

          LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            borderRadius: BorderRadius.circular(12),
            backgroundColor: Colors.grey.shade300,
            color: green,
          ),

          const SizedBox(height: 10),

          Text(
            "${(progress * 100).toStringAsFixed(0)}% Completed",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text("6 months out of 12 completed",
              style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
  // ---------------------------------------------------------
  // 🔥 AVAILABLE CARS SECTION
  // ---------------------------------------------------------
  Widget _availableCarsSection() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: availableCars.length,
        itemBuilder: (context, index) {
          final car = availableCars[index];

          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black12.withOpacity(0.08),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // ---------------------------
                // 🚗 LEFT SIDE — Car Image
                // ---------------------------
                Container(
                  width: 150,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: AssetImage(car["img"]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // ---------------------------
                // 📄 RIGHT SIDE — Details + Button
                // ---------------------------
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Car Name
                        Text(
                          car["name"],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        // Price
                        Text(
                          car["price"],
                          style: TextStyle(
                            fontSize: 14,
                            color: green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // ⭐ OWN IT BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: green,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              // Navigate to Rent-To-Own Details Screen
                            },
                            child: const Text(
                              "Own It",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}
