import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:laozi_ai/application_services/blocs/chat_bloc.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:laozi_ai/router/app_route.dart';
import 'package:laozi_ai/ui/ai_chatbox.dart';

Map<String, WidgetBuilder> routeMap = <String, WidgetBuilder>{
  AppRoute.home.path: (_) => BlocProvider<ChatBloc>(
        create: (_) => GetIt.I.get<ChatBloc>()..add(const LoadHomeEvent()),
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
                  context
                      .read<ChatBloc>()
                      .add(ChangeLanguageEvent(savedLanguage));
                });
              }
            }
          },
          child: const AIChatBox(),
        ),
      ),
};
