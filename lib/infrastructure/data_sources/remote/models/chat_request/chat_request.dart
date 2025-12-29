import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'message_request.dart';

part 'chat_request.g.dart';

@JsonSerializable()
class ChatRequest {
  const ChatRequest({required this.messages, required this.locale});

  factory ChatRequest.fromJson(Map<String, Object?> json) {
    return _$ChatRequestFromJson(json);
  }

  final List<MessageRequest> messages;

  /// The language code (e.g., 'en', 'uk', 'lv', 'es')
  final String locale;

  Map<String, Object?> toJson() => _$ChatRequestToJson(this);

  ChatRequest copyWith({List<MessageRequest>? messages, String? locale}) {
    return ChatRequest(
      messages: messages ?? this.messages,
      locale: locale ?? this.locale,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ChatRequest) return false;
    final bool Function(Object? e1, Object? e2) mapEquals =
        const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => messages.hashCode ^ locale.hashCode;

  @override
  String toString() {
    if (kDebugMode) {
      return 'ChatRequest(messages: $messages, locale: $locale)';
    } else {
      return super.toString();
    }
  }
}
