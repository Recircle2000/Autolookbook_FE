import 'package:flutter/material.dart';
import '../models/openai.dart';

class ChatMessageWidget extends StatelessWidget {
  final String userMessage;
  final String botMessage;
  final MessageType messageType;

  const ChatMessageWidget({
    required this.userMessage,
    required this.botMessage,
    required this.messageType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      color: messageType == MessageType.user
          ? Colors.grey[200]
          : Colors.grey[300],
      child: Row(
        children: [
          messageType == MessageType.user
              ? Container(
            margin: const EdgeInsets.only(right: 16),
            child: const CircleAvatar(
              child: Icon(Icons.person),
            ),
          )
              : const CircleAvatar(
            child: Icon(Icons.ac_unit_outlined),
            backgroundColor: Color.fromRGBO(16, 163, 127, 1),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    messageType == MessageType.user ? userMessage : botMessage,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
