import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:laozi_ai/application_services/blocs/chat_bloc.dart';
import 'package:laozi_ai/router/app_route.dart';
import 'package:laozi_ai/ui/ai_chatbox.dart';

Map<String, WidgetBuilder> routeMap = <String, WidgetBuilder>{
  AppRoute.home.path: (_) => BlocProvider<ChatBloc>(
    create: (_) => GetIt.I.get<ChatBloc>()..add(const LoadHomeEvent()),
    child: const AIChatBox(),
  ),
};