import 'package:flutter_email_sender/flutter_email_sender.dart';

abstract interface class EmailRepository {
  const EmailRepository();

  Future<void> sendFeedback(Email email);
}
