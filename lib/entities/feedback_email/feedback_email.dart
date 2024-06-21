import 'package:json_annotation/json_annotation.dart';

part 'feedback_email.g.dart';

/// Request example:
/// {
///  "email": "user@gmail.com",
///  "subject": "Example",
///  "message": "Example"
/// }
@JsonSerializable(createFactory: false)
class FeedbackEmail {
  const FeedbackEmail({
    required this.email,
    required this.subject,
    required this.message,
  });

  final String email;
  final String subject;
  final String message;

  Map<String, dynamic> toJson() => _$FeedbackEmailToJson(this);

  @override
  String toString() =>
      'FeedbackEmailEmail{email: $email, subject: $subject, message: $message}';
}
