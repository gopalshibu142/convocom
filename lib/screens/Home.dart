//import 'dart:js';

import 'dart:io';
import 'package:convocom/firebasefn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:convocom/global.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'chatpage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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
  late String url;
  late UserDetails user;
  late List<Widget> _widgetOptions;
  late PageController pagecontroller;
  var temp = 50.0;
  UIColor theme = UIColor();
  int _selectedIndex = 0;
  @override
  var usermail;
  _HomeState(user) {
    this.user = user;
  }
  Future<void> initialize() async {
    url = await getProfileUrl(userId: curuser.uid);
  }

  late List people;
  void initState() {
    // user.auth.currentUser?.updateDisplayName("Gopal S");
    // user.auth.currentUser?.updatePhoneNumber("+917592806009" as PhoneAuthCredential);
    super.initState();
    initialize();
    pagecontroller = PageController();
    _widgetOptions = [home(), community(), profile()];
  }

  Container buildBottomSheet(BuildContext parent, BuildContext ctx,
      GlobalKey<ScaffoldState> scaffold) {
    TextEditingController txt = TextEditingController();
    return Container(
      // color: Colors.red,
      height: 300,
      padding: EdgeInsets.all(50),
      child: ListView(
        children: [
          Text(
            'Add User',
            textAlign: TextAlign.center,
          ),
          TextField(
              controller: txt,
              decoration: InputDecoration(
                  hintText: 'Enter the email ',
                  suffix: IconButton(
                      onPressed: () async {
                        await addConncetion(txt.text, ctx);
                        setState(() {});
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
  File? _imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: this._scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Convocom',
            style: GoogleFonts.roboto(),
          ),
          backgroundColor: theme.lvl1,
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              setState(() {
                var b = this._scaffoldKey.currentState?.showBottomSheet(
                    (ctx) => buildBottomSheet(context, ctx, _scaffoldKey));
                b?.closed.then((value) => setState(() {}));
              });
            }),
        //bottomNavigationBar: BottomNavBarCurvedFb1() ,//Remember to add extendBody: true to scaffold!,
        bottomNavigationBar: GNav(
            //rippleColor: Colors.grey[300]!,
            // hoverColor: Colors.grey[100]!,
            selectedIndex: _selectedIndex,
            backgroundColor: theme.lvl1,
            tabs: [
              GButton(
                icon: Icons.message,
                text: 'Chat',
              ),
              GButton(
                icon: Icons.people,
                text: 'Status',
                onPressed: () {},
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
      color: Color(0xff03001C),
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
                      decoration: BoxDecoration(
                          //color: Color(0xff03001C),
                          border: Border(
                              top: BorderSide(
                                color: Colors.black38,
                              ),
                              bottom: BorderSide(
                                  // style: BorderStyle.solid,
                                  color: Colors.black38))),
                      alignment: Alignment.center,
                      height: 100,
                      width: double.infinity,
                      child: ListTile(
                        leading: CircleAvatar(
                          minRadius: 49,
                          backgroundColor: Colors.grey,
                          maxRadius: 60,
                          backgroundImage: AssetImage('assets/person.png'),
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

  Container community() => Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        color: theme.lvl0,
        child: Text('Coming soon'),
      );
  Widget profile() {
    return Container(
      color: Color(0xff03001C),
      padding: EdgeInsets.only(top: 20),
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              GestureDetector(
                onTap: () async {
                  var status = await Permission.photos.isGranted;
                  if (!status) {
                    await Permission.photos.request();
                    await Permission.storage.request();
                  }
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  setState(() {
                    //print(pickedFile!.path);
                    _imageFile = File(pickedFile!.path);
                  });
                  uploadProfile(_imageFile);
                },
                child: CircleAvatar(
                  radius: 82,
                  backgroundColor: theme.lvl2,
                  child: CircleAvatar(
                      radius: 80,
                      backgroundColor: theme.lvl1,
                      
                      backgroundImage: NetworkImage(url)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("email : ${user.auth.currentUser?.email}\n"),
              Text("name : ${user.auth.currentUser?.displayName}\n"),
              Text("phone : ${user.auth.currentUser?.phoneNumber}\n"),
              TextButton(
                  onPressed: () {
                    user.signout(context);
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(color: theme.lvl3, fontSize: 18),
                  ))
              //Text("phone : ${user.auth.currentUser?.email}"),
            ],
          );
        }
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
