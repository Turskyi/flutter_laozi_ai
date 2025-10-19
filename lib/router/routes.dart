import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:laozi_ai/application_services/blocs/chat_bloc.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:laozi_ai/router/app_route.dart';
import 'package:laozi_ai/ui/about/about_page.dart';
import 'package:laozi_ai/ui/chat/ai_chatbox.dart';
import 'package:laozi_ai/ui/faq/faq_page.dart';
import 'package:laozi_ai/ui/privacy/privacy_page.dart';
import 'package:laozi_ai/ui/support/support_page.dart';

Map<String, WidgetBuilder> routeMap = <String, WidgetBuilder>{
  AppRoute.home.path: (BuildContext _) => BlocProvider<ChatBloc>(
        create: (BuildContext _) {
          return GetIt.I.get<ChatBloc>()..add(const LoadHomeEvent());
        },
        child: BlocListener<ChatBloc, ChatState>(
          listener: (BuildContext context, ChatState state) {
            if (state is ChatInitial) {
              final Language currentLanguage = Language.fromIsoLanguageCode(
                LocalizedApp.of(context).delegate.currentLocale.languageCode,
              );
              final Language savedLanguage = state.language;
              if (currentLanguage != savedLanguage) {
                changeLocale(context, savedLanguage.isoLanguageCode)
                    // The returned value in `then` is always `null`.
                    .then((_) {
                  if (context.mounted) {
                    context
                        .read<ChatBloc>()
                        .add(ChangeLanguageEvent(savedLanguage));
                  }
                });
              }
            }
          },
          child: const AIChatBox(),
        ),
      ),
  AppRoute.about.path: (BuildContext _) => const AboutPage(),
  AppRoute.faq.path: (BuildContext _) => const FaqPage(),
  AppRoute.privacy.path: (BuildContext _) => const PrivacyPage(),
  AppRoute.support.path: (BuildContext _) => const SupportPage(),
};
