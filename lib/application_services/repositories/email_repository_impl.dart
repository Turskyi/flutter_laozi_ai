import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:injectable/injectable.dart';
import 'package:laozi_ai/domain_services/email_repository.dart';
import 'package:laozi_ai/entities/feedback_email/feedback_email.dart';
import 'package:laozi_ai/infrastructure/web_services/rest/retrofit_client/retrofit_client.dart';

@Injectable(as: EmailRepository)
class EmailRepositoryImpl implements EmailRepository {
  const EmailRepositoryImpl(this._restClient);

  final RetrofitClient _restClient;

  @override
  Future<void> sendFeedback(Email email) => _restClient.email(
        FeedbackEmail(
          email: 'noEmail',
          subject: email.subject,
          message: email.body,
        ),
      );
}
