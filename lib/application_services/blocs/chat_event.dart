part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {
  const ChatEvent();
}

final class LoadHomeEvent extends ChatEvent {
  const LoadHomeEvent();
}

final class SendMessageEvent extends ChatEvent {
  const SendMessageEvent(this.message);

  final String message;
}

final class UpdateAiMessageEvent extends ChatEvent {
  const UpdateAiMessageEvent(this.pieceOfMessage);

  final String pieceOfMessage;
}

final class ChangeLanguageEvent extends ChatEvent {
  const ChangeLanguageEvent(this.language);

  final Language language;
}
