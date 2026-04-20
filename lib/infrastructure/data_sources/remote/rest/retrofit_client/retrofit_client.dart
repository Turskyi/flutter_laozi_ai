import 'dart:convert';

import 'package:dio/dio.dart' hide Headers;
import 'package:laozi_ai/infrastructure/data_sources/remote/models/chat_request/chat_request.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_client.g.dart';

@RestApi()
abstract class RetrofitClient {
  factory RetrofitClient(Dio dio, {String baseUrl}) = _RetrofitClient;

  @POST('chat-android-en')
  @DioResponseType(ResponseType.stream)
  Stream<String> sendEnglishAndroidChatMessage(@Body() ChatRequest chatRequest);

  @POST('chat-android-ua')
  @DioResponseType(ResponseType.stream)
  Stream<String> sendUkrainianAndroidChatMessage(
    @Body() ChatRequest chatRequest,
  );

  @POST('chat-ios-en')
  @DioResponseType(ResponseType.stream)
  Stream<String> sendEnglishIosChatMessage(@Body() ChatRequest chatRequest);

  @POST('chat-ios-ua')
  @DioResponseType(ResponseType.stream)
  Stream<String> sendUkrainianIosChatMessage(@Body() ChatRequest chatRequest);

  @POST('chat-web-app-en')
  @DioResponseType(ResponseType.stream)
  Stream<String> sendEnglishWebChatMessage(@Body() ChatRequest chatRequest);

  @POST('chat-web-app-ua')
  @DioResponseType(ResponseType.stream)
  Stream<String> sendUkrainianWebChatMessage(@Body() ChatRequest chatRequest);

  @POST('chat')
  @DioResponseType(ResponseType.stream)
  Stream<String> sendChatMessage(@Body() ChatRequest chatRequest);
}
