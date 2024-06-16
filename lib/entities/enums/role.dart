enum Role {
  assistant,
  user;

  bool get isAiAssistant => this == Role.assistant;
}
