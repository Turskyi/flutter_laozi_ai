part of 'support_bloc.dart';

@immutable
abstract class SupportEvent {
  const SupportEvent();
}

class SendSupportEmail extends SupportEvent {
  const SendSupportEmail({
    required this.name,
    required this.email,
    required this.message,
  });

  final String name;
  final String email;
  final String message;
}
