import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/application_services/blocs/settings/settings_bloc.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:laozi_ai/localization/localization_delelegate_getter.dart'
    as locale;
import 'package:laozi_ai/ui/laozi_ai_app.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_home_widget_service.dart';
import 'mock_settings_repository.dart';

void main() {
  late LocalizationDelegate localizationDelegate;
  late MockSettingsRepository settingsRepository;
  late MockHomeWidgetService homeWidgetService;
  late SettingsBloc settingsBloc;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    localizationDelegate = await locale.getLocalizationDelegate(
      initialLocale: Language.en.isoLanguageCode,
    );
  });

  setUp(() {
    settingsRepository = MockSettingsRepository();
    homeWidgetService = MockHomeWidgetService();
    when(() => settingsRepository.getLanguage()).thenReturn(Language.en);
    when(() => settingsRepository.getThemeMode()).thenReturn(ThemeMode.light);
    when(
      () => homeWidgetService.updateHomeWidgetLanguage(any()),
    ).thenAnswer((_) async {});
    settingsBloc = SettingsBloc(settingsRepository, homeWidgetService);
  });

  tearDown(() async {
    await settingsBloc.close();
  });

  testWidgets('deep link opens one manuscript route and Back returns to Home', (
    WidgetTester tester,
  ) async {
    final StreamController<Uri> linkController = StreamController<Uri>();
    addTearDown(linkController.close);

    final Map<String, WidgetBuilder> routeMap = <String, WidgetBuilder>{
      '/': (BuildContext context) => const Scaffold(body: Text('Home')),
      '/manuscript': (BuildContext context) {
        final Object? page = ModalRoute.of(context)?.settings.arguments;
        return Scaffold(body: Text('Manuscript page $page'));
      },
    };

    await tester.pumpWidget(
      LocalizedApp(
        localizationDelegate,
        BlocProvider<SettingsBloc>.value(
          value: settingsBloc,
          child: LaoziAiApp(
            routeMap: routeMap,
            uriLinkStream: linkController.stream,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);

    linkController.add(Uri.parse('https://daoismonline.com/manuscript/11'));
    await tester.pumpAndSettle();

    expect(find.text('Manuscript page 11'), findsOneWidget);
    expect(find.text('Home'), findsNothing);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Manuscript page 11'), findsNothing);
  });
}
