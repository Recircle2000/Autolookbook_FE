import 'dart:convert';
import 'package:autolookbook/app/models/openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'weather_viewmodel.dart';

class GptController extends GetxController {
  var text = ''.obs;
  var messages = <MessageModel>[].obs;
  var isLoading = false.obs;
  final String apiKey = dotenv.get("OPENAI_API_briefing_KEY");
  final WeatherViewModel weatherViewModel = Get.put(WeatherViewModel());

  void sendMessage(String message) async {
    if (message.isEmpty) return;

    // 사용자 메시지 추가
    messages.add(MessageModel(
      userMessage: message,
      botMessage: '',
      messageType: MessageType.user,
    ));

    // 로딩 상태 활성화
    isLoading.value = true;

    // GPT 응답 요청
    final response = await getGptResponseChat(message);

    // GPT 응답 처리
    messages.add(MessageModel(
      userMessage: '',
      botMessage: response,
      messageType: MessageType.bot,
    ));

    // 로딩 상태 비활성화
    isLoading.value = false;
  }

  Future<void> getGptResponse(
      String t1h,
      String tmn,
      String tmx,
      String wsd,
      int reh,
      String windchill,
      String skyCondition,
      ) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final prompt = 'You are a fashion assistant. I am a man, and the current wind speed is $wsd/s, the sky condition is $skyCondition, the feels-like temperature is $windchill°C, and the humidity is $reh%. Please provide a brief recommendation on what to wear if I go out, in two sentences. in korean.';

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          "messages": [{"role": "user", "content": prompt}],
          'max_tokens': 100,
          "temperature": 0.7
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // 데이터 구조를 안전하게 확인합니다.
        if (data != null && data['choices'] != null && data['choices'].isNotEmpty) {
          final gptResponse = data['choices'][0]['message']['content'];
          text.value = utf8.decode(gptResponse.codeUnits).trim() ?? '데이터 없음';
        } else {
          text.value = 'No valid response received';
        }
      } else {
        text.value = 'Failed to fetch data. Status code: ${response.statusCode}';
        print('Response body: ${response.body}'); // 에러 메시지를 확인할 수 있도록 추가
      }
    } catch (e) {
      text.value = 'Error: $e';
    }
  }

  Future<String> getGptResponseChat(String input) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    try {
      List<Map<String, dynamic>> messagesList = [];
        final roleMessage = {
          'role': 'system',
          'content': 'Your role from now on is that of a fashion secretary. now temperature is ${weatherViewModel.T1H.value}°C, the perceived temperature is ${weatherViewModel.WindChill.value}°C, humidity is ${weatherViewModel.REH.value}%, wind speed is ${weatherViewModel.WSD.value}m/s,The hourly precipitation is ${weatherViewModel.RN1.value}.  the sky condition is ${weatherViewModel.SKY.value}. From now on, please answer fashion-related questions in 3 simple sentences. In Korean.'
        };

        messagesList.add(roleMessage);


      // 사용자 메시지 추가
      final userMessage = {
        'role': 'user',
        'content': input
      };

      messagesList.add(userMessage);

      print(messagesList);
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': messagesList,
          'max_tokens': 300,
          'temperature': 0.7,
        }),
      );
      print('status: ${response.statusCode}');
      print('body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'];
        } else {
          return '데이터 없음';
        }
      } else {
        return '오류 : ${response.statusCode}';
      }
    } catch (e) {
      return '오류: $e';
    }
  }
}