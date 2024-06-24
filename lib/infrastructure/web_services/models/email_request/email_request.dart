import 'package:json_annotation/json_annotation.dart';

part 'email_request.g.dart';

/// Request example:
/// {
///  "email": "user@gmail.com",
///  "subject": "Example",
///  "message": "Example"
/// }
@JsonSerializable(createFactory: false)
class EmailRequest {
  const EmailRequest({
    required this.email,
    required this.subject,
    required this.message,
  });

  final String email;
  final String subject;
  final String message;

  Map<String, dynamic> toJson() => _$EmailRequestToJson(this);

  @override
  String toString() =>
      'EmailRequest{email: $email, subject: $subject, message: $message}';
}
