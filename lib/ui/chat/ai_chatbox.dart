import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/application_services/blocs/chat_bloc.dart';
import 'package:laozi_ai/application_services/blocs/settings_bloc.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:laozi_ai/res/constants.dart' as constants;
import 'package:laozi_ai/router/app_route.dart';
import 'package:laozi_ai/ui/chat/widgets/chat_messages_list.dart';
import 'package:laozi_ai/ui/widgets/app_bar/wave_app_bar.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AIChatBox extends StatefulWidget {
  const AIChatBox({super.key});

  @override
  State<AIChatBox> createState() => _AIChatBoxState();
}

class _AIChatBoxState extends State<AIChatBox> {
  final TextEditingController _textEditingController = TextEditingController();
  final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();
  FeedbackController? _feedbackController;
  Object? _initialLanguage;

  @override
  void didChangeDependencies() {
    _feedbackController = BetterFeedback.of(context);
    // Extract the arguments from the current ModalRoute
    // settings and cast them as `Language`.
    if (_initialLanguage == null) {
      _initialLanguage = ModalRoute.of(context)?.settings.arguments;
      if (_initialLanguage is Language) {
        final Language savedLanguage = _initialLanguage as Language;
        final Language currentLanguage = Language.fromIsoLanguageCode(
          LocalizedApp.of(context).delegate.currentLocale.languageCode,
        );
        if (currentLanguage != savedLanguage) {
          changeLocale(context, savedLanguage.isoLanguageCode)
          // The returned value in `then` is always `null`.
          .then((Object? _) {
            if (mounted) {
              context.read<SettingsBloc>().add(
                ChangeLanguageSettingsEvent(savedLanguage),
              );
            }
          });
        }
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext _) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (BuildContext _, SettingsState settingsState) {
        return BlocConsumer<ChatBloc, ChatState>(
          listener: _chatStateListener,
          builder: (BuildContext context, ChatState chatState) {
            final Language currentLanguage = _initialLanguage is Language
                ? (_initialLanguage as Language)
                : settingsState.language;
            final ThemeData themeData = Theme.of(context);
            final ColorScheme colorScheme = themeData.colorScheme;

            return Scaffold(
              extendBodyBehindAppBar: true,
              drawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    DrawerHeader(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(translate('title')),
                          FutureBuilder<PackageInfo>(
                            future: _packageInfo,
                            builder:
                                (
                                  BuildContext context,
                                  AsyncSnapshot<PackageInfo> snapshot,
                                ) {
                                  if (snapshot.hasData) {
                                    final PackageInfo? data = snapshot.data;
                                    if (data != null) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Text(
                                          '${translate('app_version')} '
                                          '${data.version}',
                                          textAlign: TextAlign.center,
                                          style: themeData.textTheme.bodySmall,
                                        ),
                                      );
                                    }
                                  }
                                  return const SizedBox.shrink();
                                },
                          ),
                        ],
                      ),
                    ),
                    if (chatState.messages.isNotEmpty) ...<Widget>[
                      ListTile(
                        title: Text(translate('chat.startNewConversation')),
                        onTap: _onDrawerStartNewConversation,
                      ),
                      const Divider(),
                    ],
                    ListTile(
                      title: Text(translate('about')),
                      onTap: _openAbout,
                    ),
                    ListTile(title: Text(translate('faq')), onTap: _openFaq),
                    ListTile(
                      title: Text(translate('privacy')),
                      onTap: _openPrivacy,
                    ),
                    ListTile(
                      title: Text(translate('support')),
                      onTap: _openSupport,
                    ),
                    const Divider(),
                    ListTile(
                      title: Text(translate('report_bug')),
                      onTap: _onBugReportPressed,
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.language),
                      title: Text(translate('language')),
                      children: Language.values.map((Language language) {
                        return ListTile(
                          leading: Text(language.flag),
                          title: Text(translate(language.key)),
                          selected: currentLanguage == language,
                          onTap: () => _onLanguageSelected(language),
                        );
                      }).toList(),
                    ),
                    SwitchListTile(
                      secondary: Icon(
                        settingsState.themeMode == ThemeMode.light
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                      title: Text(
                        settingsState.themeMode == ThemeMode.light
                            ? translate('theme.light')
                            : translate('theme.dark'),
                      ),
                      value: settingsState.themeMode == ThemeMode.light,
                      onChanged: (bool value) {
                        context.read<SettingsBloc>().add(
                          ChangeThemeModeSettingsEvent(
                            value ? ThemeMode.light : ThemeMode.dark,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              appBar: WaveAppBar(
                title: translate('title'),
                actions: <Widget>[
                  if (chatState.messages.isNotEmpty) ...<Widget>[
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _onStartNewConversation,
                      tooltip: translate('chat.startNewConversation'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: _onShareConversationPressed,
                    ),
                    IconButton(
                      icon: const Icon(Icons.bug_report_outlined),
                      onPressed: _onBugReportPressed,
                    ),
                  ],
                ],
              ),
              body: DecoratedBox(
                decoration: BoxDecoration(
                  // Build background picture.
                  image: chatState.messages.isNotEmpty
                      ? const DecorationImage(
                          opacity: 0.5,
                          image: AssetImage(constants.backgroundImagePath),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: chatState is LoadingHomeState
                          ? Stack(
                              children: <Widget>[
                                const ChatMessagesList(),
                                SpinKitFadingCircle(
                                  color: colorScheme.primary,
                                  size: 200.0,
                                ),
                              ],
                            )
                          : const ChatMessagesList(),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          bottom: 8.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                enabled: chatState is! SentMessageState,
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                  hintText: translate('chat.askSomething'),
                                  border: const OutlineInputBorder(),
                                  fillColor: colorScheme.surface,
                                  filled: true,
                                ),
                                onSubmitted: (String value) =>
                                    _submitChatMessage(
                                      value,
                                      settingsState.language,
                                    ),
                              ),
                            ),
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _textEditingController,
                              child: chatState is SentMessageState
                                  ? const CircularProgressIndicator()
                                  : const Icon(Icons.send),
                              builder:
                                  (
                                    BuildContext _,
                                    TextEditingValue value,
                                    Widget? iconWidget,
                                  ) {
                                    return IconButton(
                                      icon: iconWidget ?? const SizedBox(),
                                      onPressed: value.text.isNotEmpty
                                          ? () => _handleSendMessage(
                                              settingsState.language,
                                            )
                                          : null,
                                    );
                                  },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _feedbackController?.removeListener(_onFeedbackChanged);
    super.dispose();
  }

  void _showFeedbackUi() {
    _feedbackController?.show((UserFeedback feedback) {
      context.read<ChatBloc>().add(SubmitFeedbackEvent(feedback));
    });
    _feedbackController?.addListener(_onFeedbackChanged);
  }

  void _onFeedbackChanged() {
    final bool? isVisible = _feedbackController?.isVisible;
    if (isVisible == false) {
      _feedbackController?.removeListener(_onFeedbackChanged);
      context.read<ChatBloc>().add(const ClosingFeedbackEvent());
    }
  }

  void _handleSendMessage(Language language) {
    context.read<ChatBloc>().add(
      SendMessageEvent(
        message: _textEditingController.text,
        language: language,
      ),
    );
    _textEditingController.clear();
  }

  void _onBugReportPressed() {
    context.read<ChatBloc>().add(const BugReportPressedEvent());
  }

  void _onShareConversationPressed() {
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is RenderBox?) {
      final RenderBox? box = renderObject;
      final Rect? sharePositionOrigin = box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : null;
      context.read<ChatBloc>().add(
        ShareConversationEvent(sharePositionOrigin: sharePositionOrigin),
      );
    } else {
      context.read<ChatBloc>().add(const ShareConversationEvent());
    }
  }

  void _submitChatMessage(String value, Language language) {
    if (value.isNotEmpty) {
      _handleSendMessage(language);
    }
  }

  void _chatStateListener(BuildContext _, ChatState state) {
    if (state is FeedbackState) {
      _showFeedbackUi();
    } else if (state is FeedbackSent) {
      _notifyFeedbackSent();
    } else if (state is ShareError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _notifyFeedbackSent() {
    BetterFeedback.of(context).hide();
    // Let user know that his feedback is sent.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(translate('feedback.feedbackSent')),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openAbout() {
    Navigator.of(context).pushNamed(AppRoute.about.path);
  }

  void _openFaq() {
    Navigator.of(context).pushNamed(AppRoute.faq.path);
  }

  void _openPrivacy() {
    Navigator.of(context).pushNamed(AppRoute.privacy.path);
  }

  void _openSupport() {
    Navigator.of(context).pushNamed(AppRoute.support.path);
  }

  void _onLanguageSelected(Language newLanguage) {
    changeLocale(context, newLanguage.isoLanguageCode)
    // The returned value in `then` is always `null`.
    .then((Object? _) {
      if (mounted) {
        _initialLanguage = newLanguage;
        context.read<SettingsBloc>().add(
          ChangeLanguageSettingsEvent(newLanguage),
        );
      }
    });
  }

  void _onDrawerStartNewConversation() {
    Navigator.of(context).pop();
    _onStartNewConversation();
  }

  void _onStartNewConversation() {
    context.read<ChatBloc>().add(const ClearConversationEvent());
  }
}
