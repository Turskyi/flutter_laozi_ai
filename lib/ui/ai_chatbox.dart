import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/application_services/blocs/chat_bloc.dart';
import 'package:laozi_ai/ui/chat_message.dart';

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
      appBar: AppBar(
        title: Text(translate('title')),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (_, ChatState state) {
                final int itemCount = state is ChatError
                    // Add extra space for the error message.
                    ? state.messages.length + 1
                    : state.messages.length;
                if (state.messages.isEmpty) {
                  // If there are no messages, show the welcome message.
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //TODO: replace icon with the Laozi ai icon.
                          // Placeholder for Bot icon.
                          const Icon(Icons.android, size: 28),
                          const SizedBox(height: 24),
                          Text(
                            translate('chat.sendMessageToStartChat'),
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            translate('chat.youCanAskAnyQuestionAbout'),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: itemCount,
                  itemBuilder: (_, int index) {
                    // Check if the current item is the last one and the state
                    // is `ChatError`.
                    if (index == state.messages.length && state is ChatError) {
                      // Return a widget that displays the error message.
                      return ListTile(
                        title: Text(
                          state.errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    // Otherwise, return the `ChatMessage` widget.
                    return ChatMessage(message: state.messages[index]);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: translate('chat.askSomething'),
                      border: const OutlineInputBorder(),
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
                  builder: (_, TextEditingValue value, Widget? iconWidget) {
                    return IconButton(
                      icon: iconWidget ?? const SizedBox(),
                      onPressed:
                          value.text.isNotEmpty ? _handleSendMessage : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
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
