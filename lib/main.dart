import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:laozi_ai/application_services/blocs/chat_bloc.dart';
import 'package:laozi_ai/di/injector.dart' as di;
import 'package:laozi_ai/di/injector.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:laozi_ai/infrastructure/data_sources/local/local_data_source.dart';
import 'package:laozi_ai/localization/localization_delelegate_getter.dart'
    as locale;
import 'package:laozi_ai/router/app_route.dart';
import 'package:laozi_ai/ui/about/about_page.dart';
import 'package:laozi_ai/ui/chat/ai_chatbox.dart';
import 'package:laozi_ai/ui/faq/faq_page.dart';
import 'package:laozi_ai/ui/feedback/feedback_form.dart';
import 'package:laozi_ai/ui/laozi_ai_app.dart';
import 'package:laozi_ai/ui/privacy/privacy_page.dart';
import 'package:laozi_ai/ui/support/support_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // Ensure that the Flutter engine is initialized, to avoid errors with
  // `SharedPreferences` dependencies initialization.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection and wait for `SharedPreferences`.
  await di.injectDependencies();

  final SharedPreferences preferences = await SharedPreferences.getInstance();

  final LocalDataSource localDataSource = LocalDataSource(preferences);

  Language initialLanguage = localDataSource.getSavedLanguage();

  if (kIsWeb) {
    // Retrieves the host name (e.g., "localhost" or "uk.daoizm.online").
    final String host = Uri.base.host;
    // Retrieves the fragment (e.g., "/en" or "/uk").
    final String fragment = Uri.base.fragment;

    for (final Language language in Language.values) {
      final String currentLanguageCode = language.isoLanguageCode;

      if (host.startsWith('$currentLanguageCode.') ||
          fragment.contains('${AppRoute.home.path}$currentLanguageCode')) {
        try {
          Intl.defaultLocale = currentLanguageCode;
        } catch (e, stackTrace) {
          debugPrint(
            'Failed to set Intl.defaultLocale to "$currentLanguageCode".\n'
            'Error: $e\n'
            'StackTrace: $stackTrace\n'
            'Proceeding with previously set default locale or system default.',
          );
        }
        initialLanguage = language;
        // We save it so the rest of the app uses this language.
        await localDataSource.saveLanguageIsoCode(currentLanguageCode);
        break;
      }
    }
  }

  final LocalizationDelegate localizationDelegate = await locale
      .getLocalizationDelegate();

  final Language currentLanguage = Language.fromIsoLanguageCode(
    localizationDelegate.currentLocale.languageCode,
  );

  if (initialLanguage != currentLanguage) {
    final Locale savedLocale = localeFromString(
      initialLanguage.isoLanguageCode,
    );

    localizationDelegate.changeLocale(savedLocale);

    // Notify listeners that the savedLocale has changed so they can update.
    localizationDelegate.onLocaleChanged?.call(savedLocale);
  }

  Map<String, WidgetBuilder> routeMap = <String, WidgetBuilder>{
    AppRoute.home.path: (BuildContext _) => const BlocProvider<ChatBloc>(
      create: _createChatBloc,
      child: BlocListener<ChatBloc, ChatState>(
        listener: _onChatStateChanged,
        child: AIChatBox(),
      ),
    ),
    AppRoute.about.path: (BuildContext _) => const AboutPage(),
    AppRoute.faq.path: (BuildContext _) => const FaqPage(),
    AppRoute.privacy.path: (BuildContext _) => const PrivacyPage(),
    AppRoute.support.path: (BuildContext _) {
      return SupportPage(preferences: preferences);
    },
  };

  runApp(
    LocalizedApp(
      localizationDelegate,
      BetterFeedback(
        feedbackBuilder:
            (
              BuildContext _,
              OnSubmit onSubmit,
              ScrollController? scrollController,
            ) {
              return FeedbackForm(
                onSubmit: onSubmit,
                scrollController: scrollController,
              );
            },
        theme: FeedbackThemeData(feedbackSheetColor: Colors.grey.shade50),
        child: LaoziAiApp(routeMap: routeMap),
      ),
    ),
  );
}

ChatBloc _createChatBloc(BuildContext _) {
  return GetIt.I.get<ChatBloc>()..add(const LoadHomeEvent());
}

void _onChatStateChanged(BuildContext context, ChatState state) {
  if (state is ChatInitial) {
    final Language currentLanguage = Language.fromIsoLanguageCode(
      LocalizedApp.of(context).delegate.currentLocale.languageCode,
    );
    final Language savedLanguage = state.language;
    if (currentLanguage != savedLanguage) {
      changeLocale(context, savedLanguage.isoLanguageCode)
      // The returned value in `then` is always `null`.
      .then((Object? _) {
        if (context.mounted) {
          context.read<ChatBloc>().add(ChangeLanguageEvent(savedLanguage));
        }
      });
    }
  }
}
