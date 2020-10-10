import 'package:ShopMe/Login.dart';
import 'package:ShopMe/api/api.dart';
import 'package:ShopMe/intro.dart';
import 'package:ShopMe/models/User.dart';
import 'package:ShopMe/settings/variable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _form = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  var _username, _email, _password;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back, color: cello),
          onTap: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => IntroPage()))
          },
        ),
      ),
      backgroundColor: soft_pink,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        height: height,
        width: width,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                BuildText(
                  text: 'Sign Up',
                  color: cello,
                  fontsize: 30,
                ),
                Container(
                  height: height * 0.6,
                  child: Form(
                      key: _form,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextFormField(
                            style: TextStyle(color: soft_pink),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 15),
                              icon: Icon(
                                Icons.person,
                                color: cello,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: height * 0.02,
                                  horizontal: width * 0.05),
                              hintText: 'User Name',
                              hintStyle: TextStyle(color: soft_pink),
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(height * 0.05)),
                              fillColor: cello,
                              focusColor: cello,
                              filled: true,
                            ),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'please enter some text';
                              }
                              return null;
                            },
                            onSaved: (String value) => _username = value,
                          ),
                          TextFormField(
                            style: TextStyle(color: soft_pink),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 15),
                              icon: Icon(
                                Icons.mail,
                                color: cello,
                              ),
                              hintText: 'Email',
                              hintStyle: TextStyle(color: soft_pink),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: height * 0.02,
                                  horizontal: width * 0.05),
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(height * 0.05)),
                              filled: true,
                              fillColor: cello,
                              focusColor: cello,
                            ),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'please enter some text';
                              }
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return 'Invalid Email';
                              }
                              return null;
                            },
                            onSaved: (String value) => _email = value,
                          ),
                          TextFormField(
                            controller: _pass,
                            obscureText: true,
                            style: TextStyle(color: soft_pink),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 15),
                              icon: Icon(
                                Icons.lock,
                                color: cello,
                              ),
                              hintText: 'Password',
                              hintStyle: TextStyle(color: soft_pink),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: height * 0.02,
                                  horizontal: width * 0.05),
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(height * 0.05)),
                              filled: true,
                              fillColor: cello,
                              focusColor: cello,
                            ),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'please enter some text';
                              }
                              if (value.length < 8) {
                                return 'Password length must be minimum 8';
                              }
                              return null;
                            },
                            onSaved: (String value) => _password = value,
                          ),
                          TextFormField(
                            controller: _confirmPass,
                            obscureText: true,
                            style: TextStyle(color: soft_pink),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 15),
                              icon: Icon(
                                Icons.lock_outline,
                                color: cello,
                              ),
                              hintText: 'Confirm Password',
                              hintStyle: TextStyle(color: soft_pink),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: height * 0.02,
                                  horizontal: width * 0.05),
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(height * 0.05)),
                              filled: true,
                              fillColor: cello,
                              focusColor: cello,
                            ),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'please enter some text';
                              }

                              if (value != _pass.text) {
                                return 'Unmatch password';
                              }
                            },
                            onSaved: (String value) => {},
                          ),
                          Container(
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.05),
                            width: double.infinity,
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.1,
                                  vertical: height * 0.015),
                              color: alert,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 0.1),
                              ),
                              onPressed: () {
                                if (!_form.currentState.validate()) {
                                  return;
                                }
                                _form.currentState.save();
                                final user = new User(
                                    name: _username,
                                    email: _email,
                                    password: _password);
                                print(user);
                                Api().signUp(user);
                              },
                              child: Center(
                                  child: Text(
                                'Sign Up',
                                style:
                                    TextStyle(color: soft_pink, fontSize: 20),
                              )),
                            ),
                          ),
                        ],
                      )),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: height * 0.005),
                  child: BuildText(
                    text: "Already have account?",
                    fontsize: 17,
                    color: cello,
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()))
                  },
                  child: BuildText(
                    text: 'Login Here',
                    color: cello,
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
    );
  }
}
