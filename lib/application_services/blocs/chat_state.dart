part of 'chat_bloc.dart';

@immutable
sealed class ChatState {
  const ChatState({
    this.messages = const <Message>[],
    this.language = Language.en,
  });

  final Language language;
  final List<Message> messages;
}

final class ChatInitial extends ChatState {
  const ChatInitial({required super.language});

  ChatInitial copyWith({
    Language? language,
  }) =>
      ChatInitial(
        language: language ?? this.language,
      );
}

final class LoadingHomeState extends ChatState {
  const LoadingHomeState() : super();
}

final class ChatError extends ChatState {
  const ChatError({
    required this.errorMessage,
    super.messages,
    required super.language,
  });

  final String errorMessage;

  ChatError copyWith({
    String? errorMessage,
    List<Message>? messages,
    Language? language,
  }) =>
      ChatError(
        errorMessage: errorMessage ?? this.errorMessage,
        messages: messages ?? this.messages,
        language: language ?? this.language,
      );
}

final class AiMessageUpdated extends ChatState {
  const AiMessageUpdated({required super.messages, required super.language});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AiMessageUpdated &&
          runtimeType == other.runtimeType &&
          language == other.language &&
          messages == other.messages;

  @override
  int get hashCode => Object.hash(language, messages);

  AiMessageUpdated copyWith({
    List<Message>? messages,
    Language? language,
  }) =>
      AiMessageUpdated(
        messages: messages ?? this.messages,
        language: language ?? this.language,
      );
}

final class SentMessageState extends ChatState {
  const SentMessageState({required super.messages, required super.language});

  SentMessageState copyWith({
    List<Message>? messages,
    Language? language,
  }) =>
      SentMessageState(
        messages: messages ?? this.messages,
        language: language ?? this.language,
      );
}
