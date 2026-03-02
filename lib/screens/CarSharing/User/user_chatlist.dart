import 'package:flutter/material.dart';

import 'Chat_Screen.dart';

class UserChatListScreen extends StatelessWidget {
  UserChatListScreen({super.key});

  final List<Map<String, dynamic>> chatUsers = [
    {
      "name": "John Carter",
      "image": "assets/images/host1.png",
      "lastMsg": "Car is ready for pickup",
      "time": "5:45 PM",
    },
    {
      "name": "Emily Watson",
      "image": "assets/images/host2.png",
      "lastMsg": "Reached the pickup location",
      "time": "4:12 PM",
    },
    {
      "name": "Michael Brown",
      "image": "assets/images/host3.png",
      "lastMsg": "Thanks for the ride!",
      "time": "Yesterday",
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
          "Messages",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView.separated(
        itemCount: chatUsers.length,
        separatorBuilder: (_, __) => Container(height: 1, color: Colors.black12),
        itemBuilder: (_, index) {
          final user = chatUsers[index];

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

            leading: CircleAvatar(
              radius: 26,
              backgroundImage: AssetImage(user["image"]),
            ),

            title: Text(
              user["name"],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            subtitle: Text(
              user["lastMsg"],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            trailing: Text(
              user["time"],
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    hostName: user["name"],
                    hostImage: user["image"],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
