import 'package:autolookbook/app/viewmodel/openai_viewmodel.dart';
import 'package:autolookbook/app/widgets/chatmessagewidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GptController chatController = Get.find<GptController>();

  @override
  void initState() {
    super.initState();
    chatController.messages.listen((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("패션 비서와 대화하기"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: chatController.messages.map((message) {
                    return ChatMessageWidget(
                      userMessage: message.userMessage,
                      botMessage: message.botMessage,
                      messageType: message.messageType,
                    );
                  }).toList(),
                ),
              );
            }),
          ),
          Obx(() {
            return chatController.isLoading.value
                ? LoadingAnimationWidget.prograssiveDots(
              size: 30,
              color: Colors.black,
            )
                : const SizedBox.shrink();
          }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "메세지를 입력하세요.",
                      fillColor: Colors.grey,
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      chatController.sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Color.fromRGBO(142, 142, 160, 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
