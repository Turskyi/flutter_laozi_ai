import 'package:laozi_ai/entities/chat.dart';

abstract interface class ChatRepository {
  const ChatRepository();

  Stream<String> sendChat(Chat chat);

  /// Model label from the `X-AI-Model` header of the latest chat response.
  String? get latestAiModel;
}
