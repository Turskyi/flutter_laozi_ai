import 'package:dio/dio.dart' hide Headers;
import 'package:laozi_ai/entities/feedback_email/feedback_email.dart';
import 'package:laozi_ai/infrastructure/web_services/models/chat_request/chat_request.dart';
import 'package:laozi_ai/infrastructure/web_services/models/email_response/email_response.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_client.g.dart';

@RestApi()
abstract class RetrofitClient {
  factory RetrofitClient(Dio dio, {String baseUrl}) = _RetrofitClient;

  @POST('chat')
  Stream<String> sendChatMessage(@Body() ChatRequest chatRequest);

  @POST('chat-ua')
  Stream<String> sendUkrainianChatMessage(@Body() ChatRequest chatRequest);

  @POST('https://an-artist-art.vercel.app/api/email')
  @Headers(<String, dynamic>{'Content-Type': 'application/json'})
  Future<EmailResponse> email(@Body() FeedbackEmail email);
}
