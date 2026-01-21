part of 'chat_bloc.dart';

@immutable
sealed class ChatState {
  const ChatState({required this.messages});

  final List<Message> messages;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatState &&
          runtimeType == other.runtimeType &&
          messages == other.messages;

  @override
  int get hashCode => messages.hashCode;

  @override
  String toString() {
    if (kDebugMode) {
      return 'ChatState(messages: $messages)';
    } else {
      return super.toString();
    }
  }
}

final class ChatInitial extends ChatState {
  const ChatInitial({required super.messages});

  ChatInitial copyWith({List<Message>? messages}) =>
      ChatInitial(messages: messages ?? this.messages);

  @override
  String toString() {
    if (kDebugMode) {
      return 'ChatInitial(messages: $messages)';
    } else {
      return super.toString();
    }
  }
}

final class LoadingHomeState extends ChatState {
  const LoadingHomeState({required super.messages});

  LoadingHomeState copyWith({List<Message>? messages}) =>
      LoadingHomeState(messages: messages ?? this.messages);

  @override
  String toString() {
    if (kDebugMode) {
      return 'LoadingHomeState(messages: $messages)';
    } else {
      return super.toString();
    }
  }
}

final class ChatError extends ChatState {
  const ChatError({required this.errorMessage, required super.messages});

  final String errorMessage;

  ChatError copyWith({String? errorMessage, List<Message>? messages}) =>
      ChatError(
        errorMessage: errorMessage ?? this.errorMessage,
        messages: messages ?? this.messages,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatError &&
        other.errorMessage == errorMessage &&
        other.messages == messages;
  }

  @override
  int get hashCode => errorMessage.hashCode ^ messages.hashCode;

  @override
  String toString() {
    if (kDebugMode) {
      return 'ChatError(errorMessage: $errorMessage, messages: $messages)';
    } else {
      return super.toString();
    }
  }
}

final class AiMessageUpdated extends ChatState {
  const AiMessageUpdated({required super.messages});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AiMessageUpdated &&
          runtimeType == other.runtimeType &&
          messages == other.messages;

  @override
  int get hashCode => messages.hashCode;

  AiMessageUpdated copyWith({List<Message>? messages}) =>
      AiMessageUpdated(messages: messages ?? this.messages);

  @override
  String toString() {
    if (kDebugMode) {
      return 'AiMessageUpdated(messages: $messages)';
    } else {
      return super.toString();
    }
  }
}

final class SentMessageState extends ChatState {
  const SentMessageState({required super.messages});

  SentMessageState copyWith({List<Message>? messages}) =>
      SentMessageState(messages: messages ?? this.messages);

  @override
  String toString() {
    if (kDebugMode) {
      return 'SentMessageState(messages: $messages)';
    } else {
      return super.toString();
    }
  }
}

final class FeedbackState extends ChatState {
  const FeedbackState({required super.messages});

  FeedbackState copyWith({List<Message>? messages}) =>
      FeedbackState(messages: messages ?? this.messages);

  @override
  String toString() {
    if (kDebugMode) {
      return 'FeedbackState(messages: $messages)';
    } else {
      return super.toString();
    }
  }
}

final class FeedbackSent extends ChatState {
  const FeedbackSent({required super.messages});

  FeedbackSent copyWith({List<Message>? messages}) =>
      FeedbackSent(messages: messages ?? this.messages);

  @override
  String toString() {
    if (kDebugMode) {
      return 'FeedbackSent(messages: $messages)';
    } else {
      return super.toString();
    }
  }
}

final class ShareError extends ChatState {
  const ShareError({
    required this.errorMessage,
    required super.messages,
    required this.timestamp,
  });

  final String errorMessage;
  final DateTime timestamp;

  ShareError copyWith({
    String? errorMessage,
    List<Message>? messages,
    DateTime? timestamp,
  }) {
    return ShareError(
      errorMessage: errorMessage ?? this.errorMessage,
      messages: messages ?? this.messages,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShareError &&
        other.errorMessage == errorMessage &&
        other.messages == messages &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode =>
      errorMessage.hashCode ^ messages.hashCode ^ timestamp.hashCode;

  @override
  String toString() {
    if (kDebugMode) {
      return 'ShareError('
          'errorMessage: $errorMessage, '
          'messages: $messages, '
          'timestamp: $timestamp'
          ')';
    } else {
      return super.toString();
    }
  }
}
