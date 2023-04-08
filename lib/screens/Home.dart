import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:convocom/global.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:convocom/firebasefn.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
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
  void initState() {
    // user.auth.currentUser?.updateDisplayName("Gopal S");
    // user.auth.currentUser?.updatePhoneNumber("+917592806009" as PhoneAuthCredential);
    super.initState();
    pagecontroller = PageController();
    _widgetOptions = [home(), community(), profile()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              user.signout(context);
            },
          ),
        ),
        //bottomNavigationBar: BottomNavBarCurvedFb1() ,//Remember to add extendBody: true to scaffold!,
        bottomNavigationBar: GNav(
            //rippleColor: Colors.grey[300]!,
            // hoverColor: Colors.grey[100]!,
            selectedIndex: _selectedIndex,
            backgroundColor: Colors.black,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
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

  List items = ['Kallu', 'Shravan', 'Adhi'];
  Container home() => Container(
      color: Colors.black,
      height: double.infinity,
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            // access element from list using index
            // you can create and return a widget of your choice
            return ListTile(
              title: Text(items[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatContainer(name: items[index])),
                );
              },
            );
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
}

class ChatContainer extends StatefulWidget {
  var name;
  ChatContainer({super.key, required this.name});

  @override
  State<ChatContainer> createState() => _ChatContainerState(this.name);
}

class _ChatContainerState extends State<ChatContainer> {
  var name;
  _ChatContainerState(this.name);
  final List<types.Message> _messages = [
    types.TextMessage(
      author: types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3bc'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: 'Haai',
    )
  ];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final _notuser = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3bc');
  @override
  Widget build(BuildContext context) => Scaffold(
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

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
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
    _addMessage(textMessage);
  }
}
