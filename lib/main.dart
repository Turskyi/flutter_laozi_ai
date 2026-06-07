import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:laozi_ai/application_services/blocs/chat/chat_bloc.dart';
import 'package:laozi_ai/application_services/blocs/settings/settings_bloc.dart';
import 'package:laozi_ai/application_services/blocs/support/support_bloc.dart';
import 'package:laozi_ai/di/injector.dart' as di;
import 'package:laozi_ai/domain_services/settings_repository.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:laozi_ai/localization/localization_delelegate_getter.dart'
    as locale;
import 'package:laozi_ai/res/app_theme.dart' as theme;
import 'package:laozi_ai/router/app_router.dart' as router;
import 'package:laozi_ai/ui/feedback/feedback_form.dart';
import 'package:laozi_ai/ui/laozi_ai_app.dart';

/// The [main] is the ultimate detail — the lowest-level policy.
void main() async {
  // Ensure that the Flutter engine is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection.
  final GetIt dependencies = await di.injectDependencies();

  final SettingsRepository settingsRepository = dependencies
      .get<SettingsRepository>();

  // Get the language that should be used initially.
  // Our SettingsRepositoryImpl now correctly prioritizes URL on Web.
  final Language initialLanguage = settingsRepository.getLanguage();

  final ChatBloc chatBloc = dependencies.get<ChatBloc>();
  final SupportBloc supportBloc = dependencies.get<SupportBloc>();
  final SettingsBloc settingsBloc = dependencies.get<SettingsBloc>();

  // Initialize localization with the same initial language.
  final LocalizationDelegate localizationDelegate = await locale
      .getLocalizationDelegate(initialLocale: initialLanguage.isoLanguageCode);

  // We MUST ensure the delegate's current locale matches the repository's
  // language before starting the app. This prevents the "right selector,
  // wrong text" issue which happens when the Bloc starts in one language
  // and the Delegate in another, and they don't sync until a user action.
  if (localizationDelegate.currentLocale.languageCode !=
      initialLanguage.isoLanguageCode) {
    await localizationDelegate.changeLocale(
      Locale(initialLanguage.isoLanguageCode),
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
            final Brightness brightness = isDark
                ? Brightness.dark
                : Brightness.light;
            final ThemeData themeData = theme.createAppTheme(brightness);
            final ColorScheme colorScheme = themeData.colorScheme;

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
                brightness: brightness,
                colorScheme: colorScheme,
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

void _onSettingsStateChanged(BuildContext context, SettingsState state) {
  final LocalizationDelegate delegate = LocalizedApp.of(context).delegate;
  final Language currentLanguage = Language.fromIsoLanguageCode(
    delegate.currentLocale.languageCode,
  );
  final Language savedLanguage = state.language;

  if (currentLanguage != savedLanguage) {
    changeLocale(context, savedLanguage.isoLanguageCode);
  }
}
