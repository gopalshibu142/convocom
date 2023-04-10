import 'dart:ffi';

import 'package:convocom/firebasefn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:convocom/global.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

//import 'package:convocom/bricks/Widgets Example/bottom_nav_bar_curved.dart';

class Home extends StatefulWidget {
  late UserDetails user;
  Home({super.key, required UserDetails user}) {
    this.user = user;
  }

  @override
  State<Home> createState() => _HomeState(user);
}

class _HomeState extends State<Home> {
  late UserDetails user;
  late List<Widget> _widgetOptions;
  late PageController pagecontroller;
  var temp = 50.0;
  int _selectedIndex = 0;
  @override
  var usermail;
  _HomeState(user) {
    this.user = user;
  }
  late List people;
  void initState() {
    // user.auth.currentUser?.updateDisplayName("Gopal S");
    // user.auth.currentUser?.updatePhoneNumber("+917592806009" as PhoneAuthCredential);
    super.initState();
    pagecontroller = PageController();
    _widgetOptions = [home(), community(), profile()];
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: this._scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              user.signout(context);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              setState(() {
                this._scaffoldKey.currentState?.showBottomSheet(
                    (ctx) => buildBottomSheet(ctx, _scaffoldKey));
              });
            }),
        //bottomNavigationBar: BottomNavBarCurvedFb1() ,//Remember to add extendBody: true to scaffold!,
        bottomNavigationBar: GNav(
            //rippleColor: Colors.grey[300]!,
            // hoverColor: Colors.grey[100]!,
            selectedIndex: _selectedIndex,
            backgroundColor: Colors.black,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
                onPressed: () {
                  getMessage('Shravan ');
                },
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
                //pagecontroller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                pagecontroller.animateToPage(_selectedIndex,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOutExpo);
              });
            }),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pagecontroller,
          children: <Widget>[home(), community(), profile()],
        ));
  }

  Container home() => Container(
      color: Colors.black,
      height: double.infinity,
      child: FutureBuilder(
          future: getPeoplelist(),
          builder: (context, snapshot) {
            people = snapshot.data ?? [];
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: people.length,
                  itemBuilder: (BuildContext context, int index) {
                    // access element from list using index
                    // you can create and return a widget of your choice
                    return Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: double.infinity,
                      child: ListTile(
                        leading: CircleAvatar(
                          minRadius: 49,
                          backgroundColor: Colors.grey,
                          maxRadius: 50,
                          child: LottieBuilder.asset(
                            
                            'assets/avatar.json',
                            fit: BoxFit.fill,
                          ),
                        ),
                        title: Text(people[index]),
                        onTap: () async {
                          var messages = await getMessage(people[index]);
                          convID = await getConvId(people[index]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatContainer(
                                      name: people[index],
                                      messages: messages,
                                    )),
                          );
                        },
                      ),
                    );
                  });
            } else {
              return SizedBox(
                width: 200.0,
                height: 100.0,
                child: Shimmer.fromColors(
                  baseColor: Color.fromARGB(255, 48, 45, 45),
                  highlightColor: Color.fromARGB(255, 0, 0, 0),
                  child: ListView(
                    children: [
                      for (int i = 0; i <= 10;i++)
                        Container(
                          height: 100,
                          alignment: Alignment.center,
                          child: ListTile(
                            leading: CircleAvatar(
                              maxRadius: 50,
                            ),
                            title: Text('username'),
                          ),
                        )
                    ],
                  ),
                ),
              );
            }
          }));

  Container community() => Container();
  Widget profile() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 82,
            backgroundColor: Colors.green,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.black,
              child: Icon(
                FontAwesomeIcons.userPlus,
                size: 100,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text("email : ${user.auth.currentUser?.email}\n"),
          Text("name : ${user.auth.currentUser?.displayName}\n"),
          Text("phone : ${user.auth.currentUser?.phoneNumber}\n"),
          //Text("phone : ${user.auth.currentUser?.email}"),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

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
      setState(() async {
        print(event.snapshot.value);
        print('object');
        _messages = await getMessage(name);
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

Container buildBottomSheet(
    BuildContext ctx, GlobalKey<ScaffoldState> scaffold) {
  TextEditingController txt = TextEditingController();
  return Container(
    // color: Colors.red,
    height: 300,
    padding: EdgeInsets.all(50),
    child: ListView(
      children: [
        TextField(
            controller: txt,
            decoration: InputDecoration(
                suffix: IconButton(
                    onPressed: () async {
                      addConncetion(txt.text, ctx);
                      scaffold.currentState?.setState(() {});
                    },
                    icon: Icon(Icons.search)))),
        TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: Text('Close'))
      ],
    ),
  );
}
