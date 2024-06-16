import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/di/injector.dart';
import 'package:laozi_ai/laozi_ai_app.dart';
import 'package:laozi_ai/localization_delelegate_getter.dart';

/// The [main] is the ultimate detail — the lowest-level policy.
/// It is the initial entry point of the system.
/// Nothing, other than the operating system, depends on it.
/// Here we should [injectDependencies] by a dependency injection framework.
/// The [main] is a dirty low-level module in the outermost circle of the onion
/// architecture.
/// Think of [main] as a plugin to the [LaoziAiApp] — a plugin that sets up
/// the initial conditions and configurations, gathers all the outside
/// resources, and then hands control over to the high-level policy of the
/// [LaoziAiApp].
/// When [main] is released, it has utterly no effect on any of the other
/// components in the system. They don’t know about [main], and they don’t care
/// when it changes.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  injectDependencies();
  final LocalizationDelegate localizationDelegate =
      await getLocalizationDelegate();
  runApp(
    BetterFeedback(
      child: LocalizedApp(localizationDelegate, const LaoziAiApp()),
    ),
  );
}
