import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laozi_ai/application_services/blocs/chat/chat_bloc.dart';
import 'package:laozi_ai/application_services/blocs/support/support_bloc.dart';
import 'package:laozi_ai/domain_services/settings_repository.dart';
import 'package:laozi_ai/entities/manuscript_reader_arguments.dart';
import 'package:laozi_ai/router/app_route.dart';
import 'package:laozi_ai/ui/about/about_page.dart';
import 'package:laozi_ai/ui/chat/ai_chatbox.dart';
import 'package:laozi_ai/ui/faq/faq_page.dart';
import 'package:laozi_ai/ui/manuscript/manuscript_reader.dart';
import 'package:laozi_ai/ui/manuscript/manuscript_saved_page.dart';
import 'package:laozi_ai/ui/manuscript/manuscript_search_page.dart';
import 'package:laozi_ai/ui/privacy/privacy_page.dart';
import 'package:laozi_ai/ui/support/support_page.dart';

Map<String, WidgetBuilder> buildAppRoutes({
  required ChatBloc chatBloc,
  required SupportBloc supportBloc,
  required SettingsRepository settingsRepository,
}) {
  return <String, WidgetBuilder>{
    AppRoute.home.path: (BuildContext _) => BlocProvider<ChatBloc>(
      create: (BuildContext _) {
        return chatBloc..add(const LoadHomeEvent());
      },
      child: const AIChatBox(),
    ),
    AppRoute.about.path: (BuildContext _) => const AboutPage(),
    AppRoute.faq.path: (BuildContext _) => const FaqPage(),
    AppRoute.privacy.path: (BuildContext _) => const PrivacyPage(),
    AppRoute.support.path: (BuildContext _) {
      return BlocProvider<SupportBloc>(
        create: (BuildContext _) => supportBloc,
        child: const SupportPage(),
      );
    },
    AppRoute.manuscript.path: (BuildContext context) {
      final Object? args = ModalRoute.of(context)?.settings.arguments;
      int initialPage = 1;
      String? highlightQuery;

      if (args is int) {
        initialPage = args;
      } else if (args is ManuscriptReaderArguments) {
        initialPage = args.pageNumber;
        highlightQuery = args.highlightQuery;
      } else {
        initialPage = settingsRepository.getLastManuscriptPage();
      }

      return ManuscriptReader(
        initialPage: initialPage,
        highlightQuery: highlightQuery,
        settingsRepository: settingsRepository,
      );
    },
    AppRoute.manuscriptSaved.path: (BuildContext _) {
      return ManuscriptSavedPage(settingsRepository: settingsRepository);
    },
    AppRoute.manuscriptSearch.path: (BuildContext _) {
      return const ManuscriptSearchPage();
    },
  };
}
