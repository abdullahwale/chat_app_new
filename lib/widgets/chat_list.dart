import 'package:chat_app_new/widgets/chat_message.dart';
import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  final List<Map<String, dynamic>> snapshot;
  const ChatList({Key key, this.snapshot}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        reverse: true,
        itemCount: snapshot.length,
        itemBuilder: (_, int index) => ChatMessage(
          snapshot: snapshot[index],
        ),
      ),
    );
  }
}
