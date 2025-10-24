import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/entities/models/exceptions/email_launch_exception.dart';
import 'package:laozi_ai/res/constants.dart' as constants;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:resend/resend.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailRepositoryImpl {
  EmailRepositoryImpl(this._resend);

  final Resend _resend;

  Future<bool> sendSupportEmail({
    required String name,
    required String userEmail,
    required String message,
  }) async {
    bool isEmailSent = false;
    final Email supportEmail = Email(
      body: '${translate('support_page.support_email_body')}:\n\n '
          'Email: $userEmail\n\n'
          'Name: $name\n\n Message: $message.',
      subject: translate(
        'support_page.support_email_subject',
        args: <String, Object?>{'appName': constants.appName},
      ),
      recipients: <String>[constants.supportEmail],
    );

    final Email customerEmail = Email(
      body: translate(
        'support_page.customer_email_body',
        args: <String, Object?>{'appName': constants.appName},
      ),
      subject: translate(
        'support_page.customer_email_subject',
        args: <String, Object?>{'appName': constants.appName},
      ),
      recipients: <String>[userEmail],
    );

    try {
      if (kIsWeb || Platform.isMacOS) {
        await _launchEmailClient(supportEmail);
      } else {
        await _resend.sendEmail(
          from: 'Do Not Reply ${constants.appName} '
              '<no-reply@${constants.resendEmailDomain}>',
          to: <String>[constants.supportEmail],
          subject: supportEmail.subject,
          text: supportEmail.body,
        );

        await _resend.sendEmail(
          from: 'Do Not Reply ${constants.appName} '
              '<no-reply@${constants.resendEmailDomain}>',
          to: customerEmail.recipients,
          subject: customerEmail.subject,
          text: customerEmail.body,
        );
        isEmailSent = true;
      }
    } catch (e) {
      debugPrint('Error sending email: $e');
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        try {
          await FlutterEmailSender.send(supportEmail);
        } catch (e) {
          debugPrint('Error sending email via FlutterEmailSender: $e');
          await _launchEmailClient(supportEmail);
        }
      }
    }
    return isEmailSent;
  }

  Future<void> _launchEmailClient(Email supportEmail) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final Uri emailLaunchUri = Uri(
      scheme: constants.mailToScheme,
      path: constants.supportEmail,
      queryParameters: <String, Object?>{
        constants.subjectParameter: '${translate('feedback.app_feedback')}: '
            '${packageInfo.appName}',
        constants.bodyParameter: supportEmail.body,
      },
    );
    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
        debugPrint(
          'Feedback email launched successfully via url_launcher.',
        );
      } else {
        throw const EmailLaunchException('error.launch_email_failed');
      }
    } catch (urlLauncherError, urlLauncherStackTrace) {
      final String urlLauncherErrorMessage =
          'Error launching email via url_launcher: $urlLauncherError';
      debugPrint(
        '$urlLauncherErrorMessage\nStackTrace: $urlLauncherStackTrace',
      );
      // TODO: throw exception?
    }
  }
}
