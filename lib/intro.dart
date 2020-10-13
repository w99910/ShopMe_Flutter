import 'dart:convert';

import 'package:ShopMe/Login.dart';
import 'package:ShopMe/settings/variable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';
import 'SignUp.dart';
import 'models/User.dart';

void main() => runApp(IntroApp());

class IntroApp extends StatefulWidget {
  @override
  _IntroAppState createState() => _IntroAppState();
}

class _IntroAppState extends State<IntroApp> {
  Widget redirectPage = IntroPage();
  @override
  void initState() {
    super.initState();
    _checking();
  }

  _checking() async {
    SharedPreferences storage = await SharedPreferences.getInstance();

    var storedUser = storage.getString('user');

    if (storedUser != null) {
      Map userMap = await jsonDecode(storage.getString('user'));
      var user = User.fromJson(userMap);
      bool isRemember = await storage.getBool('remember');
      print(user);
      if (isRemember != null) {
        // redirectPage = Home(user);
        setState(() {
          redirectPage = Home(user);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        )),
        debugShowCheckedModeBanner: false,
        title: 'Intro',
        home: redirectPage);
  }
}

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: soft_pink,
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.1),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Text('ShopMe',
              //     style: GoogleFonts.dancingScript(
              //       textStyle: TextStyle(fontSize: 50),
              //     )),
              Container(
                height: height * 0.34,
                margin: EdgeInsets.only(top: height * 0.05),
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('lib/assets/images/welcome_.png'),
                        fit: BoxFit.cover)),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: height * 0.02),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Ease your shopping online with ShopMe',
                      style: TextStyle(fontSize: 22, color: cello),
                    )),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                    vertical: height * 0.03, horizontal: width * 0.05),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.3)),
                  color: cello,
                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 20, color: soft_pink),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.3)),
                  color: alert,
                  child: Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 20, color: soft_pink),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
