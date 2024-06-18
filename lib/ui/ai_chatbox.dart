import 'dart:io';

import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/application_services/blocs/chat_bloc.dart';
import 'package:laozi_ai/res/constants.dart' as constants;
import 'package:laozi_ai/ui/app_bar/wave_app_bar.dart';
import 'package:laozi_ai/ui/chat_messages_list.dart';
import 'package:laozi_ai/ui/language_selector.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class AIChatBox extends StatefulWidget {
  const AIChatBox({super.key});

  @override
  State<AIChatBox> createState() => _AIChatBoxState();
}

class _AIChatBoxState extends State<AIChatBox> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (_, ChatState state) {
        if (state is LoadingHomeState) {
          return Scaffold(
            appBar: const WaveAppBar(actions: <Widget>[LanguageSelector()]),
            body: Center(
              child: SpinKitFadingCircle(
                color: Theme.of(context).colorScheme.primary,
                size: 200.0,
              ),
            ),
          );
        }
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: WaveAppBar(
            title: translate('title'),
            actions: <Widget>[
              if (state.messages.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.bug_report_outlined),
                  onPressed: _onBugReportPressed,
                ),
              // Use the `LanguageSelector` widget as an action.
              const LanguageSelector(),
            ],
          ),
          body: DecoratedBox(
            decoration: BoxDecoration(
              // Build background picture.
              image: state.messages.isNotEmpty
                  ? const DecorationImage(
                      opacity: 0.5,
                      image: AssetImage(constants.backgroundImagePath),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Column(
              children: <Widget>[
                const Expanded(child: ChatMessagesList()),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                            hintText: translate('chat.askSomething'),
                            border: const OutlineInputBorder(),
                            fillColor: Colors.black,
                            filled: true,
                          ),
                        ),
                      ),
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _textEditingController,
                        child: BlocBuilder<ChatBloc, ChatState>(
                          builder: (_, ChatState state) {
                            return state is SentMessageState
                                ? const CircularProgressIndicator()
                                : const Icon(Icons.send);
                          },
                        ),
                        builder:
                            (_, TextEditingValue value, Widget? iconWidget) {
                          return IconButton(
                            icon: iconWidget ?? const SizedBox(),
                            onPressed: value.text.isNotEmpty
                                ? _handleSendMessage
                                : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _handleSendMessage() {
    context.read<ChatBloc>().add(SendMessageEvent(_textEditingController.text));
    _textEditingController.clear();
  }

  //TODO: move to ChatBloc
  Future<void> _onBugReportPressed() => PackageInfo.fromPlatform().then(
        (PackageInfo packageInfo) => BetterFeedback.of(context).show(
          (UserFeedback feedback) => _sendFeedback(
            feedback: feedback,
            packageInfo: packageInfo,
          ),
        ),
      );

  Future<void> _sendFeedback({
    required UserFeedback feedback,
    required PackageInfo packageInfo,
  }) =>
      _writeImageToStorage(feedback.screenshot)
          .then((String screenshotFilePath) {
        return FlutterEmailSender.send(
          Email(
            body: '${feedback.text}\n\nApp id: ${packageInfo.packageName}\n'
                'App version: ${packageInfo.version}\n'
                'Build number: ${packageInfo.buildNumber}',
            subject: '${translate('app_feedback')}: '
                '${packageInfo.appName}',
            recipients: <String>[constants.supportEmail],
            attachmentPaths: <String>[screenshotFilePath],
          ),
        );
      });

  Future<String> _writeImageToStorage(Uint8List feedbackScreenshot) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
  }
}
