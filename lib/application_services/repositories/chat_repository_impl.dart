import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:laozi_ai/domain_services/chat_repository.dart';
import 'package:laozi_ai/entities/chat.dart';
import 'package:laozi_ai/entities/message.dart';
import 'package:laozi_ai/infrastructure/web_services/models/chat_request/chat_request.dart';
import 'package:laozi_ai/infrastructure/web_services/models/chat_request/message_request.dart';
import 'package:laozi_ai/infrastructure/web_services/rest/retrofit_client/retrofit_client.dart';

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._restClient);

  final RetrofitClient _restClient;

  @override
  Stream<String> sendChat(Chat chat) {
    if (chat.usesEnglishLanguage) {
      return _restClient
          .sendChatMessage(
            ChatRequest(
              messages: chat.messages
                  .map(
                    (Message message) => MessageRequest(
                      role: message.role.name,
                      content: '${message.content}',
                    ),
                  )
                  .toList(),
            ),
          )
          .transform(const LineSplitter())
          .map((String line) {
        // Use a regular expression to match lines that start with an index
        // and extract the actual content.
        final RegExp regex = RegExp(r'^\d+:"(.+)"$');
        final RegExpMatch? match = regex.firstMatch(line);
        return match?.group(1) ?? 'Invalid format';
      });
    } else {
      return _restClient
          .sendUkrainianChatMessage(
            ChatRequest(
              messages: chat.messages
                  .map(
                    (Message message) => MessageRequest(
                      role: message.role.name,
                      content: '${message.content}',
                    ),
                  )
                  .toList(),
            ),
          )
          .transform(const LineSplitter())
          .map((String line) {
        // Use a regular expression to match lines that start with an index
        // and extract the actual content.
        final RegExp regex = RegExp(r'^\d+:"(.+)"$');
        final RegExpMatch? match = regex.firstMatch(line);
        return match?.group(1) ?? 'Invalid format';
      });
    }
  }
}
