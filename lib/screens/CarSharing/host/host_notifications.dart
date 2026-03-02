import 'package:flutter/material.dart';

class HostNotificationsScreen extends StatelessWidget {
  const HostNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: demoNotifications.length,
        itemBuilder: (context, index) {
          final notif = demoNotifications[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.green.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NOTIFICATION ICON
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.green.shade50,
                  child: Icon(
                    notif["icon"],
                    color: Colors.green.shade700,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 12),

                // TEXT CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif["title"],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        notif["message"],
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        notif["time"],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
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


/// 🔔 DEMO DATA (Replace with API later)
final List<Map<String, dynamic>> demoNotifications = [
  {
    "icon": Icons.car_rental,
    "title": "New Booking Received",
    "message": "A user booked your Honda Civic for tomorrow at 10 AM.",
    "time": "5 minutes ago",
  },
  {
    "icon": Icons.info_outline,
    "title": "Required Document Update",
    "message": "Your RC document for Swift needs verification.",
    "time": "1 hour ago",
  },
  {
    "icon": Icons.monetization_on,
    "title": "Earning Credited",
    "message": "₹650 has been added to your RideALott wallet.",
    "time": "2 hours ago",
  },
  {
    "icon": Icons.message_outlined,
    "title": "New Message",
    "message": "Rider Sam requested more details about the vehicle.",
    "time": "4 hours ago",
  },
  {
    "icon": Icons.notifications_active,
    "title": "High Demand Today!",
    "message": "Increase pricing to earn 15% extra earnings.",
    "time": "1 day ago",
  },
];
