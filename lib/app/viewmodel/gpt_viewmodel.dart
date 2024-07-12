import 'package:autolookbook/app/utils/weather_conditions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';


String apiKey = dotenv.get("GEMINI_API_KEY");
class GeminiController extends GetxController {
  var Text = "".obs;
  Future<void> getgemini(String t1h, String tmn, String tmx, int pty, String wsd, int sky,int reh,String windchill) async {

    String? stpty = Rain_SnowConditions.rain_snowconditions[pty];
    String? stsky = SkyConditions.skyConditions[sky];
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );

    //final prompt = ' 지금 날씨가 $t1h도, 최저 $tmn도, 최고$tmx도, 강수형태는$stpty, 풍속은 $wsd/s, 하늘상태는 $stsky, 습도는 $reh%야. 지금 외출한다면 뭘 입는게 좋을지 두 문장으로 간단하게 브리핑 해줘. 말투는 약간 존댓말로 발랄하게';
    final prompt = ' 너는 패션 비서야. 지금 날씨가 $t1h도, 체감온도는 $windchill도 야. 강수형태는 $stpty 하늘상태는 $stsky야. 지금 외출한다면 뭘 입는게 좋을지 두 문장으로 브리핑 해줘. 마지막은 !로';
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    print(response.text);
    Text.value = response.text!;
  }
}
