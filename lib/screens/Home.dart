//import 'dart:js';

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
import 'chatpage.dart';
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
  Container buildBottomSheet(BuildContext parent,
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
                      await addConncetion(txt.text, ctx);
                      setState(() {
                        
                      });
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
                    (ctx) => buildBottomSheet(context,ctx, _scaffoldKey));
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
              print(people.length);
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
                          child: Icon(Icons.person,)
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
                      for (int i = 0; i <= 10; i++)
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

