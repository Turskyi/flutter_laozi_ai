import 'package:flutter_translate/flutter_translate.dart';

enum Role {
  assistant,
  user;

  bool get isAiAssistant => this == Role.assistant;

  String get value {
    return this == Role.assistant ? translate('laozi') : translate('seeker');
  }
}
