import 'package:dio/dio.dart' hide Headers;
import 'package:laozi_ai/infrastructure/web_services/models/chat_request/chat_request.dart';
import 'package:laozi_ai/infrastructure/web_services/models/email_request/email_request.dart';
import 'package:laozi_ai/infrastructure/web_services/models/email_response/email_response.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_client.g.dart';

@RestApi()
abstract class RetrofitClient {
  factory RetrofitClient(Dio dio, {String baseUrl}) = _RetrofitClient;

  @POST('chat-android-en')
  Stream<String> sendEnglishAndroidChatMessage(@Body() ChatRequest chatRequest);

  @POST('chat-android-ua')
  Stream<String> sendUkrainianAndroidChatMessage(
    @Body() ChatRequest chatRequest,
  );

  @POST('chat-ios-en')
  Stream<String> sendEnglishIosChatMessage(@Body() ChatRequest chatRequest);

  @POST('chat-ios-ua')
  Stream<String> sendUkrainianIosChatMessage(@Body() ChatRequest chatRequest);

  @POST('chat-web-app-en')
  Stream<String> sendEnglishWebChatMessage(@Body() ChatRequest chatRequest);

  @POST('chat-web-app-ua')
  Stream<String> sendUkrainianWebChatMessage(@Body() ChatRequest chatRequest);

  @POST('chat')
  Stream<String> sendChatMessageOnUnknownPlatform(
    @Body() ChatRequest chatRequest,
  );

  //TODO: replace with different email service.
  @POST('https://an-artist-art.vercel.app/api/email')
  @Headers(<String, dynamic>{'Content-Type': 'application/json'})
  Future<EmailResponse> email(@Body() EmailRequest email);
}
