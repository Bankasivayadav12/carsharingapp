import 'package:flutter/material.dart';

// DUMMY HISTORY DATA
final List<Map<String, dynamic>> dummyHistory = [
  {
    "user": "Michael Johnson",
    "pickup": "Times Square, New York",
    "drop": "Central Park, New York",
    "cost": "\$28",
    "date": "11/12/2025 • 4:30 PM"
  },
  {
    "user": "Emily Roberts",
    "pickup": "Brooklyn Heights, New York",
    "drop": "Manhattan, New York",
    "cost": "\$22",
    "date": "11/10/2025 • 7:10 PM"
  },
  {
    "user": "Christopher Miller",
    "pickup": "Mission District, San Francisco",
    "drop": "Fisherman's Wharf, San Francisco",
    "cost": "\$35",
    "date": "11/08/2025 • 9:45 AM"
  },
];


// DUMMY EARNINGS DATA
final Map<String, dynamic> earningsSummary = {
  "total_rides": 32,
  "total_earnings": "\$154.20",
  "month": "November 2025"
};

class ManageCarPage extends StatelessWidget {
  final List<Map<String, dynamic>> cars;
  final Function(int) onDelete;

  const ManageCarPage({
    super.key,
    required this.cars,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa), // soft premium background

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Earnings & History",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _headerBanner(),
          const SizedBox(height: 20),

          _sectionTitle("Your Cars"),
          const SizedBox(height: 12),

          ...cars.asMap().entries.map((e) => _carTile(e.key, e.value)),

          const SizedBox(height: 20),

          _sectionTitle("Recent Rides"),
          const SizedBox(height: 12),

          ...dummyHistory.map((h) => _historyTile(h)),
        ],
      ),
    );
  }

  // ============================================================
  // ⭐ MODERN HEADER BANNER (Gradient + Summary)
  // ============================================================
  Widget _headerBanner() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade200.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Earnings",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            earningsSummary["total_earnings"],
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _miniStat("${earningsSummary["total_rides"]}", "Rides"),
              _miniStat(earningsSummary["month"], "Month"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ⭐ CAR TILE — Premium Design
  // ============================================================
  Widget _carTile(int index, Map<String, dynamic> c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),

      child: Row(
        children: [
          // Car Image
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              c["image"],
              width: 78,
              height: 65,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c["name"],
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Model: ${c["model"]}",
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "No: ${c["number"]}",
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () => onDelete(index),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete, color: Colors.red, size: 20),
            ),
          )
        ],
      ),
    );
  }

  // ============================================================
  // ⭐ HISTORY TILE — Modern Clean UI
  // ============================================================
  Widget _historyTile(Map<String, dynamic> h) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: _cardDecoration(),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            h["user"],
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 10),

          _infoRow(Icons.location_on, "Pickup", h["pickup"]),
          const SizedBox(height: 6),
          _infoRow(Icons.flag, "Drop", h["drop"]),

          const Divider(height: 22),

          _infoRow(Icons.currency_rupee, "Cost", h["cost"]),
          const SizedBox(height: 4),
          _infoRow(Icons.calendar_today, "Date", h["date"]),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.green.shade600),
        const SizedBox(width: 10),
        Text(
          "$label:",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ⭐ SECTION TITLE
  // ============================================================
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w900,
        color: Colors.black87,
      ),
    );
  }

  // ============================================================
  // ⭐ MODERN CARD DECORATION
  // ============================================================
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black12.withOpacity(0.07),
          blurRadius: 10,
          spreadRadius: 1,
          offset: const Offset(0, 4),
        )
      ],
    );
  }
}
