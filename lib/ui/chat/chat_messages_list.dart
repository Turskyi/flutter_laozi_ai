import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/application_services/blocs/chat_bloc.dart';
import 'package:laozi_ai/res/constants.dart' as constants;
import 'package:laozi_ai/ui/chat/chat_message.dart';

class ChatMessagesList extends StatefulWidget {
  const ChatMessagesList({super.key});

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (BuildContext context, ChatState state) {
        final int itemCount = state is ChatError
            // Add extra space for the error message.
            ? state.messages.length + 1
            : state.messages.length;
        if (state.messages.isEmpty) {
          // If there are no messages, show the welcome message.
          const double laoziSize = 300.0;
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
              left: 32.0,
              right: 32.0,
              top: 32.0,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Resizes the image when the keyboard opens up.
                  Image.asset(
                    // Path to the image asset.
                    constants.laoziImagePath,
                    width: laoziSize,
                    height: laoziSize,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    translate('chat.sendMessageToStartChat'),
                    style: Theme.of(context).textTheme.headlineSmall,
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
        // Whenever the state updates, check if there's a new message and
        // scroll to the bottom.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
        return ListView.builder(
          controller: _scrollController,
          itemCount: itemCount,
          itemBuilder: (_, int index) {
            // Check if the current item is the last one and the state
            // is `ChatError`.
            if (index == state.messages.length && state is ChatError) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 15.0,
                ),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  // Improved contrast.
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  title: SelectableText(
                    state.errorMessage,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () => context
                        .read<ChatBloc>()
                        .add(const RetrySendMessageEvent()),
                  ),
                ),
              );
            }
            // Otherwise, return the `ChatMessage` widget.
            return ChatMessage(message: state.messages[index]);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
