import 'package:laozi_ai/entities/enums/role.dart';

class Message {
  const Message({required this.role, required this.content});

  final Role role;
  final StringBuffer content;

  bool get isAi => role.isAiAssistant;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          role == other.role &&
          content.toString() == other.content.toString();

  @override
  int get hashCode =>
      role.hashCode ^ content.hashCode ^ content.length.hashCode;
}
