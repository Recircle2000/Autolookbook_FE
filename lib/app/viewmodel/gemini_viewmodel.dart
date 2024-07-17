import 'package:autolookbook/app/utils/weather_conditions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';


String apiKey = dotenv.get("GEMINI_API_KEY");
class GeminiViewModel extends GetxController {
  var Text = "".obs;
  Future<void> getgemini(String t1h, String tmn, String tmx, String wsd,int reh,String windchill, String skyCondition) async {


    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );

    //final prompt = ' 지금 날씨가 $t1h도, 최저 $tmn도, 최고$tmx도, 강수형태는$stpty, 풍속은 $wsd/s, 하늘상태는 $stsky, 습도는 $reh%야. 지금 외출한다면 뭘 입는게 좋을지 두 문장으로 간단하게 브리핑 해줘. 말투는 약간 존댓말로 발랄하게';
    final prompt = ' 너는 패션 비서야. 나는 남자고, 지금 날씨가 $t1h°C, 하늘 상태는 $skyCondition, 체감온도는$windchill°C 야. 습도는 $reh%야. 지금 외출한다면 뭘 입는게 좋을지 간단하게 두 문장으로 브리핑 해줘.';
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    print(response.text);
    Text.value = response.text!;
  }
}
