import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:convocom/firebasefn.dart';
import 'package:convocom/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quickalert/quickalert.dart';

class ChatContainer extends StatefulWidget {
  var messages;
  PersonDetail person;
  ChatContainer({super.key, required this.person, required this.messages});

  @override
  State<ChatContainer> createState() =>
      _ChatContainerState(this.person, this.messages);
}

class _ChatContainerState extends State<ChatContainer> {
  PersonDetail person;
  _ChatContainerState(this.person, this._messages);
  late DatabaseReference dbref;
  void init() {
    dbref.child('connections').child(convID).set('inactive');
  }

  @override
  void initState() {
    //theme.defaulttheme();
    dbref = FirebaseDatabase.instance.ref();
    dbref.child('messages').child(convID).onValue.listen((event) async {
      _messages = await getMessage(person.name);
      setState(() {
        //print(event.snapshot.value);
        // print('object');
      });
    });
    init();
    // TODO: implement initState
    super.initState();
  }

  List<types.Message> _messages;
  final _user = types.User(id: curuser.uid);

  //final _notuser = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3bc');
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dbref.child('connections').child(convID).set('active');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 49,
          leading: CircleAvatar(
            foregroundImage: Image.network(person.profile).image,
          ),
          backgroundColor: theme.lvl1,
          title: Text(person.name),
        ),
        body: Chat(
          onMessageLongPress: (context, p1) {
            var b = QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              title: 'do you want to delete this message',
              cancelBtnText: 'no',
              confirmBtnText: 'yes',
              onConfirmBtnTap: () {
                _messages.remove(p1);
                deleteMessage(p1.id, person.name);
                setState(() {});
                Navigator.pop(context);
              },
            );
          },
          theme: DarkChatTheme(
              backgroundColor: theme.lvl0,
              primaryColor: theme.lvl2,
              secondaryColor: theme.lvl1),
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: _user,
        ),
      ),
    );
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
      //print(message.updatedAt);
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
    addMessagetoDB(textMessage, person.name);
    _addMessage(textMessage);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
