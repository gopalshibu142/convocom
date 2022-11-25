import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:animations/animations.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flip_card/flip_card.dart';
import 'package:lottie/lottie.dart';

import 'package:convocom/global.dart';

class Login extends StatefulWidget {
  late UserDetails user;
  Login({super.key, required UserDetails user}) {
    this.user = user;
  }

  @override
  State<Login> createState() => _LoginState(user);
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  LoginDetails logindetails = new LoginDetails();
  late UserDetails user;
  _LoginState(user) {
    this.user = user;
  }
  late FlipCardController flipcontroller;
  var obsecure = true;
  var titleop = 1.0;
  double oplvl = 0.0;
  var showlogin = false;
  Alignment titlealign = Alignment.center;
  late UI gui;
  @override
  void initState() {
    super.initState();
    gui = UI();
    flipcontroller = FlipCardController();
    Future.delayed(Duration(seconds: 2), (() {
      setState(() {
        titlealign = Alignment.topCenter;
      });
      Future.delayed(Duration(seconds: 1), (() {
        setState(() {
          oplvl = 1.0;
        });
      }));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          children: [
            Container(
                //height: double.infinity,
                width: double.infinity,
                height: double.infinity,
                child: Lottie.asset(gui.background, fit: BoxFit.fill)),
            AnimatedOpacity(
              opacity: titleop,
              duration: Duration(milliseconds: 500),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                padding: EdgeInsets.only(top: 90),
                alignment: titlealign,
                child: TextButton(
                  onPressed: () => setState(() {
                    gui.changeBG();
                    debugPrint(gui.background);
                  }),
                  child: Text("CONVOCOM",
                      style: GoogleFonts.permanentMarker(
                          color: gui.clrlog, fontSize: 38)),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: FlipCard(
                  flipOnTouch: false,
                  onFlip: () {},
                  controller: flipcontroller,
                  front: loginPage(),
                  back: signupPage()),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  AnimatedOpacity loginPage() {
    return AnimatedOpacity(
      opacity: oplvl,
      duration: const Duration(seconds: 3),
      child: Center(
        child: GlassmorphicContainer(
          width: 350,
          height: 450,
          borderRadius: 20,
          linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 53, 127, 247).withAlpha(10),
                Color.fromARGB(255, 13, 175, 234).withAlpha(10),
              ],
              stops: [
                0.3,
                1,
              ]),
          border: 1,
          blur: 1,
          borderGradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Color(0xFF4579C5).withAlpha(100),
                Color(0xFFFFFFF).withAlpha(55),
                Color(0xFFF75035).withAlpha(10),
              ],
              stops: [
                0.06,
                0.95,
                1
              ]),
          child: Container(
            padding: EdgeInsets.only(top: 30, left: 35, right: 35, bottom: 20),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style:
                      GoogleFonts.robotoFlex(color: gui.clrlog, fontSize: 28),
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: logindetails.loginemail.control,
                  style: GoogleFonts.roboto(color: gui.clrlog),
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: gui.clrlog),
                      hintText: "Enter your email",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: gui.clrlog,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: "email",
                      labelStyle: TextStyle(color: gui.clrlog),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: gui.clrlog,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      fillColor: gui.clrlog),
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: logindetails.loginpass.control,
                  obscureText: obsecure,
                  obscuringCharacter: '#',
                  style: GoogleFonts.roboto(color: gui.clrlog),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () => setState(() {
                        obsecure = !obsecure;
                      }),
                      icon: !obsecure
                          ? Icon(
                              Icons.visibility,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: Colors.red,
                            ),
                    ),
                    hintStyle: TextStyle(color: gui.clrlog),
                    hintText: "Enter your password",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(
                        color: gui.clrlog,
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: gui.clrlog,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    fillColor: gui.clrlog,
                    labelText: "Password",
                    labelStyle: TextStyle(color: gui.clrlog),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          print("🌛".toString());
                        },
                        child: Text("forgot password?")),
                    OutlinedButton(
                      onPressed: () async {
                        await user.signInWithEmailAndPassword(
                            email: logindetails.loginemail.control.text,
                            password: logindetails.loginpass.control.text);
                        if (user.success) {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      child: Text("Login"),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: gui.clrlog,
                          side: BorderSide(
                            color: gui.clrlog,
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "new here? ",
                      style: GoogleFonts.robotoFlex(color: gui.clrlog),
                    ),
                    Container(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            titleop = 0.0;
                          });

                          flipcontroller.toggleCard();
                        },
                        child: Text(
                          "Sign in",
                          style: GoogleFonts.roboto(fontSize: 18),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container signupPage() {
    return Container(
      child: Center(
        child: GlassmorphicContainer(
          width: 350,
          height: 600,
          borderRadius: 3,
          linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 53, 127, 247).withAlpha(10),
                Color.fromARGB(255, 13, 175, 234).withAlpha(10),
              ],
              stops: [
                0.3,
                1,
              ]),
          border: 1,
          blur: 1,
          borderGradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Color(0xFF4579C5).withAlpha(100),
                Color(0xFFFFFFF).withAlpha(55),
                Color(0xFFF75035).withAlpha(10),
              ],
              stops: [
                0.06,
                0.95,
                1
              ]),
          child: Container(
            padding: EdgeInsets.only(top: 20, left: 35, right: 35, bottom: 20),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Sign up",
                  style:
                      GoogleFonts.robotoFlex(color: gui.clrlog, fontSize: 28),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  style: GoogleFonts.roboto(color: gui.clrlog),
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: gui.clrlog),
                      hintText: "Enter your fullname",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: gui.clrlog,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: "name",
                      labelStyle: TextStyle(color: gui.clrlog),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: gui.clrlog,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      fillColor: gui.clrlog),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: logindetails.email.control,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.roboto(color: gui.clrlog),
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: gui.clrlog),
                      hintText: "Enter your email",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: gui.clrlog,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: "email",
                      labelStyle: TextStyle(color: gui.clrlog),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: gui.clrlog,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      fillColor: gui.clrlog),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: logindetails.pass.control,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: obsecure,
                  obscuringCharacter: '#',
                  style: GoogleFonts.roboto(color: gui.clrlog),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () => setState(() {
                        obsecure = !obsecure;
                      }),
                      icon: obsecure
                          ? Icon(
                              Icons.visibility,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: Colors.red,
                            ),
                    ),
                    hintStyle: TextStyle(color: gui.clrlog),
                    hintText: "Enter your password",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(
                        color: gui.clrlog,
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: gui.clrlog,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    fillColor: gui.clrlog,
                    labelText: "Password",
                    labelStyle: TextStyle(color: gui.clrlog),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.roboto(color: gui.clrlog),
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: gui.clrlog),
                      hintText: "Enter your phone number",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: gui.clrlog,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: "phone",
                      labelStyle: TextStyle(color: gui.clrlog),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: gui.clrlog,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      fillColor: gui.clrlog),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      child: DateTimePicker(
                        style: GoogleFonts.roboto(color: gui.clrlog),
                        initialDatePickerMode: DatePickerMode.year,
                        controller: logindetails.dob,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: gui.clrlog),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: gui.clrlog,
                                width: 2.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            labelText: "date of birth",
                            labelStyle: TextStyle(color: gui.clrlog),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: gui.clrlog,
                                width: 2.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            fillColor: gui.clrlog),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Date',
                        onChanged: (value) {
                          var dobyear =
                              DateTime.parse(logindetails.dob.text).year;
                          var age = DateTime.now().year - dobyear;
                          setState(() {
                            debugPrint(age.toString());
                            logindetails.age.control.text = age.toString();
                          });
                        },
                      ),
                    ),
                    Text(
                      'Age :',
                      style: TextStyle(color: gui.clrlog),
                    ),
                    Container(
                      width: 60,
                      child: TextField(
                        controller: logindetails.age.control,
                        readOnly: true,
                        style: GoogleFonts.roboto(color: gui.clrlog),
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: gui.clrlog),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: gui.clrlog,
                                width: 2.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            labelStyle: TextStyle(color: gui.clrlog),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: gui.clrlog,
                                width: 2.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            fillColor: gui.clrlog),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            titleop = 1.0;
                          });
                          flipcontroller.toggleCard();
                        },
                        child: Text("cancel")),
                    OutlinedButton(
                      onPressed: () async {
                        var snackbar;
                        await user.register(
                            email: logindetails.email.control.text,
                            password: logindetails.pass.control.text);
                        if (user.registered) {
                          snackbar = SnackBar(
                            content: const Text('Success'),
                            action: SnackBarAction(
                              label: 'ok',
                              onPressed: () {},
                            ),
                          );
                        } else {
                          snackbar = SnackBar(
                            content: Text(user.error),
                            action: SnackBarAction(
                              label: 'ok',
                              onPressed: () {},
                            ),
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      },
                      child: Text("Signup"),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: gui.clrlog,
                          side: BorderSide(
                            color: gui.clrlog,
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
