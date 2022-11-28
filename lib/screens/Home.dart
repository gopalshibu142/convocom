import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:convocom/global.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:convocom/firebasefn.dart';

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
    super.initState();
    pagecontroller = PageController();
    _widgetOptions = [
      home(),
      community(),
      profile()
    ];
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
                    curve: Curves.easeIn);
              });
            }),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pagecontroller,
          children: <Widget>[
            home(),
            community(),
            profile()
          ],
        ));
  }

  Container home() => Container(
        color: Colors.black,
        height: double.infinity,
      );
  Container community() => Container();
  Widget profile() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: temp,
            backgroundColor: Colors.black,
            child: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                setState(() {
                  temp == 100.0 ? temp = 50.0 : temp = 100.0;
                  debugPrint("Hellow");
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
