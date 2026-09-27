import 'package:flutter/foundation.dart';
import 'package:laozi_ai/entities/enums/role.dart';

class Message {
  const Message({required this.role, required this.content, this.aiModel});

  final Role role;

  final StringBuffer content;

  /// Provider and model that produced this reply, when the backend sent one.
  final String? aiModel;

  bool get isAi => role.isAiAssistant;

  bool get isAiAssistant => role.isAiAssistant;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          role == other.role &&
          aiModel == other.aiModel &&
          content.toString() == other.content.toString();

  @override
  int get hashCode =>
      role.hashCode ^
      aiModel.hashCode ^
      content.hashCode ^
      content.length.hashCode;

  Message copyWith({Role? role, StringBuffer? content, String? aiModel}) =>
      Message(
        role: role ?? this.role,
        content: content ?? this.content,
        aiModel: aiModel ?? this.aiModel,
      );

  @override
  String toString() {
    if (kDebugMode) {
      return 'Message{role: $role, content: $content}';
    } else {
      return super.toString();
    }
  }
}
