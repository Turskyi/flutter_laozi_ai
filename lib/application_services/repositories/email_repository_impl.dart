import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:injectable/injectable.dart';
import 'package:laozi_ai/domain_services/email_repository.dart';
import 'package:laozi_ai/infrastructure/web_services/models/email_request/email_request.dart';
import 'package:laozi_ai/infrastructure/web_services/rest/retrofit_client/retrofit_client.dart';

@Injectable(as: EmailRepository)
class EmailRepositoryImpl implements EmailRepository {
  const EmailRepositoryImpl(this._restClient);

  final RetrofitClient _restClient;

  @override
  Future<void> sendFeedback(Email email) => _restClient.email(
        EmailRequest(
          email: 'noEmail',
          subject: email.subject,
          message: email.body,
        ),
      );
}
