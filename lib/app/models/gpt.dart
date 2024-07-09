class ChatResponse {
  final String message;

  ChatResponse({required this.message});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      message: json['choices'][0]['message']['content'],
    );
  }
}