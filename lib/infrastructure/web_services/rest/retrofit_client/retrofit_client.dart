import 'package:dio/dio.dart';
import 'package:laozi_ai/infrastructure/web_services/models/chat_request/chat_request.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_client.g.dart';

@RestApi()
abstract class RetrofitClient {
  factory RetrofitClient(Dio dio, {String baseUrl}) = _RetrofitClient;

  @POST('chat')
  Stream<String> sendChatMessage(@Body() ChatRequest chatRequest);

  @POST('chat-ua')
  Stream<String> sendUkrainianChatMessage(@Body() ChatRequest chatRequest);
}
