import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:laozi_ai/application_services/blocs/chat/chat_bloc.dart';
import 'package:laozi_ai/application_services/blocs/settings/settings_bloc.dart';
import 'package:laozi_ai/application_services/blocs/support/support_bloc.dart';
import 'package:laozi_ai/di/injector.dart' as di;
import 'package:laozi_ai/domain_services/settings_repository.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:laozi_ai/localization/localization_delelegate_getter.dart'
    as locale;
import 'package:laozi_ai/router/app_route.dart';
import 'package:laozi_ai/router/app_router.dart' as router;
import 'package:laozi_ai/ui/feedback/feedback_form.dart';
import 'package:laozi_ai/ui/laozi_ai_app.dart';

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
  final GetIt dependencies = await di.injectDependencies();

  final ChatBloc chatBloc = dependencies.get<ChatBloc>();
  final SupportBloc supportBloc = dependencies.get<SupportBloc>();
  final SettingsBloc settingsBloc = dependencies.get<SettingsBloc>();

  final SettingsRepository settingsRepository = dependencies
      .get<SettingsRepository>();

  Language initialLanguage = settingsRepository.getLanguage();

  if (kIsWeb) {
    // Retrieves the host name (e.g., "localhost" or "uk.daoizm.online").
    initialLanguage = await _resolveInitialLanguageFromUrl(
      initialLanguage: initialLanguage,
      settingsRepository: settingsRepository,
    );
  }

  final LocalizationDelegate localizationDelegate = await locale
      .getLocalizationDelegate();

  final Language currentLanguage = Language.fromIsoLanguageCode(
    localizationDelegate.currentLocale.languageCode,
  );

  if (initialLanguage != currentLanguage) {
    _applyInitialLocale(
      initialLanguage: initialLanguage,
      localizationDelegate: localizationDelegate,
    );
  }

  final Map<String, WidgetBuilder> routeMap = router.buildAppRoutes(
    chatBloc: chatBloc,
    supportBloc: supportBloc,
  );

  runApp(
    LocalizedApp(
      localizationDelegate,
      BlocProvider<SettingsBloc>(
        create: (BuildContext _) => settingsBloc,
        child: BlocBuilder<SettingsBloc, SettingsState>(
          buildWhen: _shouldRebuildTheme,
          builder: (BuildContext _, SettingsState state) {
            final bool isDark = state.isDark;
            return BetterFeedback(
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
              theme: FeedbackThemeData(
                feedbackSheetColor: isDark
                    ? const Color(0xFF1C1B1F)
                    : const Color(0xFFFEF7FF),
                brightness: isDark ? Brightness.dark : Brightness.light,
              ),
              child: BlocListener<SettingsBloc, SettingsState>(
                listener: _onSettingsStateChanged,
                child: LaoziAiApp(routeMap: routeMap),
              ),
            );
          },
        ),
      ),
    ),
  );
}

bool _shouldRebuildTheme(SettingsState previous, SettingsState current) {
  return previous.themeMode != current.themeMode;
}

void _applyInitialLocale({
  required Language initialLanguage,
  required LocalizationDelegate localizationDelegate,
}) {
  final Locale savedLocale = localeFromString(initialLanguage.isoLanguageCode);

  localizationDelegate.changeLocale(savedLocale);

  // Notify listeners that the savedLocale has changed so they can update.
  localizationDelegate.onLocaleChanged?.call(savedLocale);
}

Future<Language> _resolveInitialLanguageFromUrl({
  required Language initialLanguage,
  required SettingsRepository settingsRepository,
}) async {
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
      await settingsRepository.saveLanguageIsoCode(currentLanguageCode);
      break;
    }
  }
  return initialLanguage;
}

void _onSettingsStateChanged(BuildContext context, SettingsState state) {
  final Language currentLanguage = Language.fromIsoLanguageCode(
    LocalizedApp.of(context).delegate.currentLocale.languageCode,
  );
  final Language savedLanguage = state.language;
  if (currentLanguage != savedLanguage) {
    changeLocale(context, savedLanguage.isoLanguageCode)
    // The returned value in `then` is always `null`.
    .then((Object? _) {
      if (context.mounted) {
        context.read<SettingsBloc>().add(
          ChangeLanguageSettingsEvent(savedLanguage),
        );
      }
    });
  }
}
