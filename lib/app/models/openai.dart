enum MessageType { user, bot }

class MessageModel {
  late String userMessage;
  late String botMessage;
  late MessageType messageType;

  MessageModel(
      {required this.userMessage,
        required this.botMessage,
        required this.messageType});
}