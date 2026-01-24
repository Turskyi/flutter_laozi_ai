import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laozi_ai/application_services/blocs/chat/chat_bloc.dart';
import 'package:laozi_ai/application_services/blocs/support/support_bloc.dart';
import 'package:laozi_ai/router/app_route.dart';
import 'package:laozi_ai/ui/about/about_page.dart';
import 'package:laozi_ai/ui/chat/ai_chatbox.dart';
import 'package:laozi_ai/ui/faq/faq_page.dart';
import 'package:laozi_ai/ui/privacy/privacy_page.dart';
import 'package:laozi_ai/ui/support/support_page.dart';

Map<String, WidgetBuilder> buildAppRoutes({
  required ChatBloc chatBloc,
  required SupportBloc supportBloc,
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
  };
}
