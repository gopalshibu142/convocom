import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  var obsecure = true;
  double oplvl = 0.0;
  var showlogin = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), (() {
      setState(() {
        oplvl = 1.0;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnimatedBackground(
        vsync: this,
        behaviour: SpaceBehaviour(),
        child: SafeArea(
            child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50),
              alignment: Alignment.topCenter,
              child: Text("CONVOCOM",
                  style: GoogleFonts.permanentMarker(
                      color: Colors.white, fontSize: 38)),
            ),
            AnimatedOpacity(
              opacity: oplvl,
              duration: const Duration(seconds: 3),
              child: Center(
                child: GlassmorphicContainer(
                  width: 350,
                  height: 450,
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
                    padding: EdgeInsets.only(
                        top: 20, left: 35, right: 35, bottom: 20),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: GoogleFonts.pacifico(
                              color: Colors.white, fontSize: 28),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          style: GoogleFonts.roboto(color: Colors.white),
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.white60),
                              hintText: "Enter your username",
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              labelText: "username",
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white60,
                                  width: 2.0,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              fillColor: Colors.white),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          obscureText: obsecure,
                          obscuringCharacter: '#',
                          style: GoogleFonts.roboto(color: Colors.white),
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
                            hintStyle: TextStyle(color: Colors.white60),
                            hintText: "Enter your password",
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white60,
                                width: 2.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            fillColor: Colors.white,
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: Text("forgot password?")),
                            OutlinedButton(
                              onPressed: () {},
                              child: Text("Login"),
                              style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.white,
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
                              "new here?",
                              style:
                                  GoogleFonts.robotoFlex(color: Colors.white70),
                            ),
                            TextButton(
                                onPressed: () {
                                  final snackbar =
                                      SnackBar(content: Text("sign in"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackbar);
                                },
                                child: Text(
                                  "Sign in",
                                  style: GoogleFonts.roboto(fontSize: 18),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        )),
      ),
    );
  }
}
