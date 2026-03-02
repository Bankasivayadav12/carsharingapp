import 'package:flutter/material.dart';

class UserNotificationScreen extends StatelessWidget {
  const UserNotificationScreen({super.key});

  final List<Map<String, String>> notifications = const [
    {
      "title": "Ride Completed",
      "message": "Your car-sharing ride has been successfully completed.",
      "time": "2 min ago",
      "icon": "done",
    },
    {
      "title": "Host Message",
      "message": "Your host replied: 'Car is ready for pickup'.",
      "time": "10 min ago",
      "icon": "chat",
    },
    {
      "title": "Offer Alert",
      "message": "Save 10% on your next ride! Limited-time offer.",
      "time": "1 hr ago",
      "icon": "local_offer",
    },
    {
      "title": "Document Verified",
      "message": "Your driving license has been verified successfully.",
      "time": "Yesterday",
      "icon": "verified",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text(
          "Notifications",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
        ),
      ),

      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, index) {
          final item = notifications[index];

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.10),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.green.shade50,
                  child: Icon(
                    _getIcon(item["icon"]!),
                    color: Colors.green.shade700,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"]!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item["message"]!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item["time"]!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
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

  IconData _getIcon(String key) {
    switch (key) {
      case "chat":
        return Icons.chat_bubble_outline;
      case "done":
        return Icons.check_circle_outline;
      case "verified":
        return Icons.verified_user;
      case "local_offer":
        return Icons.local_offer_outlined;
      default:
        return Icons.notifications_none;
    }
  }
}
