import 'package:ShopMe/SignUp.dart';
import 'package:ShopMe/api/Api.dart';
import 'package:ShopMe/settings/variable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Home.dart';
import 'models/User.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _email;
  var _password;
  bool _remember = false;
  bool _password_secure = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _isLoading
            ? Container()
            : GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back),
              ),
      ),
      backgroundColor: cello,
      body: Stack(children: [
        Opacity(
          opacity: _isLoading ? 1 : 0,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        Opacity(
          opacity: _isLoading ? 0 : 1,
          child: Container(
            height: height,
            width: width,
            padding: EdgeInsets.symmetric(
                vertical: height * 0.15, horizontal: width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 30,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                      color: soft_pink,
                    ),
                  ),
                  Container(
                      height: height * 0.4,
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: width * 0.05,
                                      vertical: height * 0.015),
                                  icon: Icon(
                                    Icons.person,
                                    color: soft_pink,
                                  ),
                                  hintText: 'Email',
                                  isDense: true,
                                  border: new OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(height * 0.05)),
                                  filled: true,
                                  fillColor: soft_pink,
                                  focusColor: soft_pink,
                                ),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'please enter some text';
                                  }
                                  return null;
                                },
                                onSaved: (String value) => _email = value,
                              ),
                              TextFormField(
                                textAlign: TextAlign.left,
                                obscureText: _password_secure,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: width * 0.05,
                                        vertical: height * 0.015),
                                    icon: Icon(
                                      Icons.lock,
                                      color: soft_pink,
                                    ),
                                    hintText: 'Password',
                                    isDense: true,
                                    border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            height * 0.05)),
                                    fillColor: soft_pink,
                                    focusColor: soft_pink,
                                    filled: true,
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _password_secure = !_password_secure;
                                        });
                                      },
                                      child: Icon(Icons.visibility),
                                    )),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'please enter some text';
                                  }
                                  return null;
                                },
                                onSaved: (String value) => _password = value,
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      value: _remember,
                                      onChanged: (bool value) {
                                        setState(() {
                                          _remember = value;
                                          print(_remember);
                                        });
                                      }),
                                  Text('Remember Me',
                                      style: TextStyle(
                                          fontSize: 16, color: soft_pink)),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: width * 0.05),
                                width: double.infinity,
                                child: FlatButton(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.1,
                                      vertical: height * 0.02),
                                  color: alert,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(height * 0.1),
                                  ),
                                  onPressed: () {
                                    if (!_formKey.currentState.validate()) {
                                      return;
                                    }
                                    _formKey.currentState.save();
                                    User user = new User(
                                        email: _email, password: _password);
                                    print(user.email + '' + user.password);
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    information(user, _remember, context)
                                        .listen((result) {
                                      print(result);
                                      if (result == false) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    });
                                  },
                                  child: Center(
                                      child: Text(
                                    'Login',
                                    style: TextStyle(
                                        color: soft_pink, fontSize: 19),
                                  )),
                                ),
                              )
                            ],
                          ))),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: height * 0.01),
                    child: BuildText(
                      text: "Don't have account?",
                      fontsize: 17,
                      color: soft_pink,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp()))
                    },
                    child: BuildText(
                      text: 'Sign Up Here',
                      color: soft_pink,
                      fontsize: 17,
                      bold: FontWeight.bold,
                      italic: FontStyle.italic,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

Stream<bool> information(
    User user, bool isRemember, BuildContext context) async* {
  final User authuser = await Api().signIn(user, isRemember);
  print(authuser);
  if (authuser == null) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
              title: Center(
                child: Icon(
                  Icons.error,
                  size: 30,
                  color: Colors.red,
                ),
              ),
              content: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Center(
                      child: Text('Incorrect Credentials..Please Try again'))),
              elevation: 0,
            ));
    yield false;
  } else {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Home(authuser)));
  }
}
