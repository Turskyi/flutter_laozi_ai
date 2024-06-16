import 'package:flutter/material.dart';
import 'package:laozi_ai/entities/message.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          message.isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: <Widget>[
        if (message.isAi)
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            //TODO: replace with Laozi icon.
            child: Icon(Icons.android),
          ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: message.isAi ? Colors.grey.shade300 : Colors.blue.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${message.content}'
                  // Replace escaped newlines with actual newlines.
                  .replaceAll(r'\n', '\n')
                  // Replace escaped quotes with actual quotes.
                  .replaceAll(r'\"', '"'),
              style: TextStyle(
                color: message.isAi ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
