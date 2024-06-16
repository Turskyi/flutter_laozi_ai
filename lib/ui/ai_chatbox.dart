import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/application_services/blocs/chat_bloc.dart';
import 'package:laozi_ai/res/constants.dart' as constants;
import 'package:laozi_ai/ui/app_bar/wave_app_bar.dart';
import 'package:laozi_ai/ui/chat_messages_list.dart';

class AIChatBox extends StatefulWidget {
  const AIChatBox({super.key});

  @override
  State<AIChatBox> createState() => _AIChatBoxState();
}

class _AIChatBoxState extends State<AIChatBox> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: WaveAppBar(title: translate('title')),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (_, ChatState state) {
          return DecoratedBox(
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
          );
        },
      ),
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
}
