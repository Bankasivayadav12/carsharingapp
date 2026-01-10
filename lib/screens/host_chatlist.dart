import 'package:flutter/material.dart';

import 'host_chatscreen.dart';

class ChatListScreen extends StatelessWidget {
  final List<Map<String, String>> chatUsers = [
    {
      "name": "John Carter",
      "image": "assets/images/host1.png",
      "lastMsg": "Is the car ready?",
      "time": "5:45 PM"
    },
    {
      "name": "Emily Watson",
      "image": "assets/images/host2.png",
      "lastMsg": "I have reached the pickup point",
      "time": "4:12 PM"
    },
    {
      "name": "Michael Brown",
      "image": "assets/images/host3.png",
      "lastMsg": "Thank you!",
      "time": "Yesterday"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),

      body: ListView.builder(
        itemCount: chatUsers.length,
        itemBuilder: (_, index) {
          final user = chatUsers[index];

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

            leading: CircleAvatar(
              radius: 26,
              backgroundImage: AssetImage(user["image"]!),
            ),

            title: Text(
              user["name"]!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            subtitle: Text(
              user["lastMsg"]!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            trailing: Text(
              user["time"]!,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            onTap: () {
              // ⭐ Navigate to Host Chat Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HostChatScreen(
                    hostName: user["name"]!,
                    hostImage: user["image"]!,
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
