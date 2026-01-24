import 'package:injectable/injectable.dart';
import 'package:laozi_ai/env/env.dart';
import 'package:resend/resend.dart';

@module
abstract class ResendModule {
  Resend get resend => Resend(apiKey: Env.resendApiKey);
}
