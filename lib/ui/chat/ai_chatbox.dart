import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/application_services/blocs/chat_bloc.dart';
import 'package:laozi_ai/res/constants.dart' as constants;
import 'package:laozi_ai/ui/chat/app_bar/wave_app_bar.dart';
import 'package:laozi_ai/ui/chat/chat_messages_list.dart';
import 'package:laozi_ai/ui/chat/language_selector.dart';

class AIChatBox extends StatefulWidget {
  const AIChatBox({super.key});

  @override
  State<AIChatBox> createState() => _AIChatBoxState();
}

class _AIChatBoxState extends State<AIChatBox> {
  final TextEditingController _textEditingController = TextEditingController();
  FeedbackController? _feedbackController;

  @override
  void didChangeDependencies() {
    _feedbackController = BetterFeedback.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (_, ChatState state) {
        if (state is FeedbackState) {
          _showFeedbackUi();
        } else if (state is FeedbackSent) {
          _notifyFeedbackSent();
        }
      },
      builder: (BuildContext context, ChatState state) {
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
                Expanded(
                  child: state is LoadingHomeState
                      ? Stack(
                          children: <Widget>[
                            const ChatMessagesList(),
                            SpinKitFadingCircle(
                              color: Theme.of(context).colorScheme.primary,
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
                            enabled: state is! SentMessageState,
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
                          child: state is SentMessageState
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.send),
                          builder: (
                            _,
                            TextEditingValue value,
                            Widget? iconWidget,
                          ) {
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
    _feedbackController?.dispose();
    super.dispose();
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

  void _showFeedbackUi() {
    _feedbackController?.show(
      (UserFeedback feedback) =>
          context.read<ChatBloc>().add(SubmitFeedbackEvent(feedback)),
    );
    _feedbackController?.addListener(_onFeedbackChanged);
  }

  void _onFeedbackChanged() {
    final bool? isVisible = _feedbackController?.isVisible;
    if (isVisible == false) {
      _feedbackController?.removeListener(_onFeedbackChanged);
      context.read<ChatBloc>().add(const ClosingFeedbackEvent());
    }
  }

  void _handleSendMessage() {
    context.read<ChatBloc>().add(SendMessageEvent(_textEditingController.text));
    _textEditingController.clear();
  }

  void _onBugReportPressed() =>
      context.read<ChatBloc>().add(const BugReportPressedEvent());
}
