import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String hostName;
  final String hostImage;

  const ChatScreen({
    super.key,
    required this.hostName,
    required this.hostImage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageCtrl = TextEditingController();
  final ScrollController scrollCtrl = ScrollController();


  // quick messages or pre-canned messages
  final List<String> quickReplies = [
    "Hi, I'm on the way",
    "I’ve reached the pickup point",
    "I’m waiting at the location",
    "Could you please share your live location?",
    "How long will it take to reach?",
    "Is the vehicle ready for pickup?",
    "Please keep the car unlocked",
    "I need assistance with directions",
    "I may be running a little late",
    "Thank you!",
  ];

  // List of messages
  List<Map<String, dynamic>> messages = [
    {"msg": "Hello! How can I help you today?", "isMe": false},
    {"msg": "I want more details about the car.", "isMe": true},
  ];

  // SEND MESSAGE
  void sendMessage() {
    String text = messageCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"msg": text, "isMe": true});
    });

    messageCtrl.clear();

    // Scroll to bottom after sending
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollCtrl.jumpTo(scrollCtrl.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

            appBar: AppBar(
              //automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              titleSpacing: 0,
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.hostImage),
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.hostName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      const Text("Online",
                          style: TextStyle(fontSize: 12, color: Colors.green)),
                    ],
                  )
                ],
              ),
            ),

      body: Column(
        children: [
          // MESSAGE LIST
          Expanded(
            child: ListView.builder(
              controller: scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                bool isMe = messages[i]["isMe"];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: isMe
                      ? _senderBubble(messages[i]["msg"])
                      : _receiverBubble(messages[i]["msg"]),
                );
              },
            ),
          ),


          // quick replies
          _rapidoQuickReplies(),
          // INPUT BAR
          _chatInputBar(),
        ],
      ),
    );
  }

  // RECEIVER BUBBLE
  Widget _receiverBubble(String msg) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              blurRadius: 6,
            )
          ],
        ),
        child: Text(msg, style: const TextStyle(fontSize: 15)),
      ),
    );
  }

  // SENDER BUBBLE
  Widget _senderBubble(String msg) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(msg,
            style: const TextStyle(color: Colors.white, fontSize: 15)),
      ),
    );
  }

  // INPUT BAR
  Widget _chatInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: messageCtrl,
                decoration: const InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // SEND BUTTON
          GestureDetector(
            onTap: sendMessage,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.black,
              child: const Icon(Icons.send, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  // Quick replies
  Widget _rapidoQuickReplies() {
    return Container(
      height: 170,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ListView.separated(
        itemCount: quickReplies.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, index) {
          final msg = quickReplies[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                messages.add({"msg": msg, "isMe": true});
              });

              Future.delayed(const Duration(milliseconds: 100), () {
                if (scrollCtrl.hasClients) {
                  scrollCtrl.jumpTo(scrollCtrl.position.maxScrollExtent);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.green.shade50,   // Soft green background
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.green.shade300, // Light green border
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.chat_bubble_outline,
                      color: Colors.green.shade700, size: 18),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      msg,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }





}
