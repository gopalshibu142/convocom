import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:convocom/firebasefn.dart';
import 'package:convocom/global.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatContainer extends StatefulWidget {
  var name, messages;
  ChatContainer({super.key, required this.name, required this.messages});

  @override
  State<ChatContainer> createState() =>
      _ChatContainerState(this.name, this.messages);
}

class _ChatContainerState extends State<ChatContainer> {
  var name;
  _ChatContainerState(this.name, this._messages);
  late DatabaseReference dbref;

  @override
  void initState() {
    dbref = FirebaseDatabase.instance.ref();
    dbref.child('messages').child(convID).onValue.listen((event) async {
      _messages = await getMessage(name);
      setState(() {
        print(event.snapshot.value);
        print('object');
      });
    });
    // TODO: implement initState
    super.initState();
  }

  List<types.Message> _messages;
  final _user = types.User(id: curuser.uid);
  //final _notuser = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3bc');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(name),
      ),
      body: Chat(
        theme: DarkChatTheme(),
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
      print(message.updatedAt);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );
    //print(DateTime.now().toString().replaceAll(':', '').replaceAll('.', '').replaceAll('-', '').replaceAll(' '', ''));
    addMessagetoDB(textMessage, name);
    _addMessage(textMessage);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
