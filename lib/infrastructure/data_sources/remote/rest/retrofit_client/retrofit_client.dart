import 'package:dio/dio.dart' hide Headers;
import 'package:laozi_ai/infrastructure/data_sources/remote/models/chat_request/chat_request.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_client.g.dart';

@RestApi()
abstract class RetrofitClient {
  factory RetrofitClient(Dio dio, {String baseUrl}) = _RetrofitClient;

  @POST('chat-android-en')
  @DioResponseType(ResponseType.stream)
  Stream<List<int>> sendEnglishAndroidChatMessage(
    @Body() ChatRequest chatRequest,
  );

  @POST('chat-android-ua')
  @DioResponseType(ResponseType.stream)
  Stream<List<int>> sendUkrainianAndroidChatMessage(
    @Body() ChatRequest chatRequest,
  );

  @POST('chat-ios-en')
  @DioResponseType(ResponseType.stream)
  Stream<List<int>> sendEnglishIosChatMessage(@Body() ChatRequest chatRequest);

  @POST('chat-ios-ua')
  @DioResponseType(ResponseType.stream)
  Stream<List<int>> sendUkrainianIosChatMessage(
    @Body() ChatRequest chatRequest,
  );

  @POST('chat-web-app-en')
  @DioResponseType(ResponseType.stream)
  Stream<List<int>> sendEnglishWebChatMessage(@Body() ChatRequest chatRequest);

  @POST('chat-web-app-ua')
  @DioResponseType(ResponseType.stream)
  Stream<List<int>> sendUkrainianWebChatMessage(
    @Body() ChatRequest chatRequest,
  );

  @POST('chat')
  @DioResponseType(ResponseType.stream)
  Stream<List<int>> sendChatMessage(@Body() ChatRequest chatRequest);
}
