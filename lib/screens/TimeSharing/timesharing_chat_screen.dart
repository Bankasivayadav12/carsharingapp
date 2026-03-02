import 'package:f_demo/screens/TimeSharing/timesharing_chatperson_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeShareChatScreen extends StatelessWidget {
  const TimeShareChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (_, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text("Driver ${index + 1}"),
            subtitle: const Text("Your car is ready."),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("12:30 PM",
                    style: TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    "2",
                    style: TextStyle(
                        color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>  ChatDetailScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
